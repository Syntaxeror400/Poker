with ada.Text_IO, ada.Integer_Text_IO, P_table, P_Joueur, Ada.characters.handling, P_Utils;
use ada.Text_IO, ada.Integer_Text_IO, P_table, P_Joueur, Ada.characters.handling, P_Utils;

package body GUI is

   procedure printBootUp is
   begin
      put_line("Lancement du programme de Poker");
      New_Line;
      put_line("Codé par 'Les As du Poker' : ");
      put_Line("Rémi LEMAIRE");
      put_Line("Antonin GARREAU");
      put_Line("Hugo GIRODON");
      put_Line("Martin GRAUER");
      New_Line;
      Put_Line("----------");
   end;
   
   function getNJoueurs return Positive is
      n : Integer;
      ok : boolean;
   begin
      Put_Line("Combien de joueurs voulez vous ajouter dans la partie ? Attention,c'est impossible de le changer par la suite !)");
      get(n);
      Skip_Line;
      
      while n < 2 loop
         Put_Line("Il faut au moins deux joueur pour une partie de poker ! Encore un essaie :");
           get(n);
           skip_line;
      end loop;
      Put_Line("Vous voulez creer une partie avec"& Integer'Image(n)& "joueurs ? (y/n)");
      ok := Get_Line(1) = 'y';
      
      while not ok loop
         Put_Line("Combien de joueurs voulez vous ajouter dans la partie ?");
         get(n);
         Skip_Line;
         
         while n < 2 loop
            Put_Line("Il faut au moins deux joueur pour une partie de poker ! Encore un essaie :");
              get(n);
              Skip_Line;
         end loop;
         Put_Line("Vous voulez creer une partie avec "& Integer'Image(n)& " joueurs ? (y/n)");
         ok := to_lower(Get_Line(1))= 'y';
      end loop;
      
      return n;
   end;
   
   function makeTable(nJoueurs : in Natural) return T_Table is
      table : T_Table(nJoueurs);
      joueurs : tabJoueur(1..nJoueurs);
      ok : boolean;
      money : natural;
      blinde : natArray(1..2);
   begin
      ok := false;      
      while not ok loop
         Put_line("Avec quelle quantité d'argent chaque joueur commence ?");
         get(money);
         skip_Line;
         if money >0 then
            Put_Line(Integer'Image(money)& ", est-ce bon ? (y/n)");
            ok := to_lower(Get_Line(1))= 'y';
         else
            Put_Line("Il faut un montant minimum de 0 !");
            ok := false;
         end if;
      end loop;
      
      Put_Line("Veuillez donner les noms des joueurs : ");
      for i in 1..nJoueurs loop
         ok := false;
         while not ok loop
            put("Joueur "& Integer'Image(i)& " : ");
            joueurs(i) := creerJoueur(Get_Line, money);
            Put_Line("'"& getName(joueurs(i))& "', est-ce bon ? (y/n)");
            ok := to_lower(Get_Line(1))= 'y';
         end loop;
      end loop;
      
      Put_Line("Creation de la table");
      table := P_table.creeTable(joueurs, nJoueurs);
      Put_Line("Table creee ! Shouaitez vous modifier les blindes, actuellement (25/50) ? (y/n)");
      ok := to_lower(Get_Line(1))= 'y';
      if ok then
         ok := false;      
         while not ok loop
            Put_line("Quel est la petite blinde ?");
            get(blinde(1));
            skip_Line;
            if money >0 then
               Put_Line(Integer'Image(money)& ", est-ce bon ? (y/n)");
               ok := to_lower(Get_Line(1))= 'y';
            else
               Put_Line("Il faut un montant minimum de 0 !");
               ok := false;
            end if;
         end loop;
         ok := false;      
         while not ok loop
            Put_line("Quel est la grosse blinde ?");
            get(blinde(2));
            skip_Line;
            if money >0 then
               Put_Line(Integer'Image(money)& ", est-ce bon ? (y/n)");
               ok := to_lower(Get_Line(1))= 'y';
            else
               Put_Line("Il faut un montant minimum de "& Integer'Image(blinde(1))&" !");
               ok := false;
            end if;
         end loop;
         P_table.Monter_blindes(table,blinde(1) ,blinde(2));
         Put_Line("Blinde changees !");
      end if;
      New_Line;
      Put_Line("La table est prete !");
      New_Line;
      Put_Line("----------");
      return table;
   end;
   
   
   
end GUI;
