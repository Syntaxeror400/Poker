package P_Utils is

   Type intArray is Array (Positive range <>) of Integer;
   Type posArray is Array (Positive range <>) of Positive;
   Type boolArray is Array (Positive range <>) of Boolean;
   Type T_CompaComplete is (inf, ega, sup);
   Type compArray is Array (Positive range <>) of T_CompaComplete;
   
   function getModOf(modulus : Positive; number : Natural) return Natural;
   
   generic
      Type T_Element is private;
      Type T_Liste is array (Positive range <>) of T_Element;
      with function comp(elem1 : T_Element; elem2 : T_Element) return boolean;
   function trierListe(liste : T_Liste) return T_Liste;
   
   
end P_Utils;
