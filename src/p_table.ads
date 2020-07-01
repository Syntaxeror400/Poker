with P_Joueur, P_Action, P_Aleatoire, P_Carte, P_Utils, P_Pot, Ada.Containers.Indefinite_Vectors;
use P_Joueur, P_Action, P_Carte, P_Utils, P_Pot;

package P_table is
      
   
   No_More_Cards_Exception : Exception;						-- Exception levee quand on veut piocher alors qu'il n'y en a plus
   Invalid_State_Exception : Exception;						-- Exception levee si la table est dans un etat impossible
   
   Type T_Table(nb_joueurs : Positive) is private;				-- Le type decrivant une table de poker complete
   
   
   -- Procedure permettant de lancer la partie
   -- - Entree : la table concernee, contenant les joueurs
   -- - Autre : Lance la boucle principale de jeu, qui ne se quitte que quand il ne reste plus qu'un seul joueur avec de l'argent
   procedure Lancer_Partie;
   
   -- Fonction permettant de generer une table a partir de joueurs
   -- - Entrees :	joueurs : les joueurs d'index [1,n] seront ajoutes a la table
   --		n : le nombre de joueurs
   -- - Sortie : une table contenant les joueurs
   function creeTable(joueurs : in out tabJoueur; n : in Positive) return T_Table;
   
   -- Procedure permettant de monter les blindes
   -- - Entrees :	table : la table concernee
   --		nMin : la nouvelle petite blinde
   --		nMax : la nouvelle grosse blinde
   procedure Monter_blindes(table : in out T_Table; nMin : in Natural; nMax : in Natural);
   
   -- Fonction qui permet de recuperer la mise maximale actuelle
   -- - Entree : la table en question
   -- - Sortie : la mise maximale
   function getMiseMax(table : in T_Table) return Natural;
   
   -- Fonction permettant de recuperer une representation textuelle de la table
   -- - Autre : Donne l'etat actuel du jeu et est utilisee dans l'affichage graphique
   function toString(table : in T_Table) return String;
   
   function getPots(table : in T_Table; joueur :in Positive) return String;
   
   
private
   
   -- Utilisation de vecteurs indefinis pour pouvoir avoir une 'table' de pots
   package P_Vectors is new Ada.Containers.Indefinite_Vectors(Positive, T_Pot);
   use P_Vectors;
   
   -- Implementation du melange aleatoir
   package P_Alea_Cartes is new P_Aleatoire(T_Element => T_Carte,T_Liste   => T_Deck);
   use P_Alea_Cartes;
   
   -- Type qui combine un deck et l'index de la carte pour piocher la suivante
   Type T_FullDeck is record
      deck : T_Deck(1..P_Carte.nombreMaxCartes);
      carteSuivante : Integer range 1..(P_Carte.nombreMaxCartes+1);
   end record;
   
   Type T_Table(nb_joueurs : Positive) is record
      blindes : natArray(1..2);
      nb_relances : Integer range 0..3;
      index_dealer : Integer;
      index_joueur_actif : Integer;
      mise_max : Natural;
      joueurs_mise_max : Integer;
      joueurs: tabJoueur(1..nb_joueurs);	
      cartes_ouvertes: T_Deck(1..5);
      nb_cartes_ouvertes: Integer range 0..5;
      pots : Vector;
      deck : T_FullDeck;
   end record;
   
   -- Procedure permettant de distribuer les cartes aux joueurs
   -- - Entree : la table concernee
   procedure Distribuer_main(table : in out T_Table);
   
   -- Procedure permettant de poser les cartes ouvertes
   -- - Entree : la table concernee
   procedure Poser_cartes_ouvertes(table : in out T_Table);
   
   -- Procedure permettant de commencer une manche
   -- - Entree : la table concernee
   procedure Debut_manche(table : in out T_Table; reste : in Natural);
   
   -- Procedure permettant de mettre fin a une manche (notifier les joueurs)
   -- - Entree : la table concernee
   procedure Fin_manche(table : in out T_Table; reste : out Natural);
   
   -- Procedure permettant de melanger le deck
   -- - Entree : la table concernee
   procedure Melange_deck(table : in out T_Table);
      
   -- Fonction permettant de piocher une carte du deck
   -- - Entree : la table concernee
   -- - Sortie : la prochaine carte du deck de la table
   function piocherCarte(table : in out T_Table) return T_Carte;
   
   -- Procedure changeant le joueur actif
   -- - Entree :	- table : la table en question
   --		- alive : si le joueur doit avoir de l'argent
   --		- inGame : si le joueur doit etre en jeu
   -- - Autre : augment index_joueur_actif de 1 et le fait boucler correctement
   procedure joueurSuivant(table : in out T_Table; alive :in boolean; inGame : in boolean);
   
   -- Fonction permettant de trouver les pots auquel un joueur peut pretendre
   -- - Entree : l'index du joueur et la table
   -- - Sortie : les indexs des pots ou il peut pretendre
   function findPots(table : in T_Table; joueur : in Positive) return posArray;
   
   -- Fonction permettant de savoir si seulement un joueur est encore en jeu
   -- - Entree :	- table : la table en question
   --		- alive : si le joueur doit avoir de l'argent
   --		- inGame : si le joueur doit etre en jeu
   -- - Sortie : si il ne reste que un joueur en jeu
   function lastOneStanding(table : in T_Table; alive :in boolean; inGame : in boolean) return boolean;
   
   -- Procedure permettant de reorganiser les pots apres des tapis
   -- - Entree : la table
   -- - Autre : cree differents pots suivant les joueurs qui ont fait tapis
   procedure updatePots(table : in out T_Table);
   
   -- Procedure permettant d'ajouter de l'argent a un des pots de la table
   -- - Entree : la table et le montant a ajouter
   -- - Autre : clone le pot et ajoute l'argent avant de le remettre dans un vecteur
   procedure addArgentToLastPot(table : in out T_Table; montant : in Positive);
   
   -- Fonction de comparaison utilisee pour le double tri
   function natCompa(n1 : Natural; n2 :Natural) return boolean;
   
   -- Creation du tri double pour la creation de pots
   procedure doubleSort is new triDouble(T_Element1 => Natural,
                                         T_Element2 => Natural,
                                         T_Liste1   => natArray,
                                         T_Liste2   => natArray,
                                         comp => natCompa);
   
   
   
   
end P_table;
