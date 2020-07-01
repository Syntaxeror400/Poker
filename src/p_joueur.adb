with P_Carte, P_Utils, Ada.Strings.Unbounded;
use P_Carte, P_Utils, Ada.Strings.Unbounded;

Package body P_Joueur is 
   
   function creerJoueur(nom : in String; argent : in Natural) return T_Joueur is
      pl : T_Joueur;
   begin
      pl.nom := To_Unbounded_String(nom);
      pl.argent := argent;
      pl.mise := 0;
      pl.en_jeu := true;
      
      return pl;
   end;
   
   procedure prendreCartes(cartes : in T_Deck; joueur : in out T_Joueur) is 
   begin
      joueur.main(1) := cartes(1);
      joueur.main(2) := cartes(2);
   end;
   
   procedure gagnerMise(mise :  in integer; joueur : in out T_Joueur) is 
   begin
      joueur.argent := joueur.argent + mise;
   end;
   
   function montrermain(joueur : in T_Joueur) return String is
   begin
      return toString(joueur.main(1)) & " et " & tostring(joueur.main(2));
   end;
   
   procedure poserBlinde(joueur : in out T_Joueur; blinde : in natural) is
   begin
      if joueur.mise = 0 then
         Miser(joueur, blinde);
      end if;
   end;
      
   procedure finManche(joueur : in out T_Joueur) is 
   begin
      joueur.mise := 0;
      joueur.en_jeu := joueur.argent > 0;
   end;
   
   procedure finTour(joueur : in out T_Joueur) is
   begin
      joueur.mise :=0;
   end;
   
   function jouerTour(miseActuelle : in Natural; joueur : in out T_Joueur; action : in T_Action) return boolean is
   begin
      case getElem(action) is
         when Coucher =>
            joueur.en_jeu := False;
            return True;
         when Suivre =>
            miser(joueur, miseActuelle-joueur.mise);
            return true;
         when Miser =>
            miser(joueur, getMise(action)-joueur.mise);
            return true;
         when Tapis =>
            miser(joueur, joueur.argent);
            return true;
      end case;
   end;
            
   function getArgent(joueur :  in T_Joueur) return Integer is
   begin
      return joueur.argent;
   end;
   
   function getMise(joueur: in T_Joueur) return Natural is
   begin
      return joueur.mise;
   end;
   
   function getName(joueur : in T_Joueur) return String is
   begin
      return To_String(joueur.nom);
   end;
   
   function getCartes(joueur : in T_Joueur) return T_Deck is
   begin
      return clonerDeck(joueur.main);
   end;
   
   function isPlaying(joueur : in T_Joueur) return boolean is
   begin
      return joueur.en_jeu;
   end;
   
   function toString(joueur : in T_Joueur) return string is
      str : Unbounded_String;
   begin
      str := "Joueur : "& joueur.nom &", argent : " & Integer'image(joueur.argent)
        & " et sa mise est de " & Integer'Image(joueur.mise) 
        & ".\Ses cartes sont " & To_Unbounded_String(montrermain(joueur)) & " et il/elle " ;
      if joueur.En_jeu = True then
         str := str  & "est en jeu.";
      else
         str := str & "n'est pas en jeu";
      end if; 
      return To_String(str);
   end;
   
   
   -- PRIVATE
   
   procedure miser(joueur : in out T_Joueur; montant : in Natural) is
   begin
      if joueur.argent > montant then
         joueur.argent := joueur.argent - montant;
         joueur.mise := joueur.mise + montant;
      else
         raise Has_To_All_In_Exception;
      end if;
   end;
   
   
end P_Joueur;
