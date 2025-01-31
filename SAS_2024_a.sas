
/* ************************************ TD1 : Découverte de SAS ******************************************** */


/*2. Inserer le  code suivant:*/

DATA work.test;
	INPUT X1 x2 X3 x4 X5$;
	CARDS;
27 4 2 1391 ALMERIC
31 9 3 1326 BRUNOIDE
82 1 5 1499 CELTIMBANQUE
;RUN;

DATA work.test;
	INPUT X1 x2 X3 x4 nom $;
	CARDS;
27 4 2 1391 ALMERIC
31 9 3 1326 BRUNOIDE
82 1 5 1499 CELTIMBANQUE
;RUN;

/* CARDS  a un equivalent qui est DATALINES*/

/*3. ajout d'un commentaire*/ 

/* Ma table SAS */

DATA work.test;
INPUT X1 x2 X3 x4 nom $;
CARDS;
27 4 2 1391 ALMERIC
31 9 3 1326 BRUNOIDE
82 1 5 1499 CELTIMBANQUE
;RUN;

/*4. Durée d'execution du script
* dans le journal, le temps d'execution dus script est de 0.000*/

/*5 ouverture de la table des donnees*/

PROC PRINT DATA=test;
RUN;

/* Applications:*/
/*Exercice1:*/

/*1. Nombre de champs de la table : 5 */

/*2 Nombre d'observations :  4 */

/*3. VARIABLES QUALITATIVES*/

/*X2 et X5 sont des variables qualitatives*/

/*4 REDACTION ET EXECUTION DE CETTE TABLE*/

DATA work.tableSAS;
INPUT X1 X2$ X3 X4 X5$;
DATALINES;
1 a 2 3 b
4 cd 5 6 e
7 f 8 9 g
10 hi 11 12 jk
;RUN;

*5. Ajout entre INPUT ET CARDS de l'instruction surprise=PUT(1 ,1.);

DATA work.tableSAS;
INPUT X1 X2$ X3 X4 X5$;
surprise=PUT(1 ,1.);  * permet de creer une nouvelle variable surprise
DATALINES;
1 a 2 3 b
4 cd 5 6 e
7 f 8 9 g
10 hi 11 12 jk
;RUN;

/* la variable crée est quantitative*/

/*6. Observer les proprietes de la table et repondre à nouvaeu à la question precedente*/

/***********************************************************************************************/

/*Exercice 2
* 1. Executer le script */ 

data test;
input x1 x2 x3;
cards;
1 2 3 4 5 
6 7 8 9 10
11 12 13 14 15
16 17 18 19 20
21 22 23 24 25
;RUN;

/* que constatez-vous ? quelle regle generale peut on en deduire?

* On constate que lorsque le nombre de variable definit est inferieur au nombre de colonnes de la partie CARDS,
* le remplissage de la table se fait par colonne.
* Regle a definir, le remplissage la table se fait par colonne en fonction du nbre de variables qui ont été definies

/*2. Script suivant:*/

DATA test1 ;
INPUT x1 x2 X3 x4 x5;
CARDS;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
;RUN;

/* Nmbre d'observation attendue : 15
* la sortie presente un tableau avec 3 obervations, le remplissage de la table se fait par ligne a la difference 
* du precedent tabeau

/*3. Execution du script suivant :*/

DATA test;
INPUT x1 x2 X3;
CARDS;
1 2
3 4
5 6
7 8
;RUN;

/* On constate que lorsque le nombre de variable definit est superieur au nombre de colonnes de la partie CARDS,
le remplissage de la table se fait par ligne.
" NB: NOTE: SAS went to a new line when INPUT statement reached past the end of a line. "
Traduction: SAS accédait à une nouvelle ligne lorsque l'instruction INPUT dépassait la fin d'une ligne.

Teste du script suivant : */

DATA test;
INFILE CARDS MISSOVER; /* prends en compte toutes les valeurs manquantes */
input x1 x2 x3 x4 X5;
CARDS ;
1 2 3 . 5
6 7 8 9 10
11 12 . 14
16 17 18 19 .
. 22 23 24 25
;RUN; 

/* On constate :*/  

3. /* quelques premieres procedures */

/* 1. Execution de la procedure CONTENTS sur le fichier de données AIRLINE qui se trouve dans la bibliotheque
SASHELP */

PROC CONTENTS DATA=SASHELP.AIRLINE;
;Run;

