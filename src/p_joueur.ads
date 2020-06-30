with P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;

package P_Joueur is
   
   
   Has_To_All_In_Exception : Exception;						-- Exception lancee quand le joueur doit faire tapis pour miser
   
   type T_Joueur is private;
   Type tabJoueur is array(Positive range <>) of T_Joueur;
   
   -- Procedure permettant de creer un joueur en lui affectant un nom
   -- - Entree : le nom du joueur
   -- - Sortie : le joueur
   function creerJoueur(nom : in String; argent : in Natural) return T_Joueur;
   
   -- action : stock les cartes données par la table
   -- E/ : cartes - T_tab_cartes (un tableau de 2 cartes)  
   -- E/S/ : joueur - T_Joueur
   -- entraine : joueur.main = cartes
   procedure prendreCartes(cartes : in T_Deck; joueur : in out T_Joueur);
   
   -- action : récupère l'argent
   -- E/ : mise - un entier 
   -- E/S/ : joueur - T_Joueur
   -- entraine : joueur.argent = joueur.argent + mise
   procedure gagnerMise(mise : in integer; joueur : in out T_Joueur);
   
   -- Procedure qui fait miser sa blinde a un joueur
   -- - Entree : le joueur et la mise a poser
   -- - Autre : ne fait rien si la mise du joueur n'est pas nulle
   procedure poserBlinde(joueur :  in out T_Joueur; blinde : in natural);
      
   -- action : remet tous les compteurs de parties à 0 pour pouvoir commencer à jouer une nouvelle main
   -- E/S/ : joueur - T_Joueur
   -- entraine : La remise à zero de la mise et le sortie du jeu si l'argent est nul
   procedure finManche(joueur : in out T_Joueur); 
   
   -- Fonction permettant de faire jouer l'action choisie par le joueur
   -- - Entree : le joueur, l'action a effectuer
   -- - Sortie : un booleen attestant du succes
   function jouerTour(miseActuelle : in Natural; joueur : in out T_Joueur; action : in T_Action) return boolean;
   
   -- action : montre les cartes de la main d'un joueur
   -- E/ : joueur - T_Joueur 
   -- entraine : put(joueur.main)
   function montrerMain(joueur : in T_Joueur) return String;
   
   -- Fonction qui permet de connaitre l'argent que possede un joueur
   -- - Entree : un joueur
   -- - Sortie : l'argent de ce joueur
   function getArgent(joueur : in T_Joueur) return Integer;
   
   -- Fonction permettant de savoir combien un joueur a mise en tout dans le tour
   -- - Entree : un joueur
   -- - Sortie : la mise pariee par ce joueur
   function getMise(joueur: in T_Joueur) return Natural;
   
   -- Fonction qui permet de recuperer le nom d'un joueur
   -- - Entree : un joueur
   -- - Sortie : son nom
   function getName(joueur : in T_Joueur) return String;
   
   -- Fonction qui permet de savoir si le joueur est en jeu
   -- - Entree : le joueur
   -- - Sortie : si le joueur est en jeu
   function isPlaying(joueur : in T_Joueur) return boolean;
   
   -- action : convertit les informations concernant le joueur en string
   -- E/ : joueur - T_Joueur
   -- entraine : put(joueur)
   function toString(joueur : in T_Joueur) return string;
   
   
private
 
   Type T_Joueur is record
      nom : Unbounded_String;
      argent : integer;
      mise : integer;
      main : T_Deck(1..2);
      en_jeu : Boolean;
   end record;
   
   
   -- Prodecure qui transfert de l'argent dans la mise
   -- - Entree : un joueur, un montant
   -- - Autre : Si le joueur n'a pas les fonds necessaires, envoie une exception (demande de tapis)
   procedure miser(joueur : in out T_Joueur; montant : in Natural);
   

end P_Joueur;
