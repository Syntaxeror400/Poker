with P_Utils;
use P_Utils;

package P_Pot is
   
   Type T_Pot(nJoueurs : Integer) is limited private;
   
   procedure reset(pot : in out T_Pot; joueurs : in posArray);
   procedure addArgent(pot : in out T_Pot; montant : in Positive);
   function getArgent(pot : T_Pot) return Natural;
   function getJoueurs(pot : T_Pot) return posArray;
   
   function toString(pot : T_Pot) return String;
   
private
   
   Type T_Pot(nJoueurs : Integer) is record
      argent : Natural;
      joueurs : posArray(1..nJoueurs);
   end record;

end P_Pot;