/*2. Affichage du contenu de la table SASHELP.BASEBALL et nombre d'observatiions et de variables */

 PROC PRINT DATA= SASHELP.BASEBALL;
 ;RUN;


proc contents data=SASHELP.baseball;
run;

/* 322 observations et 24 variables */

/*3.Dans une table contenant les variables x1 et x2, l'utilisation de l'argument VAR permet de n'afficher que
certains variables. */

PROC PRINT DATA= SASHELP.BASEBALL;
VAR TEAM;
RUN;

/*4  Execution du script suivant */
PROC PRINT DATA= SASHELP.BASEBALL(OBS=15);
VAR TEAM;
RUN;


/*5. Code pour afficher 20 observations et les variables Name, nHits,... */

PROC PRINT DATA= SASHELP.BASEBALL (obs=20);
VAR Name nHits nAtBat Position;/* VAR allows to select the variables to print*/
RUN;

/*6. Introduction à la condition Where pour filtrer */

PROC PRINT DATA = SASHELP.BASEBALL;
VAR TEAM;
WHERE position = "C";/* WHERE allows to select the observation to print*/
RUN;

/* Pour afficher la position pour controler que le filtre a bien été exécuté : on peut modifier 
légèrement le code en incluant la variable position dans la liste des variables affichées avec l'instruction VAR*/

proc print data = SASHELP.BASEBALL;
var team position;
where position = "C";
run;

/*7. Affichage de la table sashelp.birthwgt */
 
PROC PRINT data=SASHELP.BIRTHWGT(OBS=1500);
;RUN;

/*8. Dans cette table, afficher tous les cas de fumeurs ayant eu un enfant au poids faible */
PROC PRINT DATA = SASHELP.BIRTHWGT;
var LowBirthWgt Smoking;
Where LowBirthWgt = "Yes" and Smoking ="Yes";
Run;

/*9. Affichage d'une table contenant uniquement les variables LowBirthWgt, Drinking et Death */

proc print data = SASHELP.BIRTHWGT (OBS = 1500);
VAR LowBirthWgt Drinking Death;
RUN;

/*10. Meme question en ne conservant que les observations ayant un groupe d'age égal à 3 */
proc print data = SASHELP.BIRTHWGT;
VAR LowBirthWgt Drinking Death Agegroup;
where Agegroup = 3; 
RUN;

/*11. Affichage de la table contenant uniquement les observations des groupes d'age 2 et 3 et sont mariés.
On affichera seulement ces informations, la variable smoking et LowBirthWgt */

proc print data=sashelp.birthwgt;
    var smoking LowBirthWgt;
    where Agegroup in (2, 3) and Married = "Yes";
run;

/* pour le verifier */
proc print data=sashelp.birthwgt;
    var smoking LowBirthWgt Agegroup Married;
    where Agegroup in (2, 3) and Married = "Yes";
run;


/* ************************* TD 2 : Manipulation de données de données ************************************** */
                                     
/*I. 1 Creation de table */
DATA work.donnees;
    INPUT Nom $ Age Taille Poids;
    DATALINES;
GTA3 21 1.70 55
GTA4 31 2.70 65
GTA5 41 3.70 75
GTA6 51 4.70 85
GTA7 61 5.70 95
;
RUN;


/*2. Ajouter une observation avec les variables Nom et Taille manquantes. */
DATA work.donnees;
    INPUT Nom $ Age Taille Poids;
    DATALINES;
GTA3 21 1.70 55
GTA4 31 2.70 65
GTA5 41 3.70 75
GTA6 51 4.70 85
GTA7 61 5.70 95
. 36 . 80  
;
RUN;

/*3. Ajouter une variable sexe (quel format ?) pour indiquer le genre des indiv (M ou F)*/

DATA donnees0;
    SET donnees;
    LENGTH Sexe $1; /* Définit le format de la variable Sexe comme caractère d'une longueur de 1 */
    if _N_ = 1 then Sexe = "M";
    else if _N_ = 2 then Sexe = "F";
    else if _N_ = 3 then Sexe = "M";
    else if _N_ = 4 then Sexe = "F";
    else if _N_ = 5 then Sexe = "M";
    else if _N_ = 6 then Sexe = "F";
RUN;
/* Creation d'une variable au carré */
DATA donnees0bis;
	set donnees0;
	Age_au_Carré = Age**2;
RUN;

/*4. Ajout d'une nouvelle variable IMC */

