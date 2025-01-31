/* ***************************************** TP4 - Sujet 1 *************************************************** *
                                    Fait par : NGANGA Brech Movil
                                    numero d'etudiant : 12308151
                              *****************************************                                       */


/*1. Importation du fichier gold, en le stockant dans une table gold. */

	FILENAME REFFILE '/home/u63655637/sasuser.v94/gold.csv';
	
	PROC IMPORT DATAFILE=REFFILE
		DBMS=CSV
		OUT=WORK.IMPORT;
		GETNAMES=YES;
	RUN;

	/* Stockage dans une table gold */
	data work.gold;
		set work.import;
	run;
	

/*2. Imprimer un rapport sur la table gold */
 
	 proc contents data=gold;
	 run;
	 
	/* La table contient 3904 observations et 47 variables
	- variable alphanumerique : GDP
	- variable numerique : CPI */

/*3. Renommage de la variable gold open en gold_open */

	data gold;
		set gold;
		rename 'gold open'n= gold_open;
	run;

	/* Procédure pour renommer les autres variables */
	data gold;
	    set gold;
	    rename 
	        'sp500 open'n = sp500_open
	        'sp500 volume'n = sp500_volume
	        'silver open'n = silver_open
	        'silver volume'n = silver_volume
	        'gold volume'n = gold_volume;
	run;

/*4. Creer une table gold2 contenant uniquement 5 variables precedentes, plus les variables .. */

	data gold2;
		set gold;
		keep sp500_open sp500_volume silver_open silver_volume gold_volume gold_open date eur_usd;
	run;	
	
/*5. Affichage de 20 observations... */

	proc print data = gold2(obs=20);
		where gold_open > 120;
	run;
	
/*6. Ajout a la table gold2 la variable gold_market ... */
	data gold2;
		set gold2;
		gold_market = round(gold_volume * gold_open, 10);
	run;

/*7. Ajouter les deux observations suivantes,... */

	data obs;
		input gold_open sp500_open silver_open ;
		cards;
		121.5 115.4 18
		119.7 113.2 16.4
	;run;

	/* Ajout des nouvelles observations à la table existante */
		data gold;
		    set gold 
		        obs; 
		run;

/*8. Creation d'une variable binaire high_metal ...*/
	data gold;
	    set gold;
	    if (gold_open + silver_open) > 140 then high_metal = 1;
	    else high_metal = 0;
	run;

	/* Nombre d'observations dans ce cas */
	
	proc freq data=gold;
	    tables high_metal;
	    where high_metal = 1;
	run;
	
	/* On a 2541 observations */

/*9. Identification d'eventuelle presence de valeurs manquantes dans gold2 et suppression des lignes correspondentes */ 

	proc means data=gold2 n nmiss;
		var _numeric_; 
	run;
	
	/* Suppression des lignes correspondentes */
	
	data gold2_nettoyé;
	    set gold2;
	    if nmiss(of _all_) = 0; 
	run;
	
	/* Verification */
	
	proc means data=gold2_nettoyé n nmiss;
		var _numeric_; 
	run;

/*10. Affichage de l'histogramme de la variable gold_open avec 100 barres */

	proc sgplot data=gold2;
	    histogram gold_open / nbins=100;
	    title "Histogramme de la variable gold_open avec 100 barres";
	run;

/*11. Affichage de la moyenne, la déviation standard et les quartiles de la variable gold_open. */
	proc means data=gold2 mean std q1 median q3 ;
	    var gold_open;
	run;
	
/*12. Création de la variable gold_feeling comprenant quatre catégories pour la variable gold_open et 
regroupant au moins 20% des observations chacune et affichage du tableau confirmant votre répartition. */

	/* Étape 1 : Calcul des seuils pour les quatres catégories */
	proc univariate data=gold noprint;
	    var gold_open;
	    output out=percentiles pctlpts=20 40 76 92 pctlpre=categorie_; 
	run;
	
	/* Étape 2 : Création de la variable 'gold_feeling' */
	data gold;
	    set gold;
	
	    /* Import des seuils depuis la table des percentiles */
	    if _n_ = 1 then set percentiles;
	
	    /* Catégorisation selon les percentiles */
	    length gold_feeling $20;
	    if gold_open <= categorie_20 then gold_feeling = 'Faible';
	    else if gold_open <= categorie_40 then gold_feeling = 'Moyen';
	    else if dold_open <= categorie_76 then gold_feeling = 'Elevé';
	    else gold_feeling = 'Très élevé';
	run;

	/* Affichage du tableau confirmant la repartition */
	proc freq data=gold;
	    tables gold_feeling / nocum;
	run;
	
