with Ada.Numerics.Float_Random, Ada.Containers.Vectors;

package body P_Aleatoire is
   
   procedure resetGenerator is
   begin
      reset(randGen);
   end;
   
   function getRandomElement(min : Positive; max : Positive; table : T_Liste) return T_Element is
   begin
      return table(randomPos(min,max));
   end;
   
   function shuffle(min : Positive; max : Positive; table : T_Liste) return T_Liste is
      index : Positive;
      vec : Vector;
      ret : T_Liste(1..max-min+1);
   begin
      for i in min..max loop							-- On remplie le vecteur avec toutes les cartes
         Append(vec,table(i));
      end loop;
      for i in 1..max-min+1 loop						-- On tire les cartes du vecteur une par une
         index := randomPos(1, max-min+2-i);					--	et on les insere dans la nouvelle table
         ret(i) := Element(vec,index);
         Delete(vec,Index);
      end loop;
      return ret;
   end;
   
   
   -- Private
   
   
   function randomPos(min : Positive; max : Positive) return Positive is
   begin
      return Integer(Random(randGen)*Float(max-min)) + min;			-- Conversion d'un Float [0, 1[ en Positive [min, max]
   end;
   
end P_Aleatoire;
