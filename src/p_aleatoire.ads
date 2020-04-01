with Ada.Numerics.Float_Random, Ada.Containers.Vectors;
use Ada.Numerics.Float_Random;

generic
   Type T_Element is private;
   Type T_Liste is array (Positive range <>) of T_Element;
   
package P_Aleatoire is
      
   package P_Vectors is new Ada.Containers.Vectors(Positive, T_Element);
   use P_Vectors;
   
   procedure resetGenerator;
   
   function getRandomElement(min : Positive; max : Positive; table : T_Liste) return T_Element;
   function shuffle(min : Positive; max : Positive; table : T_Liste) return T_Liste;
   
private
   
   randGen : Generator;
   
   function randomPos(min : Positive; max : Positive) return Positive;

end P_Aleatoire;
