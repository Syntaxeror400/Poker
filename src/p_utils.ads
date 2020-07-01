package P_Utils is
   
   -- Types classique permettant d'uniformiser les types des arguments et retours de methode
   Type intArray is Array (Positive range <>) of Integer;			-- Table d'entiers
   Type natArray is Array (Positive range <>) of Natural;			-- Table de naturels
   Type posArray is Array (Positive range <>) of Positive;			-- Table d'entiers positifs
   Type boolArray is Array (Positive range <>) of Boolean;			-- Table de booleens

   -- Types lies a la comparaison
   Type T_CompaComplete is (inf, ega, sup);					-- Comparaison complete : comparaisons strictes et egalite
   Type compArray is Array (Positive range <>) of T_CompaComplete;		-- Table de comparaisons
   
   
   -- Fonction generique de tri par insertion
   -- - Entree : une table a trier
   -- - Sortie : une copie triee de la table
   -- - Autre : si la fonction de comparaison agit comme '<', la table est triee dans l'ordre decroissant
   generic
      Type T_Element is private;
      Type T_Liste is array (Positive range <>) of T_Element;
      with function comp(elem1 : T_Element; elem2 : T_Element) return boolean;
   function trierListe(liste : T_Liste) return T_Liste;
   
   -- Procedure permettant de trier une liste et d'effectuer les memes operations sur une seconde liste
   -- - Entrees :	- liste1 : la liste  a trier
   --		- liste2 : la liste qui subiera les meme operations
   -- - Autre :	- les listes doivent etre de meme taille et indexees de la meme maniere (liste1'Range = liste2'Range)
   --		- si la fonction de comparaison agit comme '<', la table est triee dans l'ordre decroissant
   generic
      Type T_Element1 is private;
      Type T_Element2 is private;
      Type T_Liste1 is array (Positive range <>) of T_Element1;
      Type T_Liste2 is array (Positive range <>) of T_Element2;
      with function comp(e1a : T_Element1; e1b : T_Element1) return boolean;
   procedure triDouble(liste1 : in out T_Liste1; liste2 : in out T_Liste2);
      
      
      
end P_Utils;