DATA donnees1;
	SET donnees0;
	IMC = Poids / Taille**2;
RUN;

/* Vérification des résultats */
PROC PRINT DATA=donnees1;
    VAR Nom Age Taille Poids Sexe IMC;
RUN;

/*5. Ajout d'une variable Cat_IMC pour categoriser les IMC en Sous_poids, Poids normal, Surpoids et Obésité */

DATA donnees2;
	set donnees1;
	if IMC < 18.5 then Cat_IMC = 'Sous-poids';
	else if IMC >= 18.5 and IMC < 25 then Cat_IMC = 'Poids normal';
	else if IMC >=25 and IMC < 30 then Cat_IMC = 'Surpoids';
	else CAT_IMC = 'Obésité';
run;
	 
/*6. Supprimez les individus dont l'age est inferieur à 32 de la table donnees*/
DATA donnees3;
	SET donnees2;
	if Age < 32 then delete ; 
RUN;

/*7. Supprimez les individus ayant un IMC inferieur à 18.5 de la meme table */
DATA donnees3bis;
	set donnees2;
	if IMC < 18.5 then delete;
run;

/*8. Imprimer un rapport qui contient uniquement les informations des individus dont l'IMC est > à 25 */
proc print data=donnees2;
    where IMC > 5;
run;

/*9. Imprimer un rapport avec les noms et les tailles des individus dont l'age est compris entre 20 et 30 */
proc print data=donnees2;
	var Nom Taille;
	where Age >20 and Age < 30;
run;

/*2. Manipulation de dates */

/*1. Creation d'une nouvelle table nommée "dates" avec une variable "Date_naissance" au format DATE9.. representant
la date de naissance et une variable numerique "durée" allant de 10 à 20. La table contiendra 5 observations */

DATA dates;
	input Date_naissance :date9. durée;
	format Date_naissance DATE9.;
	CARDS;
01JAN2001 10
02FEB2002 12
03MAR2003 14
04APR2004 16
05MAY2005 18
;RUN;

/*2. Ajouter une variable "Date_inscription" au format DATE9. représentant la date d'inscription à un programme */

DATA dates;
	input Date_naissance :date9. durée Date_inscription :date9.;
	format Date_naissance date9. Date_inscription date9.;
	CARDS;
01JAN2001 10 10JAN2001
02FEB2002 12 16FEB2002
03MAR2003 14 20MAR2003
04APR2004 16 18APR2004
05MAY2005 18 27MAY2005
;RUN;

/*3. Creation d'une variable Date_sortie égale à la date d'inscription plus la durée */
data dates;
    input Date_naissance :date9. Durée Date_inscription :date9.; /* Ajout des variables */
    format Date_naissance Date_inscription Date_sortie date9.;  /* Application des formats */
    Date_sortie = Date_inscription + Durée;                     /* Calcul de la Date_sortie */
    datalines;
01JAN2001 10 15FEB2020
02FEB2002 12 20MAR2021
03MAR2003 14 10APR2022
04APR2004 16 05MAY2023
05MAY2005 18 01JUN2024
    ;
run;

/* Affichage des résultats */
proc print data=dates noobs;
    title "Table Dates avec Date_naissance, Durée, Date_inscription, et Date_sortie";
run;

/*3 Importation d'une table de sashelp et manipulations */

/*1. Importez la table sashelp.iris et stockez-la dans une nouvelle table nommée "fleurs" */

/* Importation de la table */
PROC print data=sashelp.iris;

/* Stockage de la table dans une nouvelle table nommée "fleurs"*/
data fleurs;
	set sashelp.iris;
run;
/* Affichage */
proc print data=fleurs;
run;

/*2. Imprimer les observations ou la variable "SepalLength" est superieur à 5. */
proc print data=fleurs;
	where SepalLength > 55;
run;

/*3. Imprimer les noms et les longueurs des  pétales "PetalLength" des fleurs de l'espece "setosa" */

proc print data=fleurs;
	var Species PetalLength;
	where Species = "Setosa";
run;
 
/* ****************************** TP3 : Tableux et premieres regressions************************************ */

/* Récupération du jeu de données sur un lien et eregistrement en local */
/*
proc import datafile="C:\Users\brech\Downloads\pisa2009test.csv"
    out=work.pisa2009test
    dbms=csv
    replace;
    getnames=yes;
run; */

/*1.*/

/*2*/

