with P_table, Ada.Text_IO, Ada.Integer_Text_IO, P_Joueur,P_Action, P_Aleatoire, P_Carte, P_Pot, P_Utils;
use P_table, Ada.Text_IO, Ada.Integer_Text_IO, P_Joueur,P_Action, P_Carte, P_Pot, P_Utils;


procedure test_p_table is
   package P_Carte_Alea is new P_Aleatoire(T_Element => T_Carte,
                                           T_Liste => T_Deck);
   use P_Carte_Alea;
   deck : T_Deck := deckComplet;
   joueur1 : T_Joueur;
   joueur2 : T_Joueur;
   tab : tabJoueur(1..2);
   table : T_Table(2);
   
begin
   
   Put_Line("-----");
   Put_Line("Test du package P_table");
   Put_Line("-----");
   New_Line;
   resetGenerator; -- permet d'obtenir des cartes différentes lors des tirages
   deck := shuffle(deck'First,deck'Last,deck); -- melange du deck
   joueur1:= creerJoueur("PSG",100);                                            -- on commence par creer deux joueurs puis leur tableau
   joueur2:= creerJoueur("OM",200);
   tab:=(joueur1,joueur2);
   Put_Line("Creation de la table");
   Put_Line("-----");
   New_Line;
   table := creeTable(tab,2); 
   Put_Line("Affichage de la table"); 
   New_Line;
   Put_Line(toString(table)); -- affichage de la table
   Put_Line("-----");
   New_Line;
   Put_Line("On monte les blindes");
   Monter_blindes(table,5,10);
   Put_Line("-----");
   New_Line;
   Put_Line("Lancement d'une partie");
   Put_Line("-----");
   New_Line;
   Lancer_Partie;
end test_p_table;
