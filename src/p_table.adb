WITH P_joueur, P_Action, P_Carte, P_Utils, P_Pot, Ada.Strings.Unbounded, gui;
USE P_joueur, P_Action, P_Carte, P_Utils, P_Pot, Ada.Strings.Unbounded;

Package body P_table is
   
   
   
   procedure Lancer_Partie is
      nAlive : Natural;
      playing, done : boolean := true;
      nb_joueurs : Natural := gui.getNJoueurs;
   begin
      declare
         table : T_Table(nb_joueurs);
      begin
         table := gui.makeTable(nb_joueurs);
         
         nAlive := table.nb_joueurs;
         while nAlive > 1 loop							-- Tant qu'il y a plus d'un joueur
            Debut_manche(table, nAlive);
            
            while playing loop
               for i in 1..table.nb_joueurs loop
                  if isPlaying(table.joueurs(i)) then
                     done := false;
                     while not done loop
                        declare
                           act : T_Action := gui.playTurn(table, table.joueurs(i), i);
                        begin
                           if getElem(act) = Miser and table.nb_relances < 3 then
                              if getMise(act) > table.mise_max*2 then
                                 
                              else
                                 gui.mustMiseMore;
                              end if;
                           else
                              gui.cannotMise;
                           end if;
                        end;
                     end loop;
                  end if;
               end loop;
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
      
      for n in 1..table.nb_joueurs loop					-- On prepare la liste de joueurs
         if getArgent(table.joueurs(n)) > 0 then
            nPot(i) := n;
            i := i+1;
         end if;
      end loop;
      
      append(table.pots, creerPot(nPot));					-- On cree le premier pot
      
      table.index_joueur_actif := table.index_dealer;
      joueurSuivant(table);							-- Petite blinde
      poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(1));
      joueurSuivant(table);							-- Grosse blinde
      poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(2));
      joueurSuivant(table);
   end;
   
   procedure Fin_manche (table : in out T_Table) is
   begin
      null;
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
      
   procedure joueurSuivant(table : in out T_Table) is
   begin
      if table.index_joueur_actif < table.nb_joueurs then
         table.index_joueur_actif := table.index_joueur_actif +1;
      else
         table.index_joueur_actif := 1;
      end if;
   end;
   
   function findPots(table : in T_Table; joueur : in Positive) return posArray is
      retSize : Natural :=0;
   begin
      for i in 1..Length(table.pots) loop
         if isJoueurIn(Element(table.pots, i), joueur) then
            retSize := retSize +1;
         end if;
      end loop;
      if retSize > 0 then
         declare
            ret : posArray(1..retSize);
            k : Positive :=1;
         begin
            for i in 1..Length(table.pots) loop
               if isJoueurIn(Element(table.pots, i), joueur) then
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
   
   function lastOneStanding(table : in T_Table) return boolean is
      one : boolean := false;
   begin
      for i in 1..table.nb_joueurs loop
         if isPlaying(table.joueurs(i)) then
            if one then
               return false;
            else
               one := true;
            end if;
         end if;
      end loop;

      return one;
   end;
   
   
   
end P_table;
