with ada.Text_IO, ada.Integer_Text_IO, P_table, P_Joueur, Ada.characters.handling, P_Utils, Ada.Strings.Unbounded;
use ada.Text_IO, ada.Integer_Text_IO, P_table, P_Joueur, Ada.characters.handling, P_Utils, Ada.Strings.Unbounded;

package body GUI is

   procedure printBootUp is
   begin
      put_line("Lancement du programme de Poker");
      New_Line;
      put_line("Code par 'Les As du Poker' : ");
      put_Line("Remi LEMAIRE");
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
   
   function playTurn(table : T_Table; joueur : T_Joueur; jPos: Positive) return T_Action is
      done, ok : boolean;
      mise : Natural;
      str : Unbounded_String;
   begin
      Put_line(getName(joueur)& " : C'est a votre tour.");
      decodeString(toString(table));
      decodeString(getPots(table, jPos));
      
      done := false;								-- Ne passe jamais a vrai
      while not done loop
         Put_Line("Que voulez-vous faire ? Vous pouvez :");
         put_line("- Voire vos cartes : 'main'");
         put_line("- Vous coucher : 'coucher'");
         Put_Line("- Suivre la mise actuelle (checker si elle est de 0) : 'suivre'");
         Put_Line("- Miser ou surmiser : 'miser'");
         Put_Line("- Tapis : 'tapis'");
         New_Line;
         
         ok := false;
         while not ok loop
            str := To_Unbounded_String(Get_Line);
            if str = "main" then
               Put("Votre main est : ");
               Put_Line(montrerMain(joueur));
            elsif str = "coucher" then
               Put_Line("Etes vous sur de vouloir vous coucher ?(y/n)");
               if To_Lower(Get_Line(1)) = 'y'then
                  declare
                     ret : t_Action(Coucher);
                  begin
                     return ret;
                  end;
               end if;
            elsif str = "suivre" then
               Put_Line("Etes vous sur de vouloir vous suivre ?(y/n)");
               if To_Lower(Get_Line(1)) = 'y'then
                  declare
                     ret : T_Action(Suivre);
                  begin
                     return ret;
                  end;
               end if;
            elsif str = "miser" then
               Put_Line("Combien voulez-vous miser/surmiser ? (Indiquer la mise totale finale, 0 pour annuler)");
               get(mise);
               Skip_Line;
               
               while (not(mise = 0)) or mise < getMiseMax(table) loop
                  Put_Line("La mise doit depasser "& Integer'Image(getMiseMax(table))& "(0 pour annuler)");
                  get(mise);
                  Skip_Line;
               end loop;
               if mise >0 then
                  return creerMise(mise);
               end if;
            elsif str = "tapis" then
               Put_Line("Etes vous sur de vouloir faire tapis ?(y/n)");
               if To_Lower(Get_Line(1)) = 'y'then
                  declare
                     ret : t_Action(Tapis);
                  begin
                     return ret;
                  end;
               end if;
            else
               Put_Line("Veuillez rentrer une commande valide.");
            end if;
         end loop;
      end loop;
   end;
   
   procedure cannotMise is
   begin
      Put_Line("Vous ne pouvez plus surmiser.");
   end;
   
   procedure mustMiseMore is
   begin
      Put_Line("Vous devez miser plus du double de la mise actuelle");
   end;
   
   
   procedure decodeString(str : String) is					-- Importe du projet PICROSS
      temp : Integer :=1;
   begin
      for i in 1..str'Length loop
         if str(i) = '\' then
            put_line(str(temp..i-1));
            temp := i+1;
         end if;
      end loop;
   end decodeString;
   
   
   
end GUI;
