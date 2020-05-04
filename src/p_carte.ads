with P_Utils;
use P_Utils;

package P_Carte is
   
   Type T_Carte is private;							-- Le type decrivant une carte
   Type T_Deck is Array (Positive range <>) of T_Carte;				-- Une table de carte pour pouvoir uniformiser les type dans les methodes
   Type T_Combinaison is limited private;					-- Le type decrivant la valeur d'une combinaison de cartes
   
   -- Fonction permettant de comparer deux cartes
   -- - Entree : deux cartes
   -- - Sortie : une comparaison detaillee des cartes (cf T_CompaComplete)
   -- - Autre : Neglige la couleur
   --		Utilise la fonction privee compaVal
   function comparer(carte1:T_Carte; carte2:T_Carte) return T_CompaComplete;
   
   -- Fonction permettant de dedoubler un deck
   -- - Entree : un deck
   -- - Sortie : une copie conforme et independante de ce deck
   function clonerDeck(deck :T_Deck) return T_Deck;
   
   -- Fonction permettant de recuperer un deck contenant toutes les cartes disponibles
   -- - Sortie : un deck avec un exemplaire de chaque carte, toujours dans le meme ordre
   function deckComplet return T_Deck;
   
   
   -- Fonction permettant de detecter la meilleur combinaison de cartes dans un deck
   -- - Entree : un deck de cartes
   -- - Sortie : la meilleur combinaison de 5 cartes presente dans ce deck
   -- - Autre : Pour les decks de moins de 5 cartes, trouve la meilleur combinaison presente dans le deck
   --		Marche aussi avec un deck vide (retourne la combinaison la plus faible)
   --		Pour les decks de plus de 5 cartes, utilise la recursivite et la fonction compaCombi
   function trouverCombinaison(deck : T_Deck) return T_Combinaison;
   
   -- Fonction permettant de comparer deux compinaisons
   -- - Entree : deux combinaisons
   -- - Sortie : une comparaison detaillee des combinaisons (cf T_CompaComplete)
   -- - Autre : utilise la fonction privee compaCombElem
   function compaCombi(combi1 : T_Combinaison; combi2 : T_Combinaison) return T_CompaComplete;
   
   
   -- Fonction permettant de recuperer une representation textuelle des differents objets du package
   -- - Autre : utilise les fonctions privees toString
   function toString(carte:T_Carte) return String;
   function toString(deck:T_Deck) return String;
   function toString(combi:T_Combinaison) return String;
   
   
private
   
   -- Declaration des valeurs possible des cartes (none : valeur nulle utilisee avec les combinaisons)
   Type T_Val is (none,val2,val3,val4,val5,val6,val7,val8,val9,val10,valV,valD,valR,valA);
   -- Declaration des couleurs
   Type T_Coul is (Trefle,Carreau,Coeur,Pique);
   
   -- Differents combinaisons de cartes possibles
   Type T_CombElem is (CarteForte, Paire, DoublePaire, Brelan, Quinte, Flush, Full, Carre, QuinteFlush);
   
   -- Type decrivant une carte (valeur + couleur)
   Type T_Carte is record
      valeur : T_Val;
      couleur : T_Coul;
   end record;
   
   -- Type decrivant une combinaison de cartes (type de combinaison + valeur de la combinaison + valeur du kicker (+ valeur de la seconde carte de la combinaison))
   -- - double : booleen renseignat si la combinaison a besoin de deux cartes pour etre decrite
   Type T_Combinaison(double : boolean := false) is record
      combi : T_CombElem;
      valeur : T_Val;
      kicker : T_Val;
      
      case double is
         when true =>
            valeurSec : T_Val;
         when false => null;
      end case;
   end record;
   
   -- Constante : Nombre de cartes differentes existantes
   Nombre_Max_Cartes : Integer := 13*4;
   
   -- Fonction permettant de creer une carte a partir des elements
   function makeCarte(coul : T_Coul; val : T_Val) return T_Carte;
   -- Fonction permettant de creer une combinaison a partir des elements
   function makeCombi(combi : T_CombElem; val : T_Val; kick : T_Val; valSeq : T_Val) return T_Combinaison;
   
   
   -- Fonction permettant de comparer deux types de combinaisons
   -- - Entree : deux types de combinaison
   -- - Sortie : une comparaison detaillee des combinaisons (cf T_CompaComplete)
   function compaCombElem(combi1 : T_CombElem; combi2 : T_CombElem) return T_CompaComplete;
   
   -- Fonction permettan de comparer deux valeurs
   -- - Entree : deux valeurs
   -- - Sortie : une comparaison detaillee des valeurs (cf T_CompaComplete)
   function compaVal(val1 : T_Val; val2 :T_Val) return T_CompaComplete;
   
   -- Fonction de comparaison de cartes avec retour booleen
   -- - Entree : deux cartes
   -- - Sortie : vrai si compaVal(c1.valeur, c2.valeur) = inf
   function compSort(c1 : T_Carte; c2 : T_Carte) return boolean;
   
   
   -- Fonction permettant de trier un deck
   -- - Entree : un deck de cartes
   -- - Sortie : une copie triee du deck
   -- - Autre : utilise la fonction compSort pour trier
   --		instanciation de trierListe du package P_Utils
   function sortDeck is new trierListe(T_Element => T_Carte,
                                       T_Liste => T_Deck,
                                       comp => compSort);
   
   
   -- Fonctions permettant de recuperer une representaion textuelle des differents types
   function toString(val : T_Val) return String;
   function toString(coul : T_Coul) return String;
   function toString(combi : T_CombElem) return String;
   
   
end P_Carte;
