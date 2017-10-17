filename job "/folders/myfolders/dmu";
%include job("SAS-Proc-Reg-Example-2.txt");
data fit;
	set FITNESS;
	ratio=RunPulse/RestPulse;
run;
data fit;
	set FITNESS;
	ratio=RunPulse/RestPulse;
run;
/* This code combines four graphs in one PDF file named one-page.PDF. The STARTPAGE=NEVER parameter keeps 
all the output on one page. Each graph is positioned on the page using the HORIGIN and VORIGIN parameters on the 
GOPTIONS statement. The size of each graph is set using the HSIZE and VSIZE parameters on the GOPTIONS 
statement. The first graph, GSLIDE, creates the common title over all the graphs. The LSPACE parameter on the TITLE 
statement inserts a line space above the title. The Courier/oblique font is used for all the text in the output
*/

options orientation=portrait;
goption reset=all dev=ACTIVEX;  
ods listing close; 
ods pdf file="one-page.pdf" startpage=never; /* The STARTPAGE=NEVER parameter keeps all the output on one page. */
goptions hsize=0 vsize=0; 
proc gslide; 
title1 'Group 3 lesson 8 assignment' lspace=.5in; 
run;quit; 
goptions horigin=0 vorigin=5 hsize=4 vsize=4; 
axis1 order=(0 to 10); 
title1 'Age'; 
pattern1 value=solid color=cx99ff99; 
proc sgplot data=FITNESS; 
   title "Runtime Age ";
   vbar Age / response=RunTime;
run;quit; 
goptions horigin=4 vorigin=5; 
title1 'Oxygen intake rate'; 
pattern1 value=solid color=cxffcc33; 
proc gchart data=FITNESS; 
	/*--Box Plot settings--*/
	vbox RestPulse / category=Oxygen fillattrs=(color=CXCAD5E5) name='Box';

	/*--Category Axis--*/
	xaxis fitpolicy=splitrotate;

	/*--Response Axis--*/
	yaxis grid; 
run;quit; 
goptions horigin=0 vorigin=0; 
title1 'Heart rate while resting'; 
pattern1 value=solid color=cxaa3311; 
proc gchart data=FIITNESS; 
/*--Scatter plot settings--*/
	series x=RestPulse y=RunTime / transparency=0.0 name='Series';

	/*--X Axis--*/
	xaxis grid;

	/*--Y Axis--*/
	yaxis grid;
run;quit; 
goptions horigin=4 vorigin=0; 
title1 'Ratio'; 
pattern1 value=solid color=cx99ccff; 
proc gchart data=FIT; 
   scatter y=RunTime x=Age / markerattrs=(symbol=diamondfilled color=cx800080);
   xaxis label =" ratio ";
   yaxis label =" Time to run 1.5 mile";
run;quit; 
ods pdf close; 
goptions reset=all; 
ods listing; 