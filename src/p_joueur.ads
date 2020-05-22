with P_Carte, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Utils, Ada.Strings.Unbounded;

package P_Joueur is
   
   
   type T_Joueur is private;
      
   -- Table de joueurs
   Type tabJoueur is array(Positive range <>) of T_Joueur;
   Type T_Action is (Coucher, Checker, Miser, Suivre, Surmiser);		-- Types decrivant les actions qu'un joueur peut effectuer a chaque tour
   
   
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
   
   

end P_Joueur;
