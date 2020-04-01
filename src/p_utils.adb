package body P_Utils is
   
   function getModOf(modulus : Positive; number : Natural) return Natural is
      ret : Natural := number; 
   begin
      while ret > modulus loop
         ret := ret - modulus;
      end loop;
      return ret;
   end;
   
   function trierListe(liste : T_Liste) return T_Liste is			-- Implémentation d'un tris par inserstion
      ret : T_Liste(liste'Range);
      temp : T_Element;
      j : Positive;
   begin
      for i in liste'Range loop
         ret(i) := liste(i);
      end loop;
      
      for i in (ret'First+1)..ret'Last loop
         temp := ret(i);
         j := i;
         while j>ret'First and then comp(ret(j-1), temp) loop
            ret(j) := ret(j-1);
            j := j-1;
         end loop;
         ret(j) := temp;
      end loop;
      
      return ret;
   end;
   
   
end P_Utils;
