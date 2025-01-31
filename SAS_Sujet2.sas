/* ************************************** CC2_TP6_Sujet_2 ********************************  *
                Réalisé par : 1- Brech Movil NGANGA
                              2- Diabou KA
 *****************************************************************************************  */

/* Question 1 : Importation de la table "immo_data.csv" */

	FILENAME REFFILE '/home/u63655637/sasuser.v94/Data_TP_6.csv';
	
	PROC IMPORT DATAFILE=REFFILE
		DBMS=CSV
		OUT=WORK.IMPORT;
		GETNAMES=YES;
	RUN;
	
	PROC CONTENTS DATA=WORK.IMPORT; RUN;
	
	/* Stockage de la table dans immo_data */
	data immo_data;set work.import;run;

/* Question2 : Verification de la presence de valeurs manquantes pour les variables quantitatives */

	proc means data=immo_data n nmiss;
			var _numeric_; 
	run;

/* Commentaire : Les variables quantitatives n'ont pas de valeurs manquantes */

/* Question 3 : Creation de la table "immo2023" qui ne contient uniquement les transactions de 2023 */

	data immo2023;
	  set immo_data;
	  if year(date) = 2023 then do;
	    output;
	  end;
	run;

/* Question 4: Modification  de la table immo2023 */

	data immo2023;
		set immo2023;
		keep house_type no_rooms purchase_price sqm_price year_build;
	run;
	
	/* Affichage de 10 observations */
	proc print data = immo2023(obs=10);run;
	
	/* La proc print indique qu'immo2023 a 5540 observations */

/* Question 5: Affichage du nuage de points */

	proc sql;
	  create table biens_apres_1950 as
	  select *,
	         purchase_price / sqm_price as sqm /* Calcul de la surface */
	  from immo2023
	  where year_build > 1950;
	quit;
	
	/*Nuage de points */
	proc sgplot data=biens_apres_1950;
	  scatter x=sqm y=purchase_price / colorresponse=year_build;
	  xaxis label="Surface";
	  yaxis label="Prix d'achat";
	  title "Nuage de points : Prix d'achat en fonction de la surface (Biens construits après 1950)";
	  keylegend / title="Année de construction";
	run;

	/* Observations :
	1- On observe une nette correlation positive  entre la surface et le prix d'achat avec une dispersion
	des points legerement importante
	2- Les points en rouge peuvent correspondrent aux constructions plus recentes et les points en bleu aux
	constructtions plus anciennes                                                                         */

/* Question 6: Affichage de l'heatmap... */

	/* Regroupement des données par intervalle pour mieux visualiser la densité */
	
	/* Transformation des variables en intervalles (purchase_price et no_rooms) */
	data immo2023_intervals;
	   set immo2023;
	   /* Regroupement des prix d'achat par intervalles */
	   if purchase_price <= 500000 then purchase_price_interval = '1:0-500k';
	   else if purchase_price <= 1000000 then purchase_price_interval = '2:500k-1M';
	   else if purchase_price <= 1500000 then purchase_price_interval = '3:1M-1.5M';
	   else purchase_price_interval = '4:1.5M+';
	   
	   /* Regroupement du nombre de pièces par intervalles */
	   if no_rooms = 1 then pieces_interval = '1';
	   else if no_rooms = 2 then pieces_interval = '2';
	   else if no_rooms = 3 then pieces_interval = '3';
	   else pieces_interval = '4+';
	run;

	/* Vérification des données après le regroupement */
	proc print data=immo2023_intervals(obs=10);
	run;
	
	/* table de comptage pour les nouvelles combinaisons prix_achat_interval et pieces_interval */
	proc freq data=immo2023_intervals noprint;
	   tables purchase_price_interval*pieces_interval / out=count_data;
	run;
	
	/* Vérification des résultats de la table de comptage */
	proc print data=count_data;
	run;
	
	/* heatmap avec les données regroupées */
	proc sgplot data=count_data;
	   heatmapparm x=pieces_interval y=purchase_price_interval colorresponse=count / 
	      colormodel=(lightblue lightgreen yellow orange red) 
	      nomissingcolor;
	   xaxis label="Nombre de Pièces (Intervalle)";
	   yaxis label="Prix d'Achat (Intervalle)";
	   title "Heatmap - Prix d'Achat vs Nombre de Pièces";
	run;

	/* Corrélation entre le prix et le nombre de pieces :
	On peut determiner le coefficient de correlation de Pearson                                    */
	proc corr data=immo2023_intervals pearson;
	   var purchase_price;
	   with no_rooms;
	run;
	
	/* Le cefficient de Pearson est de 0.2278, cela signifie que les deux variables sont positivement
	corrélées mais faiblement */

