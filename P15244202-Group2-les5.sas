
ods listing close;
ods pdf file = '/folders/myfolders/delme.pdf';
ods html file = '/folders/myfolders/delme.html';
ods rtf  file = '/folders/myfolders/delme.rtf';


proc means data=FITNESS maxdec=2 min p25 median p75 max;
	var Age Oxygen RestPulse RunPulse; 
run;


proc tabulate

data = fitness;

  var Age Oxygen RestPulse RunPulse MaxPulse;
  table age Oxygen  RestPulse RunPulse MaxPulse 
		,min q1 median q3 max;
run;


proc univariate data=FITNESS noprint;

	var RunTime;
	output out=time_median_data mean=time_median; *out put the RunTime median to time_median_data;
	
run;


data Fitness_Temp; * Adding Q1 and Q3 to each line of the Fitness_Temp data set;

   retain time_median;* keep value of time_median around to be reused;
   if _n_=1 then set time_median_data; * read and process time_median_data first;
   
   set FITNESS;
run;


data Fitness_Temp;

   set Fitness_Temp;
   if RunTime <= time_median then time_cat=1; * add time_cat ;
   else time_cat =2;
   
run;


proc tabulate data=Fitness_Temp;

	class time_cat;
	var Age Oxygen RestPulse RunPulse MaxPulse;
	table time_cat='Time Category' *(Age Oxygen RestPulse RunPulse MaxPulse) 
	, min q1 median q3 max;
	
run;


data fit;

	set FITNESS;
	ratio=RunPulse/RestPulse;
	
run;

proc sgplot data=fit pad=(left=15%) ;

   scatter y=RunTime x=Age / markerattrs=(symbol=diamondfilled color=cx800080);
   xaxis label =" Age ";
   yaxis label =" Time to run 1.5 mile";
   
run;

proc sgplot data=fit;

 	vbar Age / response=RunTime fillattrs=(color=lightblue);
 	
run;
                                                                                                                     

title 'Box Plot for all numeric variables against Y axis(RunTime)';

proc sgscatter data=fit;

   plot RunTime*(Age Oxygen RestPulse RunPulse MaxPulse ratio);
   
run;

quit;
ods _all_ close; 
ods listing;