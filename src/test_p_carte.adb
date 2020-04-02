with P_Carte, Ada.Text_IO, P_Aleatoire, P_Utils;
use P_Carte, Ada.Text_IO, P_Utils;

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
   Put_Line("Affichage d'un deck complet : "& toString(deck));
   Put_Line("-----");
   New_Line;
   Put_Line("-----");
   declare
      shuffled : T_Deck := shuffle(deck'First,deck'Last,deck);
      begin
      Put_Line("Affichage du meme deck melange : "& toString(shuffled));
      Put_Line("-----");
      New_Line;
      Put_Line("-----");
      declare
         cartes : T_Deck := shuffled(1..7);
         begin
         Put_Line("Affichage des 7 premières cartes du deck melange : "& toString(cartes));
         Put_Line("-----");
         New_Line;
         Put_Line("-----");
         Put_Line("Comparaison 2 a 2 de cartes :");
         New_Line;
         for i in 1..4 loop
            for j in i+1..5 loop
               Put_Line(toString(cartes(i))&" "& T_CompaComplete'Image(comparer(cartes(i),cartes(j)))&" " &toString(cartes(j)));
            end loop;
         end loop;
         Put_Line("-----");
         New_Line;
         Put_Line("-----");
         Put_Line("Affichage de la meilleur combinaison trouvee dans les 7 cartes : "& toString(trouverCombinaison(cartes)));
         Put_Line("-----");
         New_Line;
         Put_Line("-----");
         Put_Line("Debut du test de 100 meanges/tirages/combinaisons");
         Put_Line("-----");
         New_Line;
         Put_Line("-----");
         for i in 1..100 loop
            shuffled := shuffle(deck'First, deck'Last, deck);
            cartes := shuffled(1..7);
            Put_Line("Cartes : "& toString(cartes));
            Put_Line("Combinaison : "& toString(trouverCombinaison(cartes)));
            Put_Line("-----");
         end loop;
      end;
   end;
end Test_P_Carte;
