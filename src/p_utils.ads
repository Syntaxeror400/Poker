package P_Utils is

   Type intArray is Array (Positive range <>) of Integer;
   Type posArray is Array (Positive range <>) of Positive;
   
   Type T_CompaComplete is (inf, ega, sup);
   Type compArray is Array (Positive range <>) of T_CompaComplete;
   
   function getModOf(modulus : Positive; number : Natural) return Natural;
   
end P_Utils;
