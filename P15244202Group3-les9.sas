proc format;
	value glass 
		1 = 'type1' 
		2 = 'type2'
	;
	value phosphor 
		1 = 'A' 
		2 = 'B' 
		3 = 'C'
	;
run;

data glass_phosphor;
	infile datalines;
	input 
		glass 
		phosphor 
		requests 
		@@
	;
format 
	glass glass. 
	phosphor phosphor.
	;
label
	glass = 'glass of phosphor type'
	phosphor = 'Catalog requests'
	;

datalines;
1 1 280 1 1 290 1 1 285
1 2 300 1 2 310 1 2 295
1 3 170 1 3 285 1 3 290
2 1 230 2 1 235 2 1 240
2 2 260 2 2 240 2 2 235
2 3 220 2 3 225 2 3 230
;
run;
proc print data=glass_phosphor;
run;
/* calculate data needed for
the profile plot */
proc means
data= glass_phosphor;
var requests;
by glass phosphor;
output out=means mean=mean;
run;
/* create profile plot */
proc sgplot
data=means;
series x=glass y=mean / group=phosphor;

run;


proc glm
  data= glass_phosphor;
  class phosphor glass;
  model /* includes interaction */
    requests=
      phosphor
      glass
      phosphor*glass; /* interaction */
lsmeans phosphor glass phosphor*glass;
output /* save residuals for later */
  out=predicted
  p=predicted r=residual;
run;
/*
First check:
◦ 2 × 3 = 6 cells
◦ Number of observations used = 18
◦ 18 ÷ 6 = 3 observations per cell – matches our source data
*/
                  /* Interpretation of interaction */
                  
/*
  Interaction term (design * size) (0.5804):> p"0.05" we fail to reject the Null hypothesise and we conclude 
  there was no interaction
  
  Glass type has signegigant effect: p-value 0.0075 < 0.05
  Phosphor has no signeficant effect:p-value 0.1218 > 0.05
*/

/*
     Model without interaction
*/
proc glm
  data= glass_phosphor;
  class phosphor glass;
  model /* includes interaction */
    requests=
      phosphor
      glass
      ; /* interaction */
lsmeans phosphor glass;
output /* save residuals for later */
  out=predicted
  p=predicted r=residual;
run;




proc anova data=glass_phosphor;
      class phosphor glass;
      model requests =phosphor glass;
      means glass phosphor/ LSD;
run;

/*   Fishers Least Significant Difference (LSD) test
     LSD test show:
     compare the mean of one group with the mean of another.
     equivalent to a 95% confidence level 

*/