WITH P_joueur, P_Action, P_Aleatoire, P_Carte, P_Utils, P_Pot;
USE P_joueur, P_Action, P_Aleatoire, P_Carte, P_Utils, P_Pot;

Package body P_table is
   
   function creeTable(joueurs : tabJoueur; n : Positive) return T_Table is
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
   
   procedure Lancer_Partie (table: T_Table) is
      nAlive : Natural;
      playing : boolean := true;
   begin
      nAlive := table.nb_joueurs;
      while nAlive > 1 loop							-- Tant qu'il y a plus d'un joueur
         Debut_manche(table);
         
         while playing loop
            for j in table.joueurs loop
               -- TODO
            end loop;
         end loop;
         
         Fin_manche(table);
         
         nAlive := 0;
         for j in table.joueurs loop
            if getArgent(j) > 0 then
               nAlive := nAlive +1;
            end if;
         end loop;
      end loop;
   end;
   
   function toString (table_joueur : T_Table) return String is
   begin
      return "";
   end;
   
   procedure Distribuer_main (table : T_Table) is
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
   
   procedure Poser_cartes_ouvertes (table : T_Table) is
   begin
      case table.nb_cartes_ouvertes is						-- On implémente les "burn" de cartes pour simuler une vraie partie
         when 0 =>
            piocherCarte(table);
            for i in 1..3 loop
               table.cartes_ouvertes(i) := piocherCarte(table);
            end loop;
            table.nb_cartes_ouvertes := 3;
         when 3 =>
            piocherCarte(table);
            table.cartes_ouvertes(4) := piocherCarte(table);
            table.cartes_ouvertes := 4;
         when 4 => ;
            piocherCarte(table);
            table.cartes_ouvertes(5) := piocherCarte(table);
            table.cartes_ouvertes := 5;
         when others =>								-- On ne doit pas rajouter de cartes si la table est pleine !
            raise Invalid_State_Exception with "La table est deja pleine !";
      end case;
   end;
      
   procedure Debut_manche (table : T_Table) is
      njPot : Positive := 0;
   begin
      Melange_deck(table);
      Distribuer_main(table);
      
      table.nb_relances := 0;
      table.mise_max := 0;
      table.joueurs_mise_max := 0;
      table.nb_cartes_ouvertes := 0;
      clear(table.pots);
      
      for j in table.joueurs loop						-- On detecte le nombre de joueurs pour la manche
         if getArgent(j) > 0 then
            njPot := njPot +1;
         end if;
      end loop;
      
      declare
         nPot : posArray(1..njPot);
         i : Positive := 1;
      begin
         for n in 1..table.nb_joueurs loop					-- On prepare la liste de joueurs
            if getArgent(table.joueurs(n)) > 0 then
               nPot(i) := n;
               i := i+1;
            end if;
         end loop;
         
         append(table.pots, creerPot(nPot));					-- On cree le premier pot
      end;
      
      table.index_joueur_actif := table.index_dealer;
      joueurSuivant(table);							-- Petite blinde
      poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(1));
      joueurSuivant(table);							-- Grosse blinde
      poserBlinde(table.joueurs(table.index_joueur_actif), table.blindes(2));
      joueurSuivant(table);
   end;
   
   procedure Fin_manche (table : T_Table) is
   begin
      null;
   end;
   
   procedure Melange_deck (table : T_Table) is
   begin									-- On remelange le meme deck de cartes
      table.deck.deck := shuffle(1, nombreMaxCartes, table.deck.deck);
      table.deck.carteSuivante := 1;
   end;
   
   procedure Monter_blindes(table : T_Table; nMin : Natural; nMax : Natural) is
   begin
      table.blindes(2):=nMax;
      table.blindes(1):=nMin;
   end;
   
   function piocherCarte(table : T_Table) return T_Carte is
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
   
   
   procedure joueurSuivant(table : T_Table) is
   begin
      if table.index_joueur_actif < table.nb_joueurs then
         table.index_joueur_actif := table.index_joueur_actif +1;
      else
         table.index_joueur_actif := 1;
      end if;
   end;
   
   
   
end P_table;
