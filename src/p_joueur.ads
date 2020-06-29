with P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;

package P_Joueur is
   
   
   Has_To_All_In_Exception : Exception;						-- Exception lancee quand le joueur doit faire tapis pour miser
   
   type T_Joueur is private;
   Type tabJoueur is array(Positive range <>) of T_Joueur;
   
   
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
   procedure poserBlinde(joueur : T_Joueur; blinde : natural);
   
   -- action : remet tous les compteurs de parties à 0 pour pouvoir commencer à jouer une nouvelle main
   -- E/S/ : joueur - T_Joueur
   -- entraine : 
   procedure finManche(joueur : in out T_Joueur); 
   
   -- action : joue un tour et renvoie l'action choisie
   -- E/ : miseMax - un entier
   -- E/ : CanRelance - un Booléen
   -- E/S/ : joueur - T_Joueur
   -- entraine : en_jeu = True......
   procedure jouerTour(miseMax: in Integer; CanRelance: in Boolean; joueur : in out T_Joueur; action : in out T_action); 
   
   -- action : montre les cartes de la main d'un joueur
   -- E/ : joueur - T_Joueur 
   -- entraine : put(joueur.main)
   function montrerMain(joueur : in T_Joueur) return String;
   
   -- Fonction qui permet de connaitre l'argent que possede un joueur
   -- - Entree : un joueur
   -- - Sortie : l'argent de ce joueur
   function getArgent(joueur : in T_Joueur) return Integer;
   
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
   procedure miser(joueur : T_Joueur; montant : Natural);
   

end P_Joueur;
