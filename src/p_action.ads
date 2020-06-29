package P_Action is
   
   Type T_ActionElem is (Coucher, Miser, Suivre, Tapis);
   Type T_Action(elem : T_ActionElem) is private;
   
   
   -- Fonction permettant de creer une action miser
   -- - Entree : un montant
   -- - Sortie : l'action "Miser" ce montant
   function creerMise(mise : Positive) return T_Action;
   
   -- Fonction permettant de recuperer l'information mise_totale d'une action
   -- - Entree : une action
   -- - Sortie :	- mise_totale si l'action est de type mise
   --		- 0 sinon
   function getMise(act : T_Action) return Natural;
   
   -- Fonction permettant de recuperer l'action elementaire d'une action
   -- - Entree : une action
   -- - Sortie : l'action elementaire
   function getElem(act : T_Action) return T_ActionElem;
   
private
   
   Type T_Action(elem : T_ActionElem) is record
      case elem is
         when Coucher =>
            null;
         when Miser =>
            mise_totale : Positive;
         when Suivre =>
            null;
         when Tapis =>
            null;
      end case;
   end record;

end P_Action;
