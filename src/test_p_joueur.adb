with P_Carte, Ada.Text_IO, P_Aleatoire, P_Utils, P_joueur, Ada.Integer_Text_IO;
use P_Carte, Ada.Text_IO, P_Utils, P_carte, P_joueur, Ada.Integer_Text_IO;


procedure Test_P_joueur is
   package P_Carte_Alea is new P_Aleatoire(T_Element => T_Carte,
                                           T_Liste => T_Deck);
   use P_Carte_Alea;
   
   deck : T_Deck := deckComplet;
   joueur : T_Joueur;
   nom : string := "jammich";
begin
   resetGenerator; -- permet d'obtenir des cartes différentes lors des tirages
   deck := shuffle(deck'First,deck'Last,deck);
   joueur := creerJoueur(nom, 5000);
   prendreCartes(deck, joueur);
   gagnerMise(50, joueur);
   Put_Line("premier test");
   put(toString(joueur));
   put("----------");
   put(getArgent(joueur));
   put("----------");
   put(getMise(joueur));
   put("----------");
   put(getName(joueur));
   put("----------");
   put(toString(getCartes(joueur)));
   put("----------");
   put(boolean'image(isPlaying(joueur)));
   put("----------");
   New_Line;
   Put_Line("deuxième test");
   jouerTour(0, joueur , action : miser);
   put(toString(joueur));
   put("----------");
   put(getArgent(joueur));
   put("----------");
   put(getMise(joueur));
   put("----------");
   put(getName(joueur));
   put("----------");
   put(toString(getCartes(joueur)));
   put("----------");
   put(boolean'image(isPlaying(joueur)));
   put("----------");
   
   
end Test_P_joueur;
