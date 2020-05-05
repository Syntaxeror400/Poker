with P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;

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
   procedure jouer_tour(miseMax: in Integer; CanRelance: in Boolean; joueur : in out T_Joueur; action : in out T_action) is
   begin
      null;
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
