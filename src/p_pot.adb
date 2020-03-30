with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

package body P_Pot is
   
   procedure reset(pot : in out T_Pot; joueurs :in posArray) is
   begin
      pot.argent := 0;
      pot.joueurs := joueurs;
   end;
   
   procedure addArgent(pot : in out T_Pot; montant : in Positive) is
   begin
      pot.argent := pot.argent + montant;
   end;
   
   function getArgent(pot : T_Pot) return Natural is
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