/* Question 7: Affichage de l'histogramme de la variable sqm */

	/* Reconstitution de la variable sqm */
	data immo2023;
	   set immo2023;
	   sqm = purchase_price / sqm_price; 
	run;
	
	/* Calcul des statistiques : Moyenne et Variance de sqm */
	proc means data=immo2023 mean var noprint;
	   var sqm;
	   output out=stats_summary(drop=_type_ _freq_) mean=mean_sqm var=var_sqm;
	run;
	
	/* Extraire les statistiques dans des macros pour les utiliser dans le graphique */
	data _null_;
	   set stats_summary;
	   /* Stockage des variables dans des macros */
	   call symputx('mean_sqm', mean_sqm); 
	   call symputx('var_sqm', var_sqm);   
	run;

	/* Histogramme avec des couleurs liées à l'année de construction */
	proc sgplot data=immo2023;
	   histogram sqm / group=year_build transparency=0.5 scale=count; 
	   keylegend / title="Année de Construction";
	   xaxis label="Superficie (sqm)";
	   yaxis label="Nombre de Propriétés";
	   
	   /* Ajout des lignes de référence pour la moyenne et la variance */
	   refline &mean_sqm / axis=x label="Moyenne" lineattrs=(color=red pattern=shortdash thickness=2);
	   refline &var_sqm / axis=y label="Variance (approximation visuelle)" lineattrs=(color=blue pattern=dash);
	   
	   title "Histogramme de sqm (coloration par année de construction)";
	run;

/* Question 8 : Création de la variable price */

	data immo2023;
	   set immo2023;
	   /* Création de la variable price */
	   if sqm_price > 18000 then price = "cher";
	   else price = "pas cher";
	run;

/*Question 9: Creation de 5 catégories pour la variable year_build representant chacune au moins 15% */

	/* Trie de la variable year_build*/
	proc sort data=immo2023; 
	   by year_build; 
	run;

	/* Quantiles de year_build */
	proc univariate data=immo2023 noprint;
	   var year_build;
	   output out=percentiles pctlpre=P_ pctlpts=20 40 60 80;
	run;
	
	/* Creation des catégories */
	data immo2023;
	   set immo2023;
	   if _n_ = 1 then set percentiles;
	   /* Assignation des catégories en fonction des limites */
	   if year_build <= P_20 then categorie = "Très ancien";
	   else if year_build <= P_40 then categorie = "Ancien";
	   else if year_build <= P_60 then categorie = "Moyen";
	   else if year_build <= P_80 then categorie = "Récent";
	   else categorie = "Très récent";
	run;
	
	/* Vérification des differentes categories */
	proc freq data=immo2023;
	   tables categorie;
	   title "Répartition des catégories d'année de construction";
	run;

/* Question 10: Affichage du tableau de contingence des variables prices et de ces categories */

	proc freq data=immo2023;
	   tables price * categorie / nocol norow nopercent;
	   title "Tableau de contingence entre Price et Catégories d'Année de Construction";
	run;

/* Question 11: */

	/* les variables explicatives considérées sont numériques à l'exception de house_type 
	qui est de type 'text', traitons la avant de faire la regression */
	
	/* transformation de la variable house_type */
	data immo2023;
	   set immo2023;
	   if house_type = "Apartment" then house_type_traité = 1;
	   else if house_type = "Farm" then house_type_traité = 2;
	   else if house_type = "Summerhouse" then house_type_traité = 3;
	   else if house_type = "Townhouse" then house_type_traité = 4;
	   else if house_type = "Villa" then house_type_traité = 5;
	run;

	proc contents data=immo2023;run;
	
	/* Transformation de la variable sqm en log sqm pour avoir l'effet d'une augmentation d'1 % */
	data immo2023;
	   set immo2023;
	   if sqm > 0 then log_sqm = log(sqm);  
	   else sqm = .; 
	run;
   
