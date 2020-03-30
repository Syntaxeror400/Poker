with P_Utils;
use P_Utils;

package P_Carte is
   
   Type T_Carte is limited private;
   Type T_Deck is Array (Positive range <>) of T_Carte;
   Type T_Combinaison is limited private;
   
   function comparer(carte1:T_Carte; carte2:T_Carte) return T_CompaComplete;
   function clonerDeck(deck:T_Deck) return T_Deck;
   function deckComplet return T_Deck;
   
   function trouverCombinaison(cartes : T_Deck) return T_Combinaison;
   function compaCombi(combi1 : T_Combinaison; combi2 : T_Combinaison) return T_CompaComplete;
   
   function toString(carte:T_Carte) return String;
   function toString(deck:T_Deck) return String;
   
   
private
   
   Type T_Val is (val2,val3,val4,val5,val6,val7,val8,val9,val10,valV,valD,valR,valA);
   Type T_Coul is (Trefle,Carreau,Coeur,Pique);
   
   Type T_CombElem is (CarteForte, Paire, DoublePaire, Brelan, Quint, Flush, Full, Carre, QuinteFlush);
   
   Type T_Carte is record
      valeur : T_Val;
      couleur : T_Coul;
   end record;
   
   Type T_Combinaison is record
      combi : T_CombElem;
      valeur : T_Val;
      FullValPaire : T_Val;
      kicker : T_Carte;
   end record;
   
   Nombre_Max_Cartes : Integer := 13*4;
   
   function makeCarte(coul : T_Coul; val : T_Val) return T_Carte;
   
end P_Carte;