FILENAME REFFILE '/home/u63655637/sasuser.v94/pisa2009test.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

/*3. Creation de la table work.pisa a partir du fichier csv */
data work.pisa;
	set work.import;
run;
/* Affichage */
proc print data=pisa;
run; 

/*4. Affichage du nom des colonnes de la table */
proc contents data=pisa out=columns(keep=name);
run;

proc print data=columns;
    title "Liste des colonnes du jeu de données";
run;

/*5. On s'interesse uniquement aux variables uniquement listées..., Supprimons les 
colonnes qui ne font pas partie de cette liste */

data pisa0;
	set pisa;
	keep grade male preschool publicschool read30MinsADay readingScore englishAtHome expectBachelors;
run;	
/* Affichage */
proc print data=pisa0(obs=10);
    title "Aperçu des 10 premières observations des données filtrées";
run;

proc print data=pisa0;
run;

/*6. Utiliser la procedure content pour verifier que la table correspond bien aux attentes */
proc contents data=pisa0;
run;

/*7.  Identifier l'eventuelle présence de valeurs manquantes dans les données pour les variables ... */

	/* Vérifie les valeurs manquantes pour les variables numériques */
	proc means data=pisa0 n nmiss;
	    var _numeric_; 
	run;
	
	/* Vérifie les valeurs manquantes pour les variables de type caractère */
	proc freq data=pisa0;
	    tables _character_ / missing; 
	run;
	
	/*. Suppression des valeurs manquantes pour les colonnes englishAtHome et expectBachelors */
	
	data pisa1;
	    set pisa0;
	    if  missing(englishAtHome) or missing(expectBachelors) then delete;; 
	run;
	
	/* Verification */
	proc means data=pisa1 n nmiss;
	    title "Présence de valeurs numeric manquantes";
	run;
	
	/* 0 missing values sur expectBachelors, NA n'est pas un encodage de valeurs manquantes */

/*8 remplacer toutes les valeurs manquantes de la variable readingScore par la moyennes des variables presentes */
	/* readingScore a 0 valeurs manquantes 
	
	
/*8 remplacer toutes les valeurs manquantes de la variable englishAthome par la moyenne des valeurs presentes */
 
/* Étape 1 : Calcul de la moyenne des valeurs non manquantes pour la variable englishAtHome */
proc means data=pisa0 noprint;
    var englishAtHome;
    output out=moyennes(drop=_type_ _freq_) mean=moyEnglish;
run;

/* Étape 2 : Remplacement des valeurs manquantes par la moyenne */
data pisa00;
    set pisa0;
    if _n_ = 1 then set moyennes; /* Intègre la moyenne dans chaque observation */
    if missing(englishAtHome) then do;
        englishAtHome = moyEnglish; /* Remplace les valeurs manquantes par la moyenne calculée */
    end;
run;

/*9. Création d'une variable 'levelGroup' basée sur la variable 'grade'. Attribuez la valeur Low si la note est 8-9,
Mid si la note est 10-11 et high si la note est au dessus de 11. */

data pisa01;
    set pisa00; /* Remplacez par le nom de votre jeu de données si différent */
    if grade in (8, 9) then levelGroup = 'Low';
    else if grade in (10, 11) then levelGroup = 'Mid';
    else if grade > 11 then levelGroup = 'High';
    else levelGroup = 'Undefined'; /* Pour gérer les cas où grade n'est pas valide */
run;
/* Affichage */
proc print data=pisa01(obs=40);
    title "Aperçu des 40 premières observations avec la variable LevelGroup";
run;

/*10. Renommez la variable 'male' en gender */
data pisa02;
	set pisa01;
	rename male=gender;
run;

/*11. Creation d'une variable Mean égale à la moyenne de la note et du score de lecture divisé par 6, remise
des notes à l'echelle. */

/* Étape 1 : Trouver les valeurs maximales des variables */
proc means data=pisa02 noprint;
    var grade readingScore;
    output out=ValMaxi(drop=_type_ _freq_) max=max_grade max_readingScore;
run;

/* Étape 2 : Remise des variables à l'echelle et calculer la moyenne */
data pisa03;
    set pisa02;
    if _n_ = 1 then set ValMaxi; /* Inclut les maximas dans chaque observation */

    /* Mise à l'échelle des variables */
    grade_scaled = grade / max_grade * 20;
    readingScore_scaled = readingScore / max_readingScore * 20;

    /* Calcul de la moyenne des variables mises à l'échelle */
    Mean = mean(grade_scaled, readingScore_scaled);