/* Question 12: regression et interpretation */

	proc reg data=immo2023;
	    model purchase_price = year_build log_sqm no_rooms house_type_traité; 
	run;
	quit;
	
	/* Interpretation : la p_value associée à log_sqm est de 0.0001 inferieur à 1%, ce qui signifie 
	que la variable log_sqm est significative 
	- une augmentation de sqm de 10% augmente le prix d'achat  de 206641.3                     */ 

/* Question 13 : Significativité de la variable year_build et Explication 

	- Oui la variable year_build impacte significativement la variable dependante car sa p_value
	associée est egale à 0.0064 inferieur à 1, 5 et 10% 
	Ainsi lorsque l'année de construction n'est pas trop ancienne, le prix d'achat augmente de 
	1364.86822	                                                                               */

/* Question 14: Regression avec des estimateurs robustes à l'héteroscedasticité */

	proc reg data=immo2023;
	   model purchase_price = year_build log_sqm no_rooms house_type_traité / 
	      hcc; 
	   title "Régression linéaire avec estimateurs robustes à l'hétéroscédasticité";
	run;
	
	/* Commentaire : la meme regression avec des estimateurs robustes à l'heteroscedasticité rend les estimations
	de "year_build" et "no_rooms" non statistiquement significatives. A contrario les variables "log_sqm" et 
	"house_type_traité" sont elles significatives. Globalement considérés, les coefficients restent significatifs
	 */

/* Question 15 : Regression logistique pour la probabilité vente à plus de 900000 euros */

	proc print data=immo2023(obs=5);run;
	
	/* Création de la variable binaire pour la probabilité de vente à plus de 900 000 euros */
	data immo2023;
	   set immo2023;
	   if purchase_price > 900000 then vente_au_dessus_900k = 1;
	   else vente_au_dessus_900k = 0;
	run;
	
	/* Prediction de la probabilité de vente à plus de 900 000 euros */
	proc logistic data=immo2023;
	   model vente_au_dessus_900k = year_build log_sqm no_rooms house_type_traité;
	   title "Régression Logistique pour la probabilité de vente à plus de 900 000 euros";
	run;

/* Question 16: evolution de la probabilité si sqm augmente de 30% */

	/* On va s'interesser a l'odd ratio associé à la variable log_sqm
	
	- Calcul de l'odds ratio pour log_sqm */
	
	/* Reprise des resultats pour obtenir les coefficients */
	proc logistic data=immo2023;
	   model vente_au_dessus_900k = year_build log_sqm no_rooms house_type_traité;
	   ods output ParameterEstimates=pe;
	run;
	/* Calcul de l'odd ratio */
	data odds_ratio;
	   set pe;
	   if variable = "log_sqm" then do;
	      odds_ratio = exp(estimate);  
	      change_sqm = log(1.30); /* Changement dans log_sqm pour une augmentation de 30% */
	      impact_on_odds = odds_ratio ** change_sqm; /* Calcul de l'impact sur les cotes */
	      prob_change = 1 / (1 + exp(-impact_on_odds)); /* Conversion des cotes en probabilité */
	   end;
	run;

	proc print data=odds_ratio; 
	   title "Impact de l'augmentation de 30% de sqm sur la probabilité";
	run;
	
	/*Commentaire : si sqm augmente de 30%, la probabilité évolue de 0.63545 */

/* Question 17: Affichage de la courbe ROC et Indice de pertinence */

	proc logistic data=immo2023;
		model vente_au_dessus_900k = year_build log_sqm no_rooms house_type_traité;
		ods output FitStatistics=stat_d_ajustements;
		roc;
		title "Courbe ROC pour la probabilité de vente à plus de 900 000 euros";
	run;
	
	/* Indice de pertinence du modele */
	proc print data=stat_d_ajustements;
	   title "Indices de Pertinence du Modèle";
	run;
	
	/* On peut considerer la log de vraisemblance(M2LOGL), sa statitisqique est suffisament grande, le 
	modele s'ajuste bien aux données */

