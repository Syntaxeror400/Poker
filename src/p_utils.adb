package body P_Utils is
   
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
   
   
   procedure triDouble(liste1 : in out T_Liste1; liste2 : in out T_Liste2) is
      temp1 : T_Element1;
      temp2 : T_Element2;
      j : Positive;
   begin
      for i in (liste1'First+1)..liste1'Last loop
         temp1 := liste1(i);
         temp2 := liste2(i);
         j := i;
         while j>liste1'First and then comp(liste1(j-1), temp1) loop
            liste1(j) := liste1(j-1);
            liste2(j) := liste2(j-1);
            j := j-1;
         end loop;
         liste1(j) := temp1;
         liste2(j) := temp2;
      end loop;
   end;
   
      
   
end P_Utils;
