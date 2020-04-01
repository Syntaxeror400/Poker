package body P_Utils is
   
   function getModOf(modulus : Positive; number : Natural) return Natural is
      ret : Natural := number; 
   begin
      while ret > modulus loop
         ret := ret - modulus;
      end loop;
      return ret;
   end;
   
   function trierListe(liste : T_Liste) return T_Liste is			-- Implémentation d'un tris par tas
      procedure prepTas is new prepTasGEN(T_Element => T_Element,
                                          T_Liste => T_Liste,
                                          comp => comp);
      
      n : Positive := liste'Length;
      ret : T_Liste(liste'Range);
      temp : T_Element;
   begin
      for i in liste'Range loop
         ret(i) := liste(i);
      end loop;
      
      for i in ret'First..(ret'First+n/2) loop
         prepTas(ret, ret'First+n/2-i+1, ret'Last);
      end loop;
      for i in (ret'First+1)..ret'Last loop
         temp := ret(i);
         ret(i) := ret(ret'First);
         ret(ret'First) := temp;
         
         prepTas(ret, 1, i-1);
      end loop;
      
      return ret;
   end;
   
   
   -- Private
   
   procedure prepTasGEN(liste : in out T_Liste; noeud : in Positive; max : in Positive) is
      temp : T_Element;
      
      k : Positive := noeud;
      j : Positive := 2*noeud;
   begin      
      while j <= max loop
         if j < max and then comp(liste(j), liste(j+1)) then
            j := j+1;
         end if;
         if comp(liste(k), liste(j)) then
            temp := liste(j);
            liste(j) := liste(k);
            liste(k) := temp;
            
            k := j;
            j := 2*k;
         else
            j := max+1;
         end if;
      end loop;
   end;
   
   
end P_Utils;