/* Question 18:  Matrice de confusion */

	/* Ajustement du modèle de régression logistique et prédictions */
	proc logistic data=immo2023;
	   model vente_au_dessus_900k (event='1') = year_build log_sqm house_type_traité; 
	   output out=predictions p=pred_prob; /* Générer les probabilités prédites */
	run;
	
	/* matrice de confusion */
	data confusion_matrix;
	   set predictions;
	   /* classe prédite en utilisant un seuil de 0.5 */
	   if pred_prob >= 0.5 then predicted = 1; /* Classe prédite positive */
	   else predicted = 0; /* Classe prédite négative */
	
	   /* Comparaison avec la classe réelle */
	   vp = (vente_au_dessus_900k = 1 and predicted = 1); /* Vrai Positif */
	   fp = (vente_au_dessus_900k = 0 and predicted = 1); /* Faux Positif */
	   fn = (vente_au_dessus_900k = 1 and predicted = 0); /* Faux Négatif */
	   vn = (vente_au_dessus_900k = 0 and predicted = 0); /* Vrai Négatif */
	run;
	
	/* Agrégation des résultats dans une matrice */
	proc sql;
	   create table matrix_2x2 as
	   select
	      sum(vp) as Vrai_Positif,
	      sum(fp) as Faux_Positif,
	      sum(fn) as Faux_Négatif,
	      sum(vn) as Vrai_Négatif
	   from confusion_matrix;
	quit;
	
	/* Transformation des résultats en un tableau 2x2 */
	data display_matrix;
	   set matrix_2x2;
	   length Real $20 Predicted $20 Count 8;
	
	   /* Ligne pour les Réels Positifs */
	   Predicted = "Prédit Positif"; Real = "Réel Positif"; Count = Vrai_Positif; output;
	   Predicted = "Prédit Négatif"; Real = "Réel Positif"; Count = Faux_Négatif; output;
	
	   /* Ligne pour les Réels Négatifs */
	   Predicted = "Prédit Positif"; Real = "Réel Négatif"; Count = Faux_Positif; output;
	   Predicted = "Prédit Négatif"; Real = "Réel Négatif"; Count = Vrai_Négatif; output;
	run;
	
	/* Affichage de la matrice de confusion */
	proc print data=display_matrix noobs;
	   var Real Predicted Count;
	   title "Matrice de Confusion 2x2";
	run;

/* Question 19: Calcul de la Sensibilité et la spécificité du modele */

	data Sensibilite_Specificite;
	   set matrix_2x2;
	   Sensibilite = Vrai_Positif / (Vrai_Positif + Faux_Négatif);
	   Specificite = Vrai_Négatif / (Vrai_Négatif + Faux_Positif);
	
	   if (Vrai_Positif + Faux_Négatif) = 0 then Sensibilite = .;
	   if (Vrai_Négatif + Faux_Positif) = 0 then Specificite = .;
	run;
	
	/* Affichage de la sensibilite et specificite */
	proc print data=Sensibilite_Specificite noobs;
	   var Sensibilite Specificite;
	   title "Sensibilité et Spécificité du Modèle";
	run;

/* Question 20 : Creation de l'heatmap en utilisant les probabilités predites */

	/* Préparration des données */
	data heatmap_data;
	   set predictions;
	   year_build_group = floor(year_build / 10) * 10; 
	   log_sqm_group = round(log_sqm, 0.1);           
	run;
	
	/* Moyenne des probabilités pour chaque groupe */
	proc sql;
	   create table heatmap_avg as
	   select 
	      year_build_group,
	      log_sqm_group,
	      mean(pred_prob) as avg_pred_prob
	   from heatmap_data
	   group by year_build_group, log_sqm_group;
	quit;
	
	/* Representation de la heatmap */
	proc sgplot data=heatmap_avg;
	   heatmapparm x=log_sqm_group y=year_build_group colorresponse=avg_pred_prob /
	      colormodel=(lightblue yellow orange red); /* Dégradé de couleurs */
	   xaxis label="Log(Superficie)";
	   yaxis label="Année de Construction (par Décennie)";
	   title "Heatmap des Probabilités Prédites";
	run;