/*13. Affichage du tableau de contingence des variables gold_feeling et high_metal et Interprétation
deux cases du tableau. */
	proc freq data=gold;
		tables gold_feeling*high_metal / nocol norow nopercent;
	run;
	
	/* Interpretation de deux cases du tableau */
	
	/* - 2030 observations ont un  (gold_open + silver_open) > 140 et un gold feeling élevé
	   - 931 observations ont un (gold_open + silver_open) < 140 et un gold feeling faible          */ 

/*14. régression linéaire de la variable gold_open sur gold_volume, silver_open, sp500_open, silver_volume 
et sp500_volume. */

	proc reg data=gold;
	    model gold_open = gold_volume silver_open sp500_open silver_volume sp500_volume; 
	run;
	quit;	
	
/*15. Peut-on rejeter l’hypothèse que toutes les variables utilisées n’ont aucune influence sur gold_open ?
 Justifier. */

	/* La pvalue associéee à la statistique de Fisher est de 0.0001 < aux differents seuils utilisés (1%, 5 %, 10%)
	On en conclut que les coefficients sont donc globalement significatifs, On peut donc rejetet l'hypothese
	suivant laquelle les variables utilisées n'ont aucune influence sur gold_open */
	
/*16. Parmi les variables explicatives utilisées, lesquelles semblent non-significatives ? A quel
niveau ?
	
	silver_volume a une pvalue associée egale à 0.4514, aux seuils de (1%, 5% ou 10%), cette variables est non
	significatives                                                                                               */
	
/*17. Ajouter à la table gold2 les rendements journaliers pour l’or gold_return et l’argent silver_
return. */ 
		
	data gold2;
	    set gold2;
	    gold_return = gold_open / lag(gold_open); 
	    silver_return = silver_open / lag(silver_open);
	run;
	/* Verification */
	proc print data=gold2(obs=20);run;
	
/*18. Nuage de points de gold_return contre silver_return. */

	proc sgplot data=gold2;
	    scatter x=gold_open y=silver_open / markerattrs=(symbol=CircleFilled size=8 color=blue);
	    xaxis label="gold_open" grid;
	    yaxis label="silver_open" grid;
	    title "Nuage de points entre gold_open et silver_open";
	run;

	/* Signe du coefficient de silver_return dans la régression de gold_return:
	
	 Les points ont tendance à monter ensemble (on a une pente ascendante).Lorsque la valeur 
	de gold_open augmente, la valeur de silver_open a aussi tendance à augmenter.
	Dans la regression, on peut considerer que le coefficient de silver_return est positif   */
	
/*19. Régression de gold_return sur silver_return et gold_volume. */
	
	proc reg data=gold2;
		model gold_return = silver_return gold_volume;
	run;
	quit;
	
	/* Commentaire des resultats:
	 
	 Analyse des coefficients:
	 
	 - la pvalue associée à silver_return etant inferieur au seuil de 1%,  le coefficient estimé de silver_gold
	 est donc significatif. 
	 Ainsi une augmentation d'une unité de silver_return augmente gold_return de 0.41780 
	 
	 - le coefficient associé à gold_volume n'etant pas significatif aux differents seuils usuels, on peut ne pas 
	 l'interpreter puiqu'il n'est pas significatif toutes choses etant egale par ailleurs.
	 
	 - l'analyse de la probabilité de Fisher nous montre que le modele est globalement significatif au seuil de 
	 1%, 5% ou 10%.
	 
	 - le R carré ajusté de la regression est de 0.6405, cela signifie que la regression explique 64,05% des 
	 variations de gold_return                                                                             */
	
/*20. Regression de log gold_return sur log silver_return et gold_volume. */

	/* Calcul des logarithmes */
	data gold2_log;
	    set gold2;
	    log_gold_return = log(gold_return);
	    log_silver_return = log(silver_return);
	run;

	/* Régression */
	proc reg data=gold2_log;
	    model log_gold_return = log_silver_return gold_volume;
	run;
	quit;

	/* Interprétation du coefficient obtenu devant log(silver_return).
	
	- La pvalue associée à log(silver_return) est significatif au seuil de 1%.
	- interpretation : l'augmentation d'1% de log_silver_return induit une variation de log_gold return
	de 0.41720 % 

	 