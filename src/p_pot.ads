with P_Utils;
use P_Utils;

package P_Pot is
   
   Type T_Pot(nJoueurs : Integer) is private;					-- Type decrivant un pot
   
   
   -- Fonction permettant de creer un pot
   -- - Entrees : joueurs : les joueurs ayant acces a ce pot
   -- - Effets : Remet a zero l'argent du pot et affecte la nouvelle table de joueurs
   function creerPot(joueurs : in posArray) return T_Pot;
   
   -- Procedure permettant d'ajouter de l'argent a un pot
   -- - Entrees :	pot : le pot concerne
   --		montant : la somme a ajouter au pot
   -- - Effet : ajout la 'montant' a l'argent du pot
   procedure addArgent(pot : in out T_Pot; montant : in Positive);
   
   -- Fonction permettant de recuperer l'argent contenu dans le pot
   -- Entree : le pot concerne
   -- Sortie : l'argent contenu dans le pot
   function getPotArgent(pot : T_Pot) return Natural;
   
   -- Fonction permettant de recuperer les joueurs ayant acces au pot
   -- Entree : le pot concerne
   -- Sortie : la table contenant les indexs des joueurs ayant acces au pot
   function getJoueurs(pot : T_Pot) return posArray;
   
   
   -- Fonction permettant d'obtenir une representation textuelle du pot
   function toString(pot : T_Pot) return String;
   
private
   
   -- Type decrivant un pot (argent + table de joueurs (representes par leurs indexs))
   Type T_Pot(nJoueurs : Integer) is record
      argent : Natural;
      joueurs : posArray(1..nJoueurs);
   end record;

end P_Pot;