run;

/* Étape 3 : Affichage des résultats */
proc print data=pisa03;
   var grade readingScore grade_scaled readingScore_scaled Mean;
run;

/*12. Créer une variable 'highScoreReader' egale à 1 si 'read30MinsADay' vaut 1 et si le 'readingScore'
depasse 500, et à 0 sinon */

data pisa04;
	set pisa03;
	if read30MinsADay = 1 and readingScore > 500 then highScoreReader = 1;
	else highScoreReader = 0;
run;

/*13. Afficher les dix premieres observations correspondant à des éléves d'école publique lisant au moins 
trente minutes par jour */

proc print data=pisa04(obs=10);
	where read30MinsADay = 1;
run;

/*14. Afficher une table contenant la note moyenne pour les observations telles que 'expectBachelors' vaut 1.
On affichera également le nombre d'observations concernées */

/* Calculer la note moyenne pour les observations où 'expectBachelors' vaut 1, 
   ainsi que le nombre d'observations concernées */
proc means data=pisa04 noprint;
    where expectBachelors = "1"; /* On met "" car expectBachelors est categoriel */
    var grade;                 
    output out=resultats (drop=_type_ _freq_) mean=NoteMoyenne n=NbreObservation;
run;

/* Afficher les résultats */
proc print data=resultats noobs;
    var NoteMoyenne NbreObservation; /* Affiche uniquement les colonnes nécessaires */
run;

/*15. Afficher la moyenne et la déviation standard de la variable 'grade' */
proc means data=pisa04 mean std; 
    var grade;  
run;

/*16. Affichez les quartiles de la variable 'readingScore' */
proc univariate data=pisa04;
    var grade;  
    output out=quartiles pctlpre=P_ pctlpts=25 50 75;  /* Calcule les quartiles : 25e, 50e, et 75e percentiles */
run;

/*17. Creation d'un tableau de frequence pour la variable 'expectBachelors' */

proc freq data=pisa04;
	tables expectBachelors;
run;

/*18. Meme question pour la variale "grade" */

proc freq data=pisa04;
	tables grade;
run;

/*19. Creation d'un tableau de contingence pour les variables englishAtHome et grade */

proc freq data=pisa04;
    tables englishAtHome*grade / norow nocol nopercent;  /* Spécifie les deux variables pour le tableau croisé, 
    norow nocol nopercent pour ne pas presenter les pourcentages*/
run;

/*20. Tableau de contingence pour les variables read30MinsADay et grade */
proc freq data=pisa04;
	tables read30MinsADay*grade / nocol norow nopercent;
run;

/*21. Utiliser la procedure univariate pour afficher un histogramme de la distribution de la variable 'mean'
ainsi que pour obtenir les valeurs des quartiles et de la médiane */

proc univariate data=pisa04;
    var Mean;
    histogram Mean / normal; /* Ajout de l'option "normal" pour superposer une courbe normale */
    output out=summary_stats pctlpts=25 50 75 pctlpre=Q; /* Génération des quartiles et de la médiane */
    title "Analyse de la distribution de la variable Mean";
run;

/* *************************************************************************************************** */

/********************. Application : Base de données pisa *********************************/

/* Vérification des valeurs manquantes */

/* pour les variables numériques */
proc means data=pisa n nmiss;
	var _numeric_; 
run;
/* pour les variables categorielles */
proc freq data=pisa;
	tables preschool / missing;
run;

/* Traitement de la variable preschool */

/* 1er traitement : traitement de valeurs manquantes (NA) */

	/* Le % d'observation ayant pour modalité NA est de 1.34, ce pourcentage étant faible, leur suppression 
	ne risque pas de biaiser le resultat */
	
	/* 1ere possibilité: suppression */  
	
	data pisaA;
	    set pisa;
	    if preschool="NA" then delete;
	run;
	
	/*verification */
	proc freq data=pisaA;
		tables preschool / missing;
	run;
	/* 
	
	/* 2eme possibilité : imputation par la proportion ou tirage aléatoire
	
	Si vous ne voulez pas biaiser les données vers une modalité particulière, vous pouvez imputer les valeurs
	manquantes en respectant la distribution initiale (probabilité basée sur les fréquences) : */
	
	/* data pisa05;
	    set pisa04;
	    if preschool = 'NA' then do; 
	        if ranuni(12345) < 0.7 then preschool = 1; /* Remplacer par 1 avec une probabilité de 70% */
	/*        else preschool = 0; /* Remplacer par 0 avec une probabilité de 30% */
	/*    end;
	run; */

