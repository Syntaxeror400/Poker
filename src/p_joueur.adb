with P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Action, P_Utils, Ada.Strings.Unbounded;

Package body P_Joueur is 
   
   -- action : stock les cartes données par la table
   procedure prendreCartes(cartes : in T_tab_cartes; joueur : in out T_Joueur) is 
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
   procedure montrermain(joueur : in T_Joueur) is 
   begin
      toString(joueur.main(1));
      tostring(joueur.main(2));
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
   str := "Le joueur "& To_Unbounded_String(joueur.nom) &
     " à " & To_Unbounded_String(Integer'image(joueur.argent)) & "euros et sa mise est de " & To_Unbounded_String(Integer'Image(joueur.MiseActuelle))
     & ". Il possede " & To_Unbounded_String(montrermain(joueur)) & " et " ;
   if joueur.En_jeu = True then
      str := str  & "est en jeu.";
   else
      str := str & "n'est pas en jeu";
   end if; 
   return To_String(str);
end;

   
   
end P_Joueur;
