/* # notice that numbers are in 000
   p-value :associated probability values
   measure of strength of the evidence
   against the null hypothesise,The smaller the p-value,the greater
   the evidence against the null hypothesise
*/
data expenditures;
	input expenditure @@;
	datalines;
	92 277 391 310 249 335 264
	210 223 372 242 380 201 130 180
	;
run;

/**********************************************
* The t test assumes that the data is         *
* normally distributed ,to test the normailty *
* " Goodness-of-Fit Tests " since n <30       *
*  normal distribution = Bell shaped  curve   *
*  and also assumes that the two samples      *
*  variables (Continuous) are independent     *
*  we can see that these variables ar         *
*  independent since there is n effect from   *
*  one other                                  *
**********************************************/

/* testing for normality useing proc UNIVARIATE */

proc univariate data=expenditures normal;
	title ' Normality test for expenditures data';
	var expenditure;
	histogram / normal;
run;

/*  we can see that the polt of expenditures 
	is very close to the bell shae curve */
	
	
	/*    using t-test 
	moreover the qq-plot shows the data points
	fit the reg lines in good fit 
	moreover we can see that the 
	Anderson-darling test  0.250 which mean our 
	expenditures data is normaly distributed "null hypotheisise
	is not rejected " */


/* Second way to test normality is 
  by useing histogram of the data and using QQ-plot.
  in t-test proc 
  
  NULL hypothesis: H0= mu=205 
  Ha= mu != 205  means are fidderent (sides=2) 
  ALPHA 0.05 Accepted possibility of type | error is 5% 
  OR 95% confidence interval  */
  
ODS GRAPHICS ON;
proc ttest data=expenditures H0=205 sides=2 alpha=0.05;
	var expenditure;
run;

       /* interpretation of the t-test */
       
/***********************************************************
	As we can see from t-test results pr >t (p-vlue) DF=14 :
	p-value=0.04 < 0.05 (alpha) => we REJECT the NULL hypothesise 
	"mu1=mu2=205" and we accept the alternative hypothesise
	mu1 != mu2 (the two means are different) 
	
	95% CL Mean: 207.6-306.5 : we are 95% confidence that
	the true mean is between 207.6 and 306.5  */ 
	
	      			/********************
	      			* Part 2 lesson 6   *
	      			********************/
data preformance;
	input operator$ time1 time2 @@;
	improve=time1-time2;
	datalines;
	A 15 14
	B 20 18
	C 19 15
	D 18 17
	E 14 13
	F 12 13
	G 18 19
	H 13 15
	I 16 13
	J 20 14
	K 16 15
	L 16 16
	M 18 16
	N 14 12
	;
run;
proc print data=preformance;
run;
   
   /* H0=0 Null hypothises means no difference between old and new machines Mu_old=Mu_new */  			
proc ttest data=preformance H0=0 sides=2 alpha=0.05;	
	var improve ;
run;
/*    p-value=0.0309 < 0.05 and we reject the null hypothises and we conclude 
      that there is an improvement of buying the new machine 
    */
       