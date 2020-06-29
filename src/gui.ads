with ada.Text_IO, ada.Integer_Text_IO, P_table;
use ada.Text_IO, ada.Integer_Text_IO, P_table;

package GUI is
   
   -- Message d'ouverture
   procedure printBootUp;
   
   -- Recuperation du nombre de joueurs
   function getNJoueurs return Positive;
   
   -- Messages pour la création de la table
   -- - Entree : le nombre de joueurs
   -- - Sorite : la table avec toutes les informations
   function makeTable(nJoueurs : in Natural) return T_Table;

end GUI;
