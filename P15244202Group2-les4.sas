filename job "/folders/myfolders/dmu";
%include job("SAS-Proc-Reg-Example-2.txt");

data fit;
	set FITNESS;
	ratio=RunPulse/RestPulse;
run;

proc print data=fit;
run;

data fit1;
	set FITNESS;
	per_mile=RunTime/1.5;
run;

proc print data=fit1;
run;

proc means data=FITNESS maxdec=2 min q1 q3 max min ;
	var Age Oxygen RestPulse RunPulse MaxPulse;
run;

proc univariate data=FITNESS noprint;
	var RunTime;
	output out=time_median_data mean=time_median; *out put the RunTime median to time_median_data;
run;

proc print data=time_median_data; * check for time_median_data;
run;

data Fitness_Temp; * Adding Q1 and Q3 to each line of the Fitness_Temp data set;
   retain time_median;* keep value of time_median around to be reused;
   if _n_=1 then set time_median_data; * read and process time_median_data first;
   set FITNESS;
run;




proc print data=Fitness_Temp;
run;

data Fitness_Temp;
   set Fitness_Temp;
   if RunTime <= time_median then time_cat=1; * add time_cat ;
   else time_cat =2;
run;
  
proc print data=Fitness_Temp;
run; 

proc freq data=Fitness_Temp; * check construction of time category variable ;
	table time_cat;
run;

proc univariate data=Fitness_Temp noprint;
	var RestPulse;
	class time_cat;
	output out=quartiles Q1=p_25 Q3=p_75;
run;

proc print data=quartiles;
run;