/*. 2eme traitement : conversion de la variable en variable numerique */

data pisaA;
    set pisaA;
    if preschool = "1" then preschool_num = 1;
    else if preschool = "0" then preschool_num = 0;
run;

/* regression de readingScore sur preschool, schoolSize et grade */
proc reg data=pisaA;
    model readingScore = preschool_num schoolSize grade; 
run;
quit;

/*1. Peut-on rejeter l'hypothese qu'aucun de ces facteurs n'explique le readingScore */
/* On s'interesse au test de Fisher pour la significativité des facteurs, la sortie de la regression 
nous donne une proba de Fisher = 0.0001 < 1 % ou 5%, on peut rejeter l'hypothese nulle et conclure
que au moins un facteur a un effet significatif sur readingScore */

/*2. Significativité de la variable schoolSize et conclusion */

/* En observant la probabilité liée au test de student , On constate que la variable schoolSize n'a 
pas un effet significatif significatif sur readingScore, on peut envisager de la retirer */

/*3. Pour les variables preschool et grade */
/* Les deux variables ont un effet significatifs sur le score de lecture. Lorsque grade (ou preschool) augmente
d'une unité, readingScore augmente de 41.67 (de 20.85)

/*4. Formulation d'un autre modele lineaire et regression correspondante, commentaire des resultats */


/* *************************************** TP 4 ************************************************************ */

/*1. Affichage un rapport sur la table "sashelp.demographics". combien d'observations la table contient-elle?
combien de variables? Quel est le type de la variable "AdolescentFPpct"? */

proc contents data=sashelp.DEMOGRAPHICS;
run;

/* La table contient 197 observations, 18 variables. et la variable "AdolescentFPpct" est de type numerique */

/*2. affichage des pays possedant un taux de fertilite total inferieur à 1.8 tout en ayant un % de fertilité
adolescente superieure à 12% */

proc print data=sashelp.demographics;
run;

proc print data=sashelp.demographics;
	where totalFR > 1.8 and AdolescentFPpct > 0.12;
run;
 
/*3. Creation d'une table work.test contenant les memes informations que sashelp.demographics */

data work.test;
	set sashelp.demographics;
run;

proc print data=test;
run;

/*4. Ajouter à cette table une variable 'prep_pop' contenant une prediction pour la population
 du pays en 2007, calculée à partir  de la population de 'sashelp.demographics'(qui correspond
à l'année 2004) et du taux de croissance présent dans cette meme table . */

data work.test;
    set work.test;
    /* Calcul de la population prédite */
    prev_pop = pop * (1 + popAGR)**(2007 - 2004);
run;

/*5. Ajout des deux observations, seules trois variables son disponibles: name, popagr et totalfr */

data work.test0;
input name $ popagr totalfr;
cards;
ImaginLand 0.03 2.3
MagicLand 0.6 0.2
;run;

/* Ajout des nouvelles observations à la table existante */
data work.test1;
    set work.test /* Table existante */
        work.test0; /* Nouvelle table à fusionner */
run;

/* Verification */
proc print data=work.test1 noobs; /* noobs Supprime l'affichage des numéros d'observation */
run;

/*6. Creation d'une variable Priorite */
	
data work.test2;
    set work.test1; 

    if AdolescentFPpct > 0.11 and (totalfr < 1.1 or totalfr > 3.4) then 
        Priorite = 'extreme';
    else if AdolescentFPpct > 0.11 or (totalfr < 1.1 or totalfr > 3.4) then 
        Priorite = 'very high';
    else if AdolescentFPpct > 0.6 or (totalfr < 1.8 or totalfr > 2.6) then 
        Priorite = 'high';
    else 
        Priorite = 'Low';
run;

/*7. Creation d'une table test3 contenant uniquement les observations tellesq ue totalFR<2 */

data test3;
	set test2;
	
	where totalFR < 2;
run;

/*8. Impression du rapport test3 */

proc contents data=test3;
run;

/*9 Creation d'une table test à partir de sashelp ne contenant uniquement certaines variables */

data test4;
	set sashelp.demographics;
	keep Name Maleschoolpct Femaleschoolpct totalfr adolescentfppct adultliteracypct gni poppovertypct pop popagr
	popurban region totalfr;
