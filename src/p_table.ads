with P_Joueur, P_Aleatoire, P_Carte, P_Utils, P_Pot,Ada.Containers.Indefinite_Vectors;
use P_Joueur, P_Carte, P_Utils, P_Pot;

package P_table is
      
   
   Type T_Table(nb_joueurs : Positive) is private;				-- Le type decrivant une table de poker complete
   
   
   -- Fonction permettant de generer une table a partir de joueurs
   -- - Entrees :	joueurs : les joueurs d'index [1,n] seront ajoutes a la table
   --		n : le nombre de joueurs
   -- - Sortie : une table contenant les joueurs
   function creeTable(joueurs : tabJoueur; n : Positive) return T_Table;
   
   -- Procedure permettant de lancer la partie
   -- - Entree : la table concernee, contenant les joueurs
   -- - Autre : Lance la boucle principale de jeu, qui ne se quitte que quand il ne reste plus qu'un seul joueur avec de l'argent
   procedure Lancer_Partie(table : T_Table);
   
   -- Fonction permettant de recuperer une representation textuelle de la table
   function toString(table : T_Table) return String;
   
   
   
private
   
   -- Utilisation de vecteurs indefinis pour pouvoir avoir une 'table' de pots
   package P_Vectors is new Ada.Containers.Indefinite_Vectors(Positive, T_Pot);
   use P_Vectors;
   
   -- Vecteur de pots
   Type vecPot is new Vector with null record;
   
   -- Type qui combine un deck et l'index de la carte pour piocher la suivante
   Type T_FullDeck is record
      deck : T_Deck(1..P_Carte.nombreMaxCartes);
      carteSuivante : Integer range 1..P_Carte.nombreMaxCartes;
   end record;
   
   Type T_Table(nb_joueurs : Positive) is record
      blindes : natArray(1..2);
      nb_relances : Integer range 0..3;
      index_dealer : Integer range 1..nb_joueurs;
      index_joueur_actif : Integer range 1..nb_joueurs;
      mise_max : Natural;
      joueurs_mise_max : Integerrange -1..nb_joueurs;
      joueurs: tabJoueur(1..nb_joueurs);	
      cartes_ouvertes: T_Deck(1..5);
      nb_cartes_ouvertes: Integer range 0..5;
      pots : vecPot;
      deck : T_FullDeck;
   end record;
   
   -- Procedure permettant de distribuer les cartes aux joueurs
   -- - Entree : la table concernee
   procedure Distribuer_main(table : T_Table);
   
   -- Procedure permettant de poser les cartes ouvertes
   -- - Entree : la table concernee
   procedure Poser_cartes_ouvertes(table : T_Table);
   
   -- Procedure permettant de mettre fin a une manche (on redistribue les cartes apres)
   -- - Entree : la table concernee
   procedure Fin_manche(table : T_Table);
   
   -- Procedure permettant de melanger le deck
   -- - Entree : la table concernee
   procedure Melange_deck(table : T_Table);
   
   -- Procedure permettant de monter les blindes
   -- - Entrees :	table : la table concernee
   --		nMin : la nouvelle petite blinde
   --		nMax : la nouvelle grosse blinde
   procedure Monter_blindes(table : T_Table; nMin : Natural; nMax : Natural);
   
   -- Fonction permettant de piocher une carte du deck
   -- - Entree : la table concernee
   -- - Sortie : la prochaine carte du deck de la table
   function piocherCarte(table : T_Table) return T_Carte;
   
   
end P_table;      
