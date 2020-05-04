with Ada.Numerics.Float_Random, Ada.Containers.Vectors;
use Ada.Numerics.Float_Random;

generic
   Type T_Element is private;
   Type T_Liste is array (Positive range <>) of T_Element;
   
package P_Aleatoire is
   
   -- Instanciation du type de vecteur utilise pour le melange de table
   package P_Vectors is new Ada.Containers.Vectors(Positive, T_Element);
   use P_Vectors;
   
   
   -- Procedure permettant d'initialiser le generateur aleatoire
   -- - Autre : 	pour que les resultats varies d'une execution a l'autre, il faut appeler cette fonction au moins une fois
   --		aucun besoin de faire plus d'un appel a cette fonction par execution
   procedure resetGenerator;
   
   
   -- Fonction permettant de tirer un element aleatoire d'une table
   -- - Entrees :	min/max : les bornes inclusives du domaine dans lequel on veut tirer un element
   --		table : la table d'element dans laquelle on tire l'element
   -- - Sortie : un element tire aleatoirement dans la table, dans la plage d'elements [min,max]
   -- - Autre : utilise la fonction privee randomPos
   function getRandomElement(min : Positive; max : Positive; table : T_Liste) return T_Element;
   
   -- Fonction permettant de melanger une table d'elements
   -- - Entrees :	min/max : les bornes inclusives du domaine a melanger
   --		table : la table d'elements a melanger
   -- - Sortie : une table d'elements indexee en [1, max-min+1] contenant les elements indexes
   --		entre [min,max] de la table d'origine dans un ordre aleatoire
   -- - Autre : utilise la fonction privee randomPos
   function shuffle(min : Positive; max : Positive; table : T_Liste) return T_Liste;
   
private
   
   -- Le generateur aleatoire utilise par le package
   randGen : Generator;
   
   
   -- Fonction permettant de tirer un nombre aleatoire
   -- - Entrees : les bornes inclusives de l'ensemble d'arrive
   -- - Sortie : un nombre aleatoire dans [min,max]
   function randomPos(min : Positive; max : Positive) return Positive;

end P_Aleatoire;