run;

proc print data=test4;
run;
/*10. Nombre d'observations ayant une valeur manquante pour la variable 'AdultLiteracypct' */
proc means data=test4 n nmiss;
	var AdultLiteracypct;
run;

/* 63 observations sont manquantes pour la variable AdultLiteracypct */

/*11. histogramme de la distribution de la variable AdultLiteracypct ainsi que les valeurs des quartiles et des medaianes */

proc univariate data=test4;
    var AdultLiteracypct;
    histogram AdultLiteracypct / normal; /* Ajout de l'option "normal" pour superposer une courbe normale */
    output out=summary_stats pctlpts=25 50 75 pctlpre=Q; /* Génération des quartiles et de la médiane */
    title "Analyse de la distribution de la variable AdultLiteracypct";
run;

/*12. Afficher la moyenne et la deviation standard des variables poppovertypct et femaleschoolct */
proc means data=test4 mean std; 
    var poppovertypct femaleschoolpct;  
run;

/*13. Creation d'une variable 'cat_lit' comprenant 5 categories pour la variable 'adultliteracypct' regroupant
au moins 9% des observations chacune */

/* Étape 1 : Calcul des seuils pour les catégories */
proc univariate data=test4 noprint;
    var adultliteracypct;
    output out=percentiles pctlpts=9 18 36 63 91 pctlpre=cat_; /* Les percentiles sont choisis pour 
    garantir qu'au moins 9% des observations tombent dans chaque catégorie : 9%, 18%, 36%, 63%, et 91%. */
run;

/* Étape 2 : Création de la variable 'cat_lit' */
data test5;
    set test4;

    /* Import des seuils depuis la table des percentiles */
    if _n_ = 1 then set percentiles;

    /* Catégorisation selon les percentiles */
    length cat_lit $20;
    if adultliteracypct <= cat_9 then cat_lit = 'Très faible';
    else if adultliteracypct <= cat_18 then cat_lit = 'Faible';
    else if adultliteracypct <= cat_36 then cat_lit = 'Moyen';
    else if adultliteracypct <= cat_63 then cat_lit = 'Élevé';
    else cat_lit = 'Très élevé';
run;

/* Étape 3 : Vérification des catégories */
proc freq data=test5;
    tables cat_lit / nocum;
run;

/*14.  De meme creer une variable 'cat_fschool' pour la variable 'femaleschoolpct' comprenant cinq categories
, regroupant au moins 9% des observations chacune */

proc univariate data=test5 noprint;
    var femaleschoolpct;
    output out=percentiles pctlpts=9 18 36 63 91 pctlpre=cat0_; /* Les percentiles sont choisis pour 
    garantir qu'au moins 9% des observations tombent dans chaque catégorie : 9%, 18%, 36%, 63%, et 91%. */
run;

/* Étape 2 : Création de la variable 'cat_lit' */
data test6;
    set test5;

    /* Import des seuils depuis la table des percentiles */
    if _n_ = 1 then set percentiles;

    /* Catégorisation selon les percentiles */
    length cat_fschool $20;
    if femaleschoolpct <= cat0_9 then cat_fschool = 'Très faible';
    else if femaleschoolpct <= cat0_18 then cat_fschool = 'Faible';
    else if femaleschoolpct <= cat0_36 then cat_fschool = 'Moyen';
    else if femaleschoolpct <= cat0_63 then cat_fschool = 'Élevé';
    else cat_fschool = 'Très élevé';
run;

/*15. Affichage un tableau de contingence des deux categories crées cat_lit et cat_fschool */
proc freq data=test6;
	tables cat_lit*cat_fschool / nocol norow nopercent;
run;

/*16. Effectuez la regression lineaire de 'adolescentfppct' sur 'maleschoolpct', 'femaleschoolpct', 'gni',
'adultliteracypct' et 'popurban' */

proc reg data=test6;
    model adolescentfppct = maleschoolpct femaleschoolpct gni adultliteracypct popurban; 
run;
quit;

/*17. Peut on rejeter l'hypothese que toutes les variables utilisées n'ont aucune influence sur adolescentfppct */
/* Non car une des variables a un effet significatif sur adolescentfppct */

/*18. Parmi les variables explicatives utilisées, lesquels sont significatives? A quel niveau */
/* GNI est la seule variable significative au seuil de 1, 5 et 10% */

