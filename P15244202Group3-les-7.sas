data teaching_approach;
   input method $ 0-1 grade 3-5;
   datalines;
A 52  
A 63  
A 44  
A 26  
A 61  
A 49  
A 32  
A 47  
A 35  
A 55  
A 51
A 38  
A 31  
A 38  
A 58  
A 39  
B 38
B 61
B 47
B 61
B 55
B 69
B 36
B 50
B 70
B 60
B 73
B 65
B 63
B 45
B 68
B 56
B 62
B 59
B 39
  ;
run;  

/*
Two sample t-test assumes that:
    -There is one continuous dependent variable and one categorical independent variable (with 2 levels);
    -The two samples are independent;
    -The two samples follow normal distributions, and can be done with Normality check. 
    -The variances of the two samples are equal.
*/

/*
 In this  example, two samples (method and grade) are independent since the two samples are not related -randomly chosen-
 ot after-before on one subject",
 and pass the Normality check(as shown below). So we continue with two sample t-test. the test is two-sided (sides=2),
 the significance level is 0.05, and the test is to compare the difference between two means (muA - muB) against 0 (h0=0). 

*/
     /* check for normality */
     
proc univariate data=teaching_approach normal; 
	qqplot grade /Normal(mu=est sigma=est color=red l=1);
	by method;
run;
/*  Since the sample size is less than 2000, the Shapiro test is better.
 The null hypothesis of a normality test is that there is no significant departure from normality.
  When the p is more than .05, it fails to reject the null hypothesis and thus the assumption holds.

   Since the sample size is very small and Shpiro test shows a big p-value of 0.7588 and 0.2057 respectively, 
   it suggests that the data follows Normal distribution.  */
	
	

ODS GRAPHICS ON;
proc ttest data=teaching_approach H0=0 sides=2 alpha=0.05;
	class method;
	var grade;
run;
ODS GRAPHICS Off;
	
/* preforming t test and checking for  Homogeneity of Variance

   H0:muA=muB
   Ha:muA != muB
   
   When the p-value (shown under "Pr>F") is greater than 0.05,
   then the variances are equal then read the "Pooled" section of the result 
   the p-value = 0.9770 > 0.05 so we read the "pooled" section 
   p-value = 0.0043 < 0.05(alpha) 
   The conclusion is to reject the null hypothesis and that the the reading grade of two methods are  different
   B is better than A.
   
   For confidence interval for control-treatment = (-19.5320 -3.9615) 
   lower and upper confidence limits of the mean 95% confidence limits

*/
	
	/* If we look at the B method data we could argue that the data in qq-plot 
	   does not seems to flollow the diagnal line very well 
	   
	   
	            Useing non-parametric test Mann-Whitney two sample test*/ 
	            
proc npar1way
    data = teaching_approach
    wilcoxon
    median
    plots = (wilcoxonboxplot medianplot);
    class method;
    var grade;
    freq grade;
run;

/*   p-value = 0.001 < 0.05 which support our previuos results */
	
	
	
	
	
	
	