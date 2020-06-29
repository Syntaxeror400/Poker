with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body P_Pot is
   
   procedure creerPot(n : in nJoueurs; joueurs :in posArray) is
      ret : T_Pot(n);
   begin
      ret.argent := 0;
      for i in 1..ret.nJoueurs loop
         if i <= joueurs'Length then
            ret.joueurs(i) := joueurs(i);
         else
            ret.joueurs(i) := 0;
         end if;
      end loop;
      return ret;
   end;
   
   procedure addArgent(pot : in out T_Pot; montant : in Positive) is
   begin
      pot.argent := pot.argent + montant;
   end;
   
   function getPotArgent(pot : T_Pot) return Natural is
   begin
      return pot.argent;
   end;
   
   function getJoueurs(pot : T_Pot) return posArray is
   begin
      return pot.joueurs;
   end;
   
   
   function toString(pot : T_Pot) return String is
      ret : Unbounded_String;
   begin
      ret := "Pot de : "& To_Unbounded_String(Natural'Image(pot.argent))& " accessible a "& To_Unbounded_String(pot.joueurs'Length)& " joueur(s) :{";
      for i in pot.joueurs'Range loop
         ret := ret& Positive'Image(pot.joueurs(i));
         if i+1 < pot.joueurs'Last then
            ret := ret& ",";
         end if;
      end loop;
      ret := ret& "}";
      return To_String(ret);
   end;
   
end P_Pot;