/*19. Utiliser les données disponibles dans la table pour formuler un modele lineaire expliquant la variable
'maleschoolpct' et effectuer la régression */
proc print data=test6;
run;

proc reg data=test6;
 model maleschoolpct = AdultLiteracypct gni popAGR;
 run;
 quit;
 
 /*20. Commentaire des nouveaux resultats. En particulier de combien le % de garcons scolarisés en primaire
 augmente lorsque le % d'adultes aphabétisés augmente de 1. La valeur est-elle significative */

/* Lorsque AdultLiteracypct augmente de 1, maleschoolpct augmente de 0.43825% . la proba du t de student etant 
< à 1, 5 et 10% , la valeur est significative */



/* ****************************************  TP5 ***************************************************** */

/*1. Imoporter la table bank.csv */

FILENAME REFFILE '/home/u63655637/sasuser.v94/bank.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;

/* Nre d'observation
11162 observations  */

/*2. Verification de la presence des valeurs manquantes */
data bank;
	set work.import;
run;

proc means data=bank n nmiss;
		var _numeric_; 
	run;
	
/*3. Creation d'une variable "cat_age" */

data bank;
    set bank;
    if _n_ < 2000 then cat_age = "Cat1";         
    else if 2000 <= _n_ < 3000 then cat_age = "Cat2";
    else if 3000 <= _n_ < 4000 then cat_age = "Cat3"; 
    else if 4000 <= _n_ < 6000 then cat_age = "Cat4";  
    else if _n_ >= 6000 then cat_age = "Cat5";
    else cat_age = .; 
run;

/*4. Tracer un diagramme */
/* Étape 1 : Calcul des statistiques agrégées pour le diagramme */
proc sql;
    create table bank0 as
    select 
        cat_age, 
        campaign, 
        sum(balance) as mean_balance /* Remplacer par SUM(balance) si nécessaire */
    from bank
    group by cat_age, campaign;
quit;

/* Étape 2 : Tracer le diagramme en barres */
proc sgplot data=bank0;
    vbar cat_age / response=mean_balance group=campaign groupdisplay=cluster 
                 datalabel datalabelattrs=(size=8);
    xaxis label="Catégorie d'âge" grid;
    yaxis label="Balance (moyenne)" grid;
    keylegend / title="Campagne marketing";
    title "Diagramme en barre : Balance moyenne par catégorie d'âge et campagne marketing";
run;



/*5. Tracer le nuage de points avec "age" en x et "baalance" en y */

data bank1;
    set bank;
    if balance < 10000; 
run;

/* nuage de points */
proc sgplot data=bank1;
    scatter x=age y=balance / group=housing markerattrs=(symbol=circlefilled);
    xaxis label="Âge";
    yaxis label="Balance";
    title "Nuage de points : Âge vs Balance (Couleur par Housing)";
run;

/*6. Tracer pour ces memes observations une heatmap entre "age" et balance */

proc sgplot data=bank1;
    heatmap x=age y=balance / colormodel=(purple blue cyan green yellow orange red);
    xaxis label="Âge" grid;
    yaxis label="Balance" grid;
    title "Heatmap : Age vs Balance (Balance < 10000)";
run;

/*7. Construire un model de regression logistique */

proc logistic data=bank1 descending;
    class marital(ref='single') education(ref='primary') default(ref='no') 
          loan(ref='no') / param=ref; /* Variables qualitatives avec références */
    model housing(event='yes') = 
        age marital education default balance loan duration / selection=stepwise;
    output out=pred p=predicted_prob; /* Générer les probabilités prédites */
run;

/* Effet de la variable education : */

/*8. Courbe ROC associée */

/* Création de la courbe ROC */
proc logistic data=pred;
    /* Spécifier la variable de réponse et la probabilité prédite */
    model housing(event='yes') = predicted_prob / outroc=roc_data; 
run;

/* Tracer la courbe ROC */
proc sgplot data=roc_data;
    series x=_1mspec_ y=_sensit_ / lineattrs=(color=blue thickness=2);
    refline 0 / axis=x lineattrs=(color=gray pattern=shortdash); /* Ligne de base (x=0) */
    refline 1 / axis=y lineattrs=(color=gray pattern=shortdash); /* Ligne de base (y=1) */
    xaxis label="1 - Spécificité";
    yaxis label="Sensibilité";
    title "Courbe ROC pour le modèle de régression logistique";
run;

/* ************************************************************************************************* */
/*Exercie 2 */