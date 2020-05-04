package P_Utils is
   
   -- Types classique permettant d'uniformiser les types des arguments et retours de methode
   Type intArray is Array (Positive range <>) of Integer;			-- Table d'entiers
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
   
   
end P_Utils;
