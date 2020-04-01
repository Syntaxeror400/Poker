package body P_Utils is
   
   function getModOf(modulus : Positive; number : Natural) return Natural is
      ret := Natural := number; 
   begin
      while ret > modulus loop
         ret := ret - modulus;
      end loop;
      return ret;
   end;
   
   
end P_Utils;
