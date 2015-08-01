/**************************************
CASE STUDY 14 - Clustering - Stores Data
File Used: clustering_data-class14.csv
STEP 4: Cluster Level Profiling
*********************************************/


LIBNAME CS14 '/folders/myshortcuts/myfolder/SSCode/CS14/Datasets';



DATA CS14.MERGING_THE_Z_SCORES;
	SET CS14.MERGING_THE_CLASSIFIED_DATA;
	
	Abs_Z_Score1 = Abs_Z_Score;
	Z_Score1 = Z_Score;
	Variable1= Variable;
	
	Abs_Z_Score2 = LAG1(Abs_Z_Score);
	Z_Score2 = LAG1(Z_Score);
	Variable2= LAG1(Variable);
	
	Abs_Z_Score3 = LAG2(Abs_Z_Score);
	Z_Score3 = LAG2(Z_Score);
	Variable3= LAG2(Variable);
	
	Abs_Z_Score4 = LAG3(Abs_Z_Score);
	Z_Score4 = LAG3(Z_Score);
	Variable4= LAG3(Variable);
	
	Abs_Z_Score5 = LAG4(Abs_Z_Score);
	Z_Score5 = LAG4(Z_Score);
	Variable5= LAG4(Variable);
	
	VCount = MOD( _N_ , 5);
RUN;


PROC PRINT
	DATA=CS14.MERGING_THE_Z_SCORES;
	VAR VCount;
RUN;


/* Cleaning up the Dataset to easily compare the different clusters Z-Scores. */
DATA CLEAN_MERGED_Z_SCORES;
	RETAIN 
		CLUSTER 
		No_Of_Stores 
		Cluster_No_Of_Stores_Percent 
		Abs_Z_Score5
		Abs_Z_Score4
		Abs_Z_Score3
		Abs_Z_Score2
		Abs_Z_Score1
		Z_Score5
		Z_Score4
		Z_Score3
		Z_Score2
		Z_Score1
		Variable5
		Variable4
		Variable3
		Variable2
		Variable1;
	SET CS14.MERGING_THE_Z_SCORES
		(KEEP=
			CLUSTER 
			No_Of_Stores 
			Cluster_No_Of_Stores_Percent 
			Abs_Z_Score5
			Abs_Z_Score4
			Abs_Z_Score3
			Abs_Z_Score2
			Abs_Z_Score1
			Z_Score5
			Z_Score4
			Z_Score3
			Z_Score2
			Z_Score1
			Variable5
			Variable4
			Variable3
			Variable2
			Variable1
			VCount
		);
	WHERE VCount = 0;
RUN;


PROC PRINT
	DATA=CLEAN_MERGED_Z_SCORES;
RUN;

PROC MEANS
	DATA=CLEAN_MERGED_Z_SCORES;
RUN;
