with P_Carte, Ada.Text_IO, P_Aleatoire;
use P_Carte, Ada.Text_IO;

procedure Test_P_Carte is
   package P_Carte_Alea is new P_Aleatoire(T_Element => T_Carte,
                                           T_Liste => T_Deck);
   use P_Carte_Alea;
   
   deck : T_Deck := deckComplet;
begin
   Put_Line("-----");
   Put_Line("Test du package P_Carte et P_Aleatoire");
   resetGenerator;
   Put_Line("-----");
   New_Line;
   Put_Line("-----");
   Put_Line("Affichage d'un deck complet : "& P_Carte.toString(deck));
   Put_Line("-----");
   New_Line;
   Put_Line("-----");
   declare
      shuffled : T_Deck := shuffle(deck'First,deck'Last,deck);
      begin
      Put_Line("Affichage du meme deck melange : "& P_Carte.toString(shuffled));
      Put_Line("-----");
      New_Line;
      Put_Line("-----");
      declare
         cartes : T_Deck := shuffled(1..7);
         begin
         Put_Line("Affichage des 7 premières cartes du deck melange : "& P_Carte.toString(cartes));
         Put_Line("-----");
         New_Line;
         Put_Line("-----");
         Put_Line("Affichage de la meilleur combinaison trouvee dans les 7 cartes : "& P_Carte.toString(P_Carte.trouverCombinaison(cartes)));
         Put_Line("-----");
      end;
   end;
end Test_P_Carte;
