WITH P_joueur, P_Action, P_Carte, P_Utils, P_Pot, Ada.Strings.Unbounded, gui;
USE P_joueur, P_Action, P_Carte, P_Utils, P_Pot, Ada.Strings.Unbounded;

Package body P_table is
   
   
   
   procedure Lancer_Partie is
      reste : Natural := 0;
      fresh,playing, done, endOfGame, allIn, masterAllIn, skipBlank : boolean := true;
      nb_joueurs : Natural := gui.getNJoueurs;
   begin
      declare
         table : T_Table(nb_joueurs);
         firstTurn : boolArray(1..nb_joueurs);
      begin
         resetGenerator;							-- On initialise l'aleatoire
         table := gui.makeTable(nb_joueurs);
         
         while not lastOneStanding(table, false, true) loop			-- Tant qu'il y a plus d'un joueur
            gui.monterBlindes(table);
            Debut_manche(table, reste, masterAllIn);
            endOfGame := false;
            skipBlank := true;
            
            while not endOfGame loop						-- Boucle de manche
               if masterAllIn then
                  allIn := true;
                  masterAllIn := False;
               else
                  allIn := False;
               end if;
               if table.nb_cartes_ouvertes >0 then
                  table.index_joueur_actif := table.index_dealer;
               end if;
               
               firstTurn := (others => true);
               playing := true;
               fresh := true;
               while playing loop						-- Boucle d'un tour de table
                  declare
                  begin
                     joueurSuivant(table,true,true);				-- On ne fait jouer que les joueurs actifs
                     done := false;
                     playing := not(table.index_joueur_actif = table.joueurs_mise_max) and
                       ( not(lastOneStanding(table, true, true)) or (allIn and firstTurn(table.index_joueur_actif)) );
                     if fresh then
                        table.mise_max := 0;
                        table.joueurs_mise_max := table.index_joueur_actif;
                        table.nb_relances := 0;
                        
                        playing := true;
                        fresh := False;
                     end if;
                  exception
                     when Invalid_State_Exception =>
                        playing := False;
                  end;
                  
                  if not playing then
                     done := true;
                  else
                     if skipBlank then
                        skipBlank := False;
                     else
                        gui.printBlank(5);
                     end if;
                     firstTurn(table.index_joueur_actif) := False;
                  end if;
                  while not done loop						-- Tant qu'une action valide n'a pas etee choisie
                     declare
                        act : T_Action := gui.playTurn(table, table.joueurs(table.index_joueur_actif), table.index_joueur_actif,
                                                       table.index_joueur_actif=table.index_dealer);
                     begin							-- On recupere l'action et on la traite
                        case getElem(act) is
                           when Miser =>
                              if table.nb_relances < 3 then			-- On verifie qu'il y a possibilite de relance
                                 if getMise(act) >= table.mise_max*2 and getMise(act) >= table.blindes(2) then
                                    done := jouerTour(table.mise_max, table.joueurs(table.index_joueur_actif), act);
                                    if done then
                                       if table.mise_max > 0 then
                                          table.nb_relances := table.nb_relances +1;
                                       end if;
                                       table.mise_max := getMise(act);
                                       table.joueurs_mise_max := table.index_joueur_actif;
                                    end if;
                                 else
                                    gui.mustMiseMore;
                                 end if;
                              else
                                 gui.cannotMise;
                              end if;
                           when Tapis =>
                              done := jouerTour(table.mise_max,table.joueurs(table.index_joueur_actif),act);
                              allIn := done;
                              if done then
                                 table.mise_max := getMise(act);
                                 table.joueurs_mise_max := table.index_joueur_actif;
                              end if;
                           when Suivre =>
                              if table.nb_cartes_ouvertes < 3 and table.mise_max < table.blindes(2) then
                                 gui.mustPay;					-- Avant le flop et pas de mise
                              else
                                 done := jouerTour(table.mise_max,table.joueurs(table.index_joueur_actif),act);
                              end if;
                           when Coucher =>
                              done := jouerTour(table.mise_max,table.joueurs(table.index_joueur_actif),act);
                        end case;
                     exception
                        when Has_To_All_In_Exception =>
                           gui.hasToAllIn;
                           done := false;
                        when others => raise;
                     end;
                  end loop;
               end loop;
               
               if allIn then
                  updatePots(table);
               else
                  reste := 0;
                  for i in 1..table.nb_joueurs loop
                     reste := reste + getMise(table.joueurs(i));
                  end loop;
                  addArgentToLastPot(table, reste);
               end if;
               
               for i in 1..table.nb_joueurs loop
                  finTour(table.joueurs(i));
               end loop;
               
               endOfGame := lastOneStanding(table, true, true);
               if endOfGame then
                  if allin then
                     while table.nb_cartes_ouvertes < 5 loop
                        Poser_cartes_ouvertes(table);
                     end loop;
                  end if;
               else
                  if table.nb_cartes_ouvertes < 5 then
                     Poser_cartes_ouvertes(table);
                  else
                     endOfGame := true;
                  end if;
               end if;
            end loop;
            
            Fin_manche(table, reste);
         end loop;
         
         gui.printBlank(25);
         for i in 1..table.nb_joueurs loop
            if getArgent(table.joueurs(i)) >0 then
               gui.winGame(getName(table.joueurs(i)));
            end if;
         end loop;
      end;
   end;
   
   function creeTable(joueurs : in out tabJoueur; n : in Positive) return T_Table is
      table : T_Table(n);     
   begin
      --blindes
      table.blindes(1) := 25;
      table.blindes(2) := 50;
      
      table.nb_relances := 0;
      table.index_dealer := 0;
      table.index_joueur_actif := 1;
      table.mise_max := 0;
      table.joueurs_mise_max := 0;
      table.joueurs := joueurs;
      --cartes ouvertes
      table.nb_cartes_ouvertes := 0;
      --deck
      table.deck.deck := deckComplet;
      table.deck.carteSuivante := 1;
      -- On genere les pots a chaque debut de manche
      return table;
   end;
   
   procedure Monter_blindes(table : in out T_Table; nMin : in Natural; nMax : in Natural) is
   begin
      table.blindes(2):=nMax;
      table.blindes(1):=nMin;
   end;
   
   
   function toString (table : in T_Table) return String is
      ret : Unbounded_String;
   begin
      if table.nb_cartes_ouvertes > 0 then
         ret := To_Unbounded_String("Cartes ouvertes : [\");
         for i in 1..table.nb_cartes_ouvertes loop
            ret := ret& toString(table.cartes_ouvertes(i))& "\";
         end loop;
         ret := ret& "]";
      else
         ret := ret& "Il n'y a pas encore de carte ouverte";
      end if;
      
      ret := ret& "\Recapitulatif des differents joueurs :\";
      for i in 1..table.nb_joueurs loop
         if i /= table.index_joueur_actif then
            ret := ret& toStringShort(table.joueurs(i), i = table.index_dealer);
         else
            ret := ret& " - Vous";
            if i = table.index_dealer then
               ret := ret& " [DEALER]";
            end if;
            ret := ret& "\";
         end if;
      end loop;
      
      if table.mise_max > 0 then
         ret := ret& "\La mise actuelle est de : "& Integer'Image(table.mise_max)& "\";
      else
         ret := ret& "\La mise minimale est de : "& Integer'Image(table.blindes(2))& "\";
      end if;
      return To_String(ret);
   end;
   
   function endRecap (table : in T_Table) return String is
      ret : Unbounded_String;
   begin
      if table.nb_cartes_ouvertes > 0 then
         ret := To_Unbounded_String("Cartes ouvertes : [\");
         for i in 1..table.nb_cartes_ouvertes loop
            ret := ret& toString(table.cartes_ouvertes(i))& "\";
         end loop;
         ret := ret& "]";
      else
         ret := ret& "Il n'y a pas de carte ouverte";
      end if;
      
      ret := ret& "\Recapitulatif des differents joueurs :\";
      for i in 1..table.nb_joueurs loop
         ret := ret& getName(table.joueurs(i))& " : "& montrerMain(table.joueurs(i));
         ret := ret& "\";
      end loop;
      return To_String(ret);
   end;
   
   function getPots(table : in T_Table; joueur :in Positive) return String is
      ret : Unbounded_String;
      pots : posArray := findPots(table, joueur);
   begin
      ret := To_Unbounded_String("Les pots qui sont ouverts au joueur sont : \");
      for i in pots'Range loop
         ret := ret& "  - "& Integer'Image(getPotArgent(table.pots(pots(i))))& "\";
      end loop;
      return To_String(ret);
   end;
      
   -- PRIVATE
   
   procedure Distribuer_main (table : in out T_Table) is
      temp : T_Deck(1..2);
   begin									-- Par simplicite, on distibue les cartes par paires et en partant du meme joueur
      for n in 1..table.nb_joueurs loop
         if getArgent(table.joueurs(n)) > 0 then				-- Si le joueur est dans la partie
            for i in 1..2 loop
               temp(i) := piocherCarte(table);
            end loop;								-- Utilisation de la procedure de P_Joueur
            prendreCartes(temp, table.joueurs(n));
         end if;
      end loop;
   end;
   
   procedure Poser_cartes_ouvertes (table : in out T_Table) is
      trash : T_Carte;
   begin
      case table.nb_cartes_ouvertes is						-- On implémente les "burn" de cartes pour simuler une vraie partie
         when 0 =>
            trash := piocherCarte(table);
            for i in 1..3 loop
               table.cartes_ouvertes(i) := piocherCarte(table);
            end loop;
            table.nb_cartes_ouvertes := 3;
         when 3 =>
            trash := piocherCarte(table);
            table.cartes_ouvertes(4) := piocherCarte(table);
            table.nb_cartes_ouvertes := 4;
         when 4 =>
            trash := piocherCarte(table);
            table.cartes_ouvertes(5) := piocherCarte(table);
            table.nb_cartes_ouvertes := 5;
         when others =>								-- On ne doit pas rajouter de cartes si la table est pleine !
            raise Invalid_State_Exception with "La table est deja pleine !";
      end case;
   end;
      
   procedure Debut_manche (table : in out T_Table; reste : in Natural; allIn : out boolean) is
      nAlive : Natural := 0;
   begin
      allIn := false;
      for i in 1..table.nb_joueurs loop
         if isPlaying(table.joueurs(i)) then
            nAlive := nAlive +1;
         end if;
      end loop;
      declare
         nPot : posArray(1..nAlive);
         i : Positive := 1;
      begin
         Melange_deck(table);
         Distribuer_main(table);
         
         table.nb_relances := 0;
         table.index_dealer := table.index_dealer+1;
         table.mise_max := table.blindes(2);
         table.joueurs_mise_max := 0;
         table.nb_cartes_ouvertes := 0;
         clear(table.pots);
         
         for n in 1..table.nb_joueurs loop						-- On prepare la liste de joueurs
            if getArgent(table.joueurs(n)) > 0 then
            nPot(i) := n;
               i := i+1;
            end if;
         end loop;
         
         append(table.pots, creerPot(nPot));					-- On cree le premier pot
                                                 
         if reste >0 then							-- S'il reste de l'argent non partage
            addArgentToLastPot(table, reste);
         end if;
         
         table.index_joueur_actif := table.index_dealer;
         joueurSuivant(table, true, false);					-- Petite blinde
         poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(1));
         joueurSuivant(table, true, false);					-- Grosse blinde
         poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(2));
         table.joueurs_mise_max := table.index_joueur_actif;
      exception
         when Has_To_All_In_Exception =>
            allIn := True;
            when others => raise;
      end;
   end;
   
   procedure Fin_manche (table : in out T_Table; reste : out Natural) is
   begin
      gui.printBlank(10);
      gui.decodeString(endRecap(table));
      reste :=0;
      while Integer(Length(table.pots)) > 0 loop
         if getPotArgent(Last_Element(table.pots)) > 0 then
            declare
               players : posArray := getJoueurs(Last_Element(table.pots));
               cartes : T_Deck(1..(2+table.nb_cartes_ouvertes));
               tempCartes : T_Deck(1..2);
               tempCombi, bestCombi : T_Combinaison;
               bestJoueur : natArray(1..players'Length) := (others=>0);
               nBests : Natural :=0;
            begin
               if players'Length > 1 then
                  if table.nb_cartes_ouvertes > 0 then				-- On prepare les cartes ouvertes
                     for i in 3..2+table.nb_cartes_ouvertes loop
                        cartes(i) := table.cartes_ouvertes(i-2);
                     end loop;
                  end if;							-- On initialise le premier joueur comme meilleur
                                 
                  nBests := 1;
                  bestJoueur(1) := 1;
                  tempCartes := getCartes(table.joueurs(players(1)));
                  cartes(1) := tempCartes(1);
                  cartes(2) := tempCartes(2);
                  bestCombi := trouverCombinaison(cartes);
                  
                  for i in (players'First+1)..players'Last loop
                     tempCartes := getCartes(table.joueurs(players(i)));
                     cartes(1) := tempCartes(1);
                     cartes(2) := tempCartes(2);
                     tempCombi := trouverCombinaison(cartes);
                     case compaCombi(bestCombi, tempCombi) is
                     when inf =>						-- Si la combinaison se fait battre, on prend un nouveau gagnant
                        bestJoueur := (others =>0);
                        nBests := 1;
                        bestJoueur(1) := i;
                        bestCombi := tempCombi;
                     when ega =>						-- En cas d'egalite on ajoute le joueur a la liste des gagnants
                        nBests := nBests+1;
                        bestJoueur(nBests) := i;
                     when sup =>
                        null;							-- La meilleur combinaison est plus forte
                     end case;
                  end loop;
                  
                  if nBests > 1 then
                     declare
                        mise : Natural := getPotArgent(Last_Element(table.pots));
                     begin							-- Chaque joueur gagne un fraction du pot et le reste est
                        reste := reste + mise mod nBests;			--	conserve pour la partie suivante
                        mise := mise / nBests;
                        for i in 1..nBests loop
                           gagnerMise(mise, table.joueurs(players(bestJoueur(i))));
                           gui.winRound(getName(table.joueurs(players(bestJoueur(i)))), mise);
                        end loop;
                     end;
                  else								-- Cas d'un seul gagnant
                     gagnerMise(getPotArgent(Last_Element(table.pots)),table.joueurs(players(bestJoueur(1))));
                     gui.winRound(getName(table.joueurs(players(bestJoueur(1)))), getPotArgent(Last_Element(table.pots)));
                  end if;
               else								-- Un joueur seul dans le pot ne peut que gagner
                  gagnerMise(getPotArgent(Last_Element(table.pots)),table.joueurs(players(1)));
                  gui.winRound(getName(table.joueurs(players(1))),getPotArgent(Last_Element(table.pots)));
               end if;
            end;
         end if;
         Delete_Last(table.pots);
      end loop;
      
      for i in 1..table.nb_joueurs loop
         finManche(table.joueurs(i));
      end loop;
   end;
   
   procedure Melange_deck (table : in out T_Table) is
   begin									-- On remelange le meme deck de cartes
      table.deck.deck := shuffle(1, nombreMaxCartes, table.deck.deck);
      table.deck.carteSuivante := 1;
   end;
      
   function piocherCarte(table : in out T_Table) return T_Carte is
      ret : T_Carte;
   begin
      if table.Deck.carteSuivante <= nombreMaxCartes then
         ret := table.deck.deck(table.deck.carteSuivante);
         table.deck.carteSuivante := table.deck.carteSuivante + 1;
      else									-- On envoie une exception si on a pioché toutes les cartes du deck
         raise No_More_Cards_Exception with "Toutes les cartes ont ete piochees";
      end if;
      return ret;
   end;
      
   procedure joueurSuivant(table : in out T_Table; alive :in boolean; inGame : in boolean) is
      ok : boolean;
      noone : Boolean := True;
   begin
      if lastOneStanding(table,alive,inGame) then				-- S'il ne reste qu'une personne
         if ( (not alive) or getArgent(table.joueurs(table.index_joueur_actif))  > 0)
           and ( (not inGame) or isPlaying(table.joueurs(table.index_joueur_actif)) ) then
            raise Invalid_State_Exception;					-- Et que c'est le joueur actif
         end if;
      end if;
      for i in 1..table.nb_joueurs loop						-- S'il ne reste personne
         if noone and then (((not alive) or getArgent(table.joueurs(i)) > 0)
                               and ((not inGame) or isPlaying(table.joueurs(i)))) then
            noone := false;
         end if;
      end loop;
      if noone then
         raise Invalid_State_Exception;
      end if;
      
      ok := false;
      while not ok loop
         if table.index_joueur_actif < table.nb_joueurs then
            table.index_joueur_actif := table.index_joueur_actif +1;
         else
            table.index_joueur_actif := 1;
         end if;
         ok := ((not alive) or getArgent(table.joueurs(table.index_joueur_actif)) > 0) and ((not inGame) or isPlaying(table.joueurs(table.index_joueur_actif)));
      end loop;
   end;
   
   function findPots(table : in T_Table; joueur : in Positive) return posArray is
      retSize : Natural :=0;
   begin
      for i in 1..Integer(Length(table.pots)) loop
         if isJoueurIn(Element(table.pots, i), joueur) then
            retSize := retSize +1;
         end if;
      end loop;
      if retSize > 0 then
         declare
            ret : posArray(1..retSize);
            k : Positive :=1;
         begin
            for i in 1..Integer(Length(table.pots)) loop
               if isJoueurIn (Element(table.pots, i) , joueur) then
                  ret(k) := i;
                  k := k+1;
               end if;
            end loop;
            return ret;
         end;
      else
         declare
            ret : posArray(1..1);
         begin
            ret(1) := table.nb_joueurs+1;
            return ret;
         end;
      end if;
   end;
   
   function lastOneStanding(table : in T_Table; alive :in boolean; inGame : in boolean) return boolean is
      one : boolean := false;
   begin
      for i in 1..table.nb_joueurs loop
         if ((not alive) or getArgent(table.joueurs(i)) > 0) and ((not inGame) or isPlaying(table.joueurs(i))) then
            if one then
               return false;
            else
               one := true;
            end if;
         end if;
      end loop;

      return one;
   end;
   
   procedure updatePots(table : in out T_Table) is
      n : Integer := 0;
      sumMises : Natural := 0;
   begin
      for i in 1..table.nb_joueurs loop
         if isPlaying(table.joueurs(i)) and then getMise(table.joueurs(i)) < table.mise_max then
            n := n+1;
         end if;
      end loop;
      if n > 0 then								-- Si certains n'ont pas reussit a payer
         declare
            listJ, mises : natArray(1..n);
            k : Positive := 1;
            nMises : Natural := 0;
         begin
            for i in 1..table.nb_joueurs loop					-- On trouve les joueurs
               if isPlaying(table.joueurs(i)) and then getMise(table.joueurs(i)) < table.mise_max then
                  listJ(k) := i;
                  k := k+1;
               end if;
            end loop;
            
            for i in 1..n loop							-- Et leur mises respectives
               mises(i) := getMise(table.joueurs(listJ(i)));
            end loop;
            
            if n =1 then							-- Si il n'y a que un joueur different
               sumMises := 0;
               for i in 1..table.nb_joueurs loop
                  if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) >= mises(1) then
                     sumMises := sumMises+mises(1);
                  end if;
               end loop;
               addArgentToLastPot(table,sumMises);
               
               n := 0;
               for i in 1..table.nb_joueurs loop				-- On recupere le nombre de joueur pour le nouveau pot
                  if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) > mises(1) then
                     n := n+1;
                  end if;
               end loop;
               
               declare
                  jList : posArray(1..n);
               begin
                  k:=1;
                  for i in 1..table.nb_joueurs loop				-- On prépare le nouveau pot et on le remplit
                     if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) > mises(1) then
                        jList(k) := i;
                        k := k+1;
                     end if;
                  end loop;
                  
                  Append(table.pots,creerPot(jList));
                  sumMises := 0;
                  for i in 1..n loop
                     sumMises := sumMises + getMise(table.joueurs(jList(i)))-mises(1);
                  end loop;
                  addArgentToLastPot(table,sumMises);
               end;
            else
               for i in 2..n loop						-- On compte le nombre de mises différentes
                  if not (mises(1) = mises(i)) then
                     nMises := nMises +1;
                  end if;
               end loop;
               if nMises > 0 then						-- S'il y a plusieurs mises différentes
                  declare
                     misesDiff, jMisesDiff : natArray(1..nMises+1) := (others => 0);
                     inArray : boolean;
                     indexMisesDiff : Positive :=1;
                  begin
                     for i in 1..n loop
                        inArray :=false;
                        for m in 1..nMises+1 loop
                           if misesDiff(m) = mises(i) then
                              inArray := true;
                              jMisesDiff(m) := jMisesDiff(m)+1;
                           end if;
                        end loop;
                        if not inArray then					-- On recupere toutes les mises différentes et les joueurs concernes
                           misesDiff(indexMisesDiff) := mises(i);
                           jMisesDiff(indexMisesDiff) := 1;
                           indexMisesDiff := indexMisesDiff+1;
                        end if;
                     end loop;
                     
                     doubleSort(misesDiff,jMisesDiff);
                     
                     for i in 1..(nMises+1) loop				-- Pour chacune des mises differentes il faut creer un pot
                        declare							-- On les cree et le remplits un par un
                           players : posArray(1..jMisesDiff(i));
                           m : Positive := 1;
                           alreadyPaid : Natural :=0;
                        begin
                           sumMises := 0;
                           for k in 1..table.nb_joueurs loop			-- On trouve les joueurs
                              if isPlaying(table.joueurs(k)) and getMise(table.joueurs(k)) >= misesDiff(i) then
                                 sumMises := sumMises + 1;
                                 players(m) := k;
                                 m := m+1;
                              end if;
                           end loop;
                           for k in 1..(i-1) loop				-- On trouve ce qui a ete distribue dans les pots precedents
                              alreadyPaid := alreadyPaid + misesDiff(k);
                           end loop;
                           
                           sumMises := sumMises*(misesDiff(i)-alreadyPaid);	-- On ne fait payer que la bonne chose avant de creer un nouveau pot
                           addArgentToLastPot(table, sumMises);
                           Append(table.pots, creerPot(players));
                        end;
                     end loop;
                  end;
               else								-- S'il n'y a qu'une mise
                  sumMises := 0;
                  for i in 1..table.nb_joueurs loop
                     if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) >= mises(1) then
                        sumMises := sumMises + mises(1);
                     end if;
                  end loop;
                  addArgentToLastPot(table,sumMises);
                  
                  n := 0;
                  for i in 1..table.nb_joueurs loop				-- On recupere le nombre de joueur pour le nouveau pot
                     if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) > mises(1) then
                        n := n+1;
                     end if;
                  end loop;
               
                  declare
                     jList : posArray(1..n);
                  begin
                     k:=1;
                     for i in 1..table.nb_joueurs loop				-- On prépare le nouveau pot et on le remplit
                        if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) > mises(1) then
                           jList(k) := i;
                           k := k+1;
                        end if;
                     end loop;
                  
                     Append(table.pots,creerPot(jList));
                     
                     sumMises := 0;
                     for i in 1..n loop
                        sumMises := sumMises + getMise(table.joueurs(jList(i)))-mises(1);
                     end loop;
                     addArgentToLastPot(table,sumMises);
                  end;
               end if;
            end if;
         end;
      else									-- Si tous les joueurs on paye la meme chose
         sumMises := 0;
         for i in 1..table.nb_joueurs loop
            sumMises := sumMises + getMise(table.joueurs(i));
            if isPlaying(table.joueurs(i)) and getArgent(table.joueurs(i)) > 0 then
               n := n+1;
            end if;
         end loop;								-- On ajoute l'argent dans le pot et on cree un nouveau pot pour la suite
         addArgentToLastPot(table,sumMises);
         declare
            jPots : posArray(1..n);
            k : Positive := 1;
         begin
            for i in 1..table.nb_joueurs loop
               if isPlaying(table.joueurs(i)) and getArgent(table.joueurs(i)) > 0 then
                  jPots(k) := i;
                  k := k+1;
               end if;
            end loop;
            Append(table.pots, creerPot(jPots));
         end;
      end if;
   end;
   
   procedure addArgentToLastPot(table : in out T_Table; montant : in Integer) is
   begin
      if montant>0 then
         declare
            nPot : T_Pot := clonerPot(Last_Element(table.pots));
         begin
            addArgent(nPot, montant);
            Replace_Element(table.pots, Last_Index(table.pots), nPot);
         end;
      end if;
   end;
   
   
   function natCompa(n1 : Natural; n2 :Natural) return boolean is
   begin
      return n1 > n2;								-- Mene a un tri dans l'ordre croissant
   end;
   
   
   
   
end P_table;
