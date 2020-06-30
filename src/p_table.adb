WITH P_joueur, P_Action, P_Carte, P_Utils, P_Pot, Ada.Strings.Unbounded, gui;
USE P_joueur, P_Action, P_Carte, P_Utils, P_Pot, Ada.Strings.Unbounded;

Package body P_table is
   
   
   
   procedure Lancer_Partie is
      nAlive : Natural;
      playing, done, endOfGame, allIn : boolean := true;
      nb_joueurs : Natural := gui.getNJoueurs;
   begin
      declare
         table : T_Table(nb_joueurs);
      begin
         table := gui.makeTable(nb_joueurs);
         
         nAlive := table.nb_joueurs;
         while nAlive > 1 loop							-- Tant qu'il y a plus d'un joueur
            Debut_manche(table, nAlive);
            endOfGame := false;
            while not endOfGame loop
               allIn := false;
               while playing loop
                  joueurSuivant(table,true,true);
                  playing := table.index_joueur_actif = table.joueurs_mise_max;
                  if isPlaying(table.joueurs(table.index_joueur_actif)) then	-- On ne fait jouer que les joueurs actifs
                     done := false;
                     while not done loop					-- Tant qu'une action valide n'a pas etee choisie
                        declare
                           act : T_Action := gui.playTurn(table, table.joueurs(table.index_joueur_actif), table.index_joueur_actif);
                        begin							-- On recupere l'action et on la traite
                           case getElem(act) is
                           when Miser =>
                              if table.nb_relances < 3 then			-- On verifie qu'il y a possibilite de relance
                                 if getMise(act) > table.mise_max*2 then
                                    done := jouerTour(table.mise_max, table.joueurs(table.index_joueur_actif), act);
                                    table.joueurs_mise_max := table.index_joueur_actif;
                                 else
                                    gui.mustMiseMore;
                                 end if;
                              else
                                 gui.cannotMise;
                              end if;
                           when Tapis =>
                              done := jouerTour(table.mise_max,table.joueurs(table.index_joueur_actif),act);
                              allIn := true;
                           when others =>
                              done := jouerTour(table.mise_max,table.joueurs(table.index_joueur_actif),act);
                           end case;
                        exception
                           when Has_To_All_In_Exception =>
                              gui.hasToAllIn;
                              done := false;
                           when others => null;
                        end;
                     end loop;
                  end if;
               end loop;
               
               if allIn then
                  updatePots(table);
               end if;
               
               if table.nb_cartes_ouvertes < 5 then
                  Poser_cartes_ouvertes(table);
               else
                  endOfGame := true;
               end if;
            end loop;
               
            Fin_manche(table);
            
            nAlive := 0;
            for i in 1..table.nb_joueurs loop
               if getArgent(table.joueurs(i)) > 0 then
                  nAlive := nAlive +1;
               end if;
            end loop;
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
      table.index_dealer := 1;
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
   
   function getMiseMax(table : in T_Table) return Natural is
   begin
      return table.mise_max;
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
      ret := ret& "\\La mise actuelle est de : "& Integer'Image(table.mise_max)& "\";
      ret := ret& "La mise minimale est de : "& Integer'Image(table.blindes(2))& "\";
      return To_String(ret);
   end;
   
   function getPots(table : in T_Table; joueur :in Positive) return String is
      ret : Unbounded_String;
      pots : posArray := findPots(table, joueur);
   begin
      ret := To_Unbounded_String("Les pots qui sont ouverts au joueur sont : ");
      for i in pots'Range loop
         ret := ret& " - "& Integer'Image(getPotArgent(table.pots(pots(i))))& "\";
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
      
   procedure Debut_manche (table : in out T_Table; nAlive : in Natural) is
      nPot : posArray(1..nAlive);
      i : Positive := 1;
   begin
      Melange_deck(table);
      Distribuer_main(table);
      
      table.nb_relances := 0;
      table.mise_max := 0;
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
      
      table.index_joueur_actif := table.index_dealer;
      joueurSuivant(table, true, false);					-- Petite blinde
      poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(1));
      joueurSuivant(table, true, false);					-- Grosse blinde
      poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(2));
      joueurSuivant(table, true, false);
   end;
   
   procedure Fin_manche (table : in out T_Table) is
   begin
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
   begin
      if not lastOneStanding(table,alive,inGame) then
         ok := false;
         while not ok loop
            if table.index_joueur_actif < table.nb_joueurs then
               table.index_joueur_actif := table.index_joueur_actif +1;
            else
               table.index_joueur_actif := 1;
            end if;
            ok := ((not alive) or getArgent(table.joueurs(table.index_joueur_actif)) > 0) and (alive or isPlaying(table.joueurs(table.index_joueur_actif)));
         end loop;
      else
         null;-- TODO
      end if;
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
         if ((not alive) or getArgent(table.joueurs(table.index_joueur_actif)) > 0) and (alive or isPlaying(table.joueurs(table.index_joueur_actif))) then
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
            
            for i in 1..n loop						-- Et leur mises respectives
               mises(i) := getMise(table.joueurs(listJ(i)));
            end loop;
            
            if n =1 then							-- Si il n'y a que un joueur different
               for i in 1..table.nb_joueurs loop
                  if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) >= mises(1) then
                     addArgent(Last_Element(table.pots), mises(1));
                  end if;
               end loop;
               
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
                  
                  for i in 1..n loop
                     addArgent(Last_Element(table.pots), getMise(table.joueurs(i))-mises(1));
                  end loop;
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
                  end;
               else								-- S'il n'y a qu'une mise
                  for i in 1..table.nb_joueurs loop
                     if isPlaying(table.joueurs(i)) and getMise(table.joueurs(i)) >= mises(1) then
                        addArgent(Last_Element(table.pots), mises(1));
                     end if;
                  end loop;
               
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
                  
                     for i in 1..n loop
                        addArgent(Last_Element(table.pots), getMise(table.joueurs(i))-mises(1));
                     end loop;
                  end;
               end if;
            end if;
         end;
      else									-- Si tous les joueurs on paye la meme chose
         for i in 1..table.nb_joueurs loop
            addArgent(Last_Element(table.pots), getMise(table.joueurs(i)));
            if isPlaying(table.joueurs(i)) and getArgent(table.joueurs(i)) > 0 then
               n := n+1;
            end if;
         end loop;								-- On ajoute l'argent dans le pot et on cree un nouveau pot pour la suite
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
   
   procedure addArgentToLastPot(table : in out T_Table; montant : in Positive) is
      nPot : T_Pot := clonerPot(Last_Element(table.pots));
   begin
      addArgent(nPot, montant);
      Replace_Element(table.pots, Last_Index(table.pots), nPot);
   end;
   
end P_table;
