package body P_Action is
   
   function creerMise(mise : Positive) return T_Action is
      act : T_Action(Miser);
   begin
      act.mise_totale := mise;
      return act;
   end;
   
   function getMise(act : T_Action) return Natural is
   begin
      if act.elem = Miser then
         return act.mise_totale;
      else
         return 0;
      end if;
   end;

end P_Action;
