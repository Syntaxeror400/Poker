WITH P_joueur, P_action, P_Aleatoire, P_Carte, P_Utils, P_Pot, ada.text_io, ada.Integer_Text_IO;
USE P_joueur, P_action, P_Aleatoire, P_Carte, P_Utils, P_Pot, ada.text_io, ada.Integer_Text_IO;

Package body P_table is
   
   function creeTable(joueurs : tabJoueur; n : Positive) return T_Table is
   begin
      null;
   end;
   
   procedure Lancer_Partie (table_joueur : T_Table) is
   begin
      null;
   end;
   
   procedure toString (table_joueur : T_Table) is
   begin
      null;
   end;
   
   procedure Distribuer_main (table_joueur : T_Table) is
   begin
      for I in 1..nb_joueurs loop
         -- est ce qu on devrait faire une distribtion comme au poker (carte donné "par" le dealer dans le sens des aiguilles d 'une montre?
         table_joueur.joueurs(I).main(1) := table_joueur.deck.carteSuivante;
         table_joueur.deck.carteSuivante := table_joueur.deck.carteSuivante+1;
         table_joueur.joueurs(I).main(2) := table_joueur.deck.carteSuivante;
         table_joueur.deck.carteSuivante := table_joueur.deck.carteSuivante+1;
      end loop;            
   end;   
   procedure Poser_cartes_ouvertes (table_joueur : T_Table) is
   begin
      for I in 1..5 loop
         table_joueur.cartes_ouvertes(I) := table_joueur.deck.carteSuivante;
         table_joueur.deck.carteSuivante := table_joueur.deck.carteSuivante+1;
         table_joueur.nb_cartes_ouvertes := table_joueur.nb_cartes_ouvertes+1;
      end loop;   
   end;
   
   
   procedure Fin_manche (table_joueur : T_Table) is
   begin
      null;
   end;
   
   procedure Melange_deck (table_joueur : T_Table) is
   begin
      null;
   end;
   
   procedure Monter_blindes(table : T_Table; nMin : Natural; nMax : Natural) is
   begin
      table.blindes(1):=nMax;
      table.blindes(2):=nMin;
   end;
   
   function piocherCarte(table : T_Table) return T_Carte is
   begin
      null;
   end;
   
end P_table;
