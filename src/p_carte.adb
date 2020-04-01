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
   
   function trouverCombinaison(deck : T_Deck) return T_Combinaison is
      deckSize : Natural := deck'Length;
   begin
      if deckSize = 0 then							-- Deck vide
         return makeCombi(CarteForte, none, none, none);
      elsif deckSize <= 1 then							-- Deck de 1 carte
         return makeCombi(CarteForte, deck(1).valeur,none,none);		-- Carte forte sans kicker
      elsif deckSize <=2 then							-- Deck de 2 cartes
         case comparer(deck(1), deck(2)) is					-- Paire sans kicker / Carte forte avec kicker
            when ega => return makeCombi(Paire, deck(1).valeur, none, none);
            when sup => return makeCombi(CarteForte, deck(1).valeur, deck(2).valeur, none);
            when inf => return makeCombi(CarteForte, deck(2).valeur, deck(1).valeur, none);
         end case;
      elsif deckSize <=3 then							-- Deck de 3 cartes
         declare
            sorted : T_Deck := sortDeck(deck);
            egas : boolArray(1..2);
         begin
            egas(1) := comparer(sorted(1),sorted(2))=ega;
            egas(2) := comparer(sorted(2),sorted(3))=ega;
            
            if egas(1) and egas(2) then						-- Brelan sans kicker
               return makeCombi(Brelan, sorted(1).valeur, none, none);
            else
               if egas(1) then							-- Paire avec kicker
                  return makeCombi(Paire, sorted(1).valeur, sorted(3).valeur, none);
               elsif egas(2) then
                  return makeCombi(Paire, sorted(2).valeur, sorted(1).valeur, none);
               else								-- Carte forte avec kicker
                  return makeCombi(CarteForte, sorted(1).valeur, sorted(2).valeur, none);
               end if;
            end if;
         end;
      elsif deckSize <=4 then							-- Deck de 4 cartes
         declare
            sorted : T_Deck := sortDeck(deck);
            egas : boolArray(1..3);
         begin
            egas(1) := comparer(sorted(1),sorted(2))=ega;
            egas(2) := comparer(sorted(2),sorted(3))=ega;
            egas(3) := comparer(sorted(3),sorted(4))=ega;
            
            if egas(1) and egas(2) and egas(3) then				-- Carre sans kicker
               return makeCombi(Carre, sorted(1).valeur, none, none);
            else
               if egas(1) and egas(2) then					-- Brelan avec kicker
                  return makeCombi(Brelan, sorted(1).valeur, sorted(4).valeur, none);
               elsif egas(2) and egas(3) then
                  return makeCombi(Brelan, sorted(2).valeur, sorted(1).valeur, none);
               else
                  if egas(1) then						-- Double paire sans kicker
                     if egas(3) then
                        return makeCombi(DoublePaire, sorted(1).valeur, none, sorted(3).valeur);
                     else							-- Paire avec kicker
                        return makeCombi(Paire, sorted(1).valeur, sorted(3).valeur, none);
                     end if;
                  elsif egas(2) then
                     return makeCombi(Paire, sorted(2).valeur, sorted(1).valeur, none);
                  elsif egas(3) then
                     return makeCombi(Paire, sorted(3).valeur, sorted(1).valeur, none);
                  else								-- Carte forte avec kicker
                     return makeCombi(CarteForte, sorted(1).valeur, sorted(2).valeur, none);
                  end if;
               end if;
            end if;
         end;
      elsif deckSize <=5 then							-- Deck de 5 cartes
         declare
            sorted : T_Deck := sortDeck(deck);
            couleur, suite : boolean := false;
            egas : boolArray(1..4);
         begin
            egas(1) := comparer(sorted(1),sorted(2))=ega;
            egas(2) := comparer(sorted(2),sorted(3))=ega;
            egas(3) := comparer(sorted(3),sorted(4))=ega;
            egas(4) := comparer(sorted(4),sorted(5))=ega;
            
            couleur := deck(1).couleur = deck(2).couleur and deck(2).couleur = deck(3).couleur
              and deck(3).couleur = deck(4).couleur and deck(4).couleur = deck(5).couleur;
            suite := T_Val'Pred(sorted(1).valeur) = sorted(2).valeur and T_Val'Pred(sorted(2).valeur) = sorted(3).valeur
              and T_Val'Pred(sorted(3).valeur) = sorted(4).valeur and T_Val'Pred(sorted(4).valeur) = sorted(5).valeur;
            
            if couleur and suite then						-- QuinteFlush
               return makeCombi(QuinteFlush, sorted(1).valeur, none, none);
            else
               if egas(1) and egas(2) and egas(3) then				-- Carre avec kicker
                  return makeCombi(Carre, sorted(1).valeur, sorted(5).valeur, none);
               elsif egas(2) and egas(3) and egas(4) then
                  return makeCombi(Carre, sorted(2).valeur, sorted(1).valeur, none);
               else
                  if egas(1) and egas(3) and egas(4) then			-- Full
                     return makeCombi(Full, sorted(3).valeur, none, sorted(1).valeur);
                  elsif egas(1) and egas(2) and egas(4) then
                     return makeCombi(Full, sorted(1).valeur, none, sorted(4).valeur);
                  else
                     if couleur then						-- Couleur
                        return makeCombi(Flush, sorted(1).valeur, none, none);
                     else
                        if suite then						-- Suite
                           return makeCombi(Quint, sorted(1).valeur, none, none);
                        else
                           if egas(1) and egas(2) then				-- Brelan avec kicker
                              return makeCombi(Brelan, sorted(1).valeur, sorted(4).valeur, none);
                           elsif egas(2) and egas(3) then
                              return makeCombi(Brelan, sorted(2).valeur, sorted(1).valeur, none);
                           elsif egas(3) and egas(4) then
                              return makeCombi(Brelan, sorted(3).valeur, sorted(1).valeur, none);
                           else
                              if egas(1) then
                                 if egas(3) then				-- Paire avec kicker et double paire avec kicker
                                    return makeCombi(DoublePaire, sorted(1).valeur, sorted(5).valeur, sorted(3).valeur);
                                 elsif egas(4) then
                                    return makeCombi(DoublePaire, sorted(1).valeur, sorted(3).valeur, sorted(5).valeur);
                                 else						
                                    return makeCombi(Paire, sorted(1).valeur, sorted(3).valeur, none);
                                 end if;
                              elsif egas(2) then
                                 if egas(4) then
                                    return makeCombi(DoublePaire, sorted(2).valeur, sorted(1).valeur, sorted(4).valeur);
                                 else
                                    return makeCombi(Paire, sorted(2).valeur, sorted(1).valeur, none);
                                 end if;
                              elsif egas(3) then
                                 return makeCombi(Paire, sorted(3).valeur, sorted(1).valeur, none);
                              elsif egas(4) then
                                 return makeCombi(Paire, sorted(4).valeur, sorted(1).valeur, none);
                              else						-- Carte forte avec kicker
                                 return makeCombi(CarteForte, sorted(1).valeur, sorted(2).valeur, none);
                              end if;
                           end if;
                        end if;
                     end if;
                  end if;
               end if;
            end if;
         end;
      else									-- Deck de plus de 5 cartes
         declare
            tempDeck : T_Deck(1..5);
            ret, temp : T_Combinaison;
         begin
            ret := makeCombi(CarteForte, none, none, none);			-- On declare ret avec la combinaison la plus faible
            
            for i1 in 1..(deckSize-4) loop					-- On itere parmis toutes les combinaisons de 5 cartes possibles
               tempDeck(1) := deck(i1);
               for i2 in (i1+1)..(deckSize-3) loop
                  tempDeck(2) := deck(i2);
                  for i3 in (i2+1)..(deckSize-2) loop
                     tempDeck(3) := deck(i3);
                     for i4 in (i3+1)..(deckSize-1) loop
                        tempDeck(4) := deck(i4);
                        for i5 in (i4+1)..deckSize loop
                           tempDeck(5) := deck(i5);
                           
                           temp := trouverCombinaison(tempDeck);		-- Si on trouve une meilleure combinaison on la garde	
                           if compaCombi(temp, ret) = sup then
                              ret := temp;
                           end if;
                        end loop;
                     end loop;
                  end loop;
               end loop;
            end loop;
            
            return ret;
         end;
      end if;
   end;
   
   function compaCombi(combi1 : T_Combinaison; combi2 : T_Combinaison) return T_CompaComplete is
   begin
      case compaCombElem(combi1.combi, combi2.combi) is
      when sup => return sup;
      when inf => return inf;
      when ega =>
         case compaVal(combi1.valeur, combi2.valeur) is
         when sup => return sup;
         when inf => return inf;
         when ega =>
            if combi1.double then
               case compaVal(combi1.valeurSec, combi2.valeurSec) is
               when sup => return sup;
               when inf => return inf;
               when ega => null;
               end case;
            end if;
            case compaVal(combi1.kicker, combi2.kicker) is
               when sup => return sup;
               when inf => return inf;
               when ega => return ega;
            end case;
         end case;
      end case;
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
   
   function makeCombi(combi : T_CombElem; val : T_Val; kick : T_Val; valSeq : T_Val) return T_Combinaison is
   begin
      if combi = Full or combi = DoublePaire then
         declare
            ret : T_Combinaison(true);
         begin
            ret.combi := combi;
            ret.valeur := val;
            ret.kicker := kick;
            ret.valeurSec := valSeq;
            
            return ret;
         end;
      else
         declare
            ret : T_Combinaison(false);
         begin
            ret.combi := combi;
            ret.valeur := val;
            ret.kicker := kick;
            
            return ret;
         end;
      end if;
   end;
   
   function compaCombElem(combi1 : T_CombElem; combi2 : T_CombElem) return T_CompaComplete is
   begin
      if combi1 < combi2 then
         return inf;
      elsif combi1 > combi2 then
         return sup;
      else
         return ega;
      end if;
   end;
   
   function compaVal(val1 : T_Val; val2 :T_Val) return T_CompaComplete is
   begin
      if val1 < val2 then
         return inf;
      elsif val1 > val2 then
         return sup;
      else
         return ega;
      end if;
   end;
   
   function compSort(c1 : T_Carte; c2 : T_Carte) return boolean is
   begin
      return comparer(c1,c2) = sup;
   end;   
   
   
end P_Carte;
