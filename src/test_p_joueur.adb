with P_Carte, Ada.Text_IO, P_Aleatoire, P_Utils, P_joueur, Ada.Integer_Text_IO, P_Action;
use P_Carte, Ada.Text_IO, P_Utils, P_carte, P_joueur, Ada.Integer_Text_IO, P_Action;


procedure Test_P_joueur is
   package P_Carte_Alea is new P_Aleatoire(T_Element => T_Carte,
                                           T_Liste => T_Deck);
   use P_Carte_Alea;
   
   deck : T_Deck := deckComplet;
   joueur1 : T_Joueur;
   joueur2 : T_Joueur;
   nom : string := "jammich";
   nomm : string := "jeanne";
   action : T_action(miser);
begin
   
   Put_Line("-----");
   Put_Line("Test du package P_joueur");
   Put_Line("-----");
   New_Line;
   resetGenerator; -- permet d'obtenir des cartes différentes lors des tirages
   deck := shuffle(deck'First,deck'Last,deck);
   joueur1 := creerJoueur(nom, 5000);
   prendreCartes(deck, joueur1);
   gagnerMise(50, joueur1);
   Put_Line("affichage des données du joueur contenue dans le type T_joueur");
   put(toString(joueur1));
   put("----------");
   New_Line;
   Put_Line("affichage des données du joueur une par une");
   put(getArgent(joueur1));
   put("----------");
   put(getMise(joueur1));
   put("----------");
   put(getName(joueur1));
   put("----------");
   put(toString(getCartes(joueur1)));
   put("----------");
   put(boolean'image(isPlaying(joueur1)));
   put("----------");
   New_Line;
   
   Put_Line("On défini un deuxième joueur");
   deck := shuffle(deck'First,deck'Last,deck);
   joueur2 := creerJoueur(nomm, 5000);
   prendreCartes(deck, joueur2);
   Put_Line("affichage des données du joueur");
   put(toString(joueur2));
   put("----------");
   New_Line;
   
   Put_Line("*********");
   action := creerMise(100);
   if jouerTour(0, joueur2 , action)= True then
      put(toString(joueur2));
      put("----------");
   else
      put("tour non joue");
   end if;
   New_line;
   
   poserBlinde(joueur2, 50);
   if jouerTour(50, joueur1 , action)= True then
      put(toString(joueur1));
      put("----------");
   else 
      put("tour non joue"); 
   end if;
   New_line;
   --put(toString(joueur2));
   put("----------");
end Test_P_joueur;
