with ada.Text_IO, ada.Integer_Text_IO, P_table, P_Joueur, P_Action;
use P_table, P_Joueur, P_Action;

package GUI is
   
   -- Message d'ouverture
   procedure printBootUp;
   
   -- Recuperation du nombre de joueurs
   function getNJoueurs return Positive;
   
   -- Messages pour la cr�ation de la table
   -- - Entree : le nombre de joueurs
   -- - Sorite : la table avec toutes les informations
   function makeTable(nJoueurs : in Natural) return T_Table;
   
   -- Demande au joueur ce qu'il veut faire et retourne l'action choisie
   -- - Entree : la table et le joueur concernees
   -- - Sortie : l'action que je joueur veut effectuer
   function playTurn(table : T_Table; joueur : T_Joueur; jPos : Positive; dealer : boolean) return T_Action;
   
   -- Message pour indiquer qu'il est impossible de miser
   procedure cannotMise;
   
   -- Message pour indiquer une surmise insuffisante
   procedure mustMiseMore;
   
   -- Message pour indiquer qu'il faut all in
   procedure hasToAllIn;
   
   -- Message lors d'un gain de pot
   procedure winRound(joueur : String; argent : Natural);
   
   -- Message de fin de partie
   procedure winGame(joueur : String);
   
   -- Message lors d'un check au premier tour
   procedure mustPay;
   
   -- Afficher un blanc (permet de cacher les differentes informations)
   procedure printBlank(n : Positive);
   
   -- Afficher un message autre
   procedure println(text : String);
   
   -- Affiche le texte pour monter les blindes
   procedure monterBlindes(table : in out T_Table);
   
   -- Procedure permettant d'afficher plusieurs lignes en partant d'une chaine de caracteres
   -- - Entree : la chaine de caractere
   -- - Autre : execute le retour de ligne sur le caractere '\'
   procedure decodeString(str : String);
   
   
end GUI;
