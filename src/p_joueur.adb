with P_Carte, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Utils, Ada.Strings.Unbounded;

Package body P_Joueur is 
   
   -- action : stock les cartes données par la table
   procedure prendreCartes(cartes : in T_Deck; joueur : in out T_Joueur) is 
   begin
      joueur.main(1) := cartes(1);
      joueur.main(2) := cartes(2);
   end;
   
   -- action : récupère l'argent
   procedure gagnerMise(mise : in integer; joueur : in out T_Joueur) is 
   begin
      joueur.argent := joueur.argent + mise;
   end;
   
   -- action : montre les cartes de la main d'un joueur
   function montrermain(joueur : in T_Joueur) return String is
   begin
      return toString(joueur.main(1)) & " et " & tostring(joueur.main(2));
   end;
   
   
   -- action : remet tous les compteurs de parties à 0 pour pouvoir commencer à jouer une nouvelle main
   procedure FinTour(joueur : in out T_Joueur) is 
   begin
      null;
   end;
   
   -- action : joue un tour et renvoie l'action choisie
   procedure jouer_tour(miseMax: in out Integer; CanRelance: in Boolean; joueur : in out T_Joueur; action : in T_action) is
      val : integer;
   begin
      -- Il faudra gerer en amont quand les actions comme checker sont disponibles ou non
      Case action is
      when 'Coucher' => return("le joueur se couche");
      When 'Checker' => return("le joueur check");  
      When 'Miser' => -- je suppose qu'on utilise l'action miser que pour un joueur n'ayant pas encore de mise (joueur.mise =0) il na pas perdu d'argent.
         put_line("Combien tu veux miser ?");
         get(valeur);
         While joueur.argent < valeur loop
            put_line("Tu ne peux pas miser cette somme");
            put_line("Combien tu veux miser ?");
            get(valeur);
         end loop;
         joueur.argent = joueur.argent - valeur;
         joueur.mise = valeur;
         return("le joueur mise "&Integer'Image(valeur));
      when 'Suivre' =>  
         If joueur.argent<miseMax then
            return("le joueur ne peut pas suivre");
         
         joueur.argent := joueur.argent + joueur.mise; -- Le joueur avait déjà perdu de l'argent avant. 
         joueur.mise := miseMax;
         joueur.argent := joueur.argent - miseMax;
         return("le joueur suit");
      When 'Surmiser' =>
         if CanRelance = True then
            put_line("Tu relance a combien ?");
            get(miseMax); -- faut-il vérifier que sa relance est supérieur à la mise précédente ?)
            put_line("Le joueur " & joueur.nom & " a decide de relancer a " & Integer'Image(miseMax) " euros");
            joueur.mise = joueur.mise + miseMax
         else
         
         
   end;
   
   -- action : convertit les informations concernant le joueur en string
   function toString(joueur : in T_Joueur) return string is
      str : Unbounded_String;
   begin
      str := "Joueur : "& joueur.nom &", argent : " & Integer'image(joueur.argent)
        & " et sa mise est de " & Integer'Image(joueur.mise) 
        & ". Ses cartes sont " & To_Unbounded_String(montrermain(joueur)) & " et il/elle " ;
      if joueur.En_jeu = True then
         str := str  & "est en jeu.";
      else
         str := str & "n'est pas en jeu";
      end if; 
      return To_String(str);
   end;
   
   
   
end P_Joueur;
