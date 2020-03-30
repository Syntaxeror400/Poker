with Ada.Strings.Unbounded, P_utils;
use Ada.Strings.Unbounded, P_Utils;

package body P_Carte is

   function comparer(carte1:T_Carte; carte2:T_Carte) return T_CompaComplete is
   begin
      if carte1.valeur > carte2.valeur then
         return sup;
      elsif carte1.valeur < carte2.valeur then
         return inf;
      else
         return ega;
      end if;
   end;
   
   function clonerDeck(deck:T_Deck) return T_Deck is
      ret : T_Deck(deck'Range);
   begin
      for i in deck'Range loop
         ret(i) := deck(i);
      end loop;
      return ret;
   end;
   
   function deckComplet return T_Deck is
      ret : T_Deck(1..Nombre_Max_Cartes);
      i : Positive :=1;
   begin
      for coul in T_Coul loop
         for val in T_Val loop
            ret(i) := makeCarte(coul, val);
            i := i+1;
         end loop;
      end loop;
      return ret;
   end;
   
   function trouverCombinaison(cartes : T_Deck) return T_Combinaison is
   begin
      
   end;
   
   function compaCombi(combi1 : T_Combinaison; combi2 : T_Combinaison) return T_CompaComplete is
   begin
      if combi1.combi <= combi2.combi then
         
      else
         
      end if;
   end;
   
   function toString(carte:T_Carte) return String is
   begin
      return T_Val'Image(carte.valeur)& " de "& T_Coul'Image(carte.couleur);
   end;
   
   function toString(deck:T_Deck) return String is
      str : Unbounded_String;
   begin
      str := "Deck de "& To_Unbounded_String(Integer'Image(deck'Length))& " carte(s):{";
      for i in deck'Range loop
         str := str& toString(deck(i));
         if i+1 < deck'Last then
            str := str& ",";
         end if;
      end loop;
      str := str& "}";
      return To_String(str);
   end;
   
   
   -- Private
   
   
   function makeCarte(coul : T_Coul; val : T_Val) return T_Carte is
      ret : T_Carte;
   begin
      ret.couleur := coul;
      ret.valeur := val;
      return ret;
   end;
   
end P_Carte;
