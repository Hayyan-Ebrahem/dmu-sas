data snail;
  %let _EFIERR_ = 0;
  infile '/folders/myfolders/snail.csv' dlm=',';
  
     informat observation best32.;
     informat speed best32.;
     informat proportion_back best32.;
     informat time_climb best32.;
     

     format observation best32.;
     format speed best32.;
     format proportion_back best32.;
     format time_climb best32.;
    
    input
    
            observation
            speed
            proportion_back
            time_climb
           ;
           
    run;
     
/* the code under will not work for SAS University Edition */
/* Create the grid data */
proc g3grid data=snail out=snail_3d;
  grid speed*proportion_back = time_climb / 
    axis1=30 to 80 by 5
    axis2=30 to 80 by 5;
run;
/* Plot the Surface */
proc g3d data=snail_3d;
  plot speed*proportion_back = time_climb;
run;

/* Work around to plot 3d grid in SAS University Edition */
proc template;
  define statgraph surface;
  begingraph;
    layout overlay3d;
      surfaceplotparm x=speed y=proportion_back z=time_climb;
    endlayout;
  endgraph;
end;
run;

proc sgrender data=snail template=surface;
run;


               /*max proportion slipped for each speed */
proc sql;
   create table proportion as select speed,max(proportion_back) as max
   from snail
   group by speed;
quit;

proc reg;
  model max= speed; /* Dependent Variable: max */
run;

/*    The regression line calculated by SAS is

               Y =  a + bx   
               
      intercept = 59.4
      slope = 0 
      
      max=59.4 linear equation 
      as we can see from the data there is no relation between speed and max proportion
      as the max has one value and the speed has different value for same max proportion 
*/
 
 
/* 6) Use macros to make the program analyse */

options symbolgen mlogic nomprint;                                                        
%let path = /folders/myfolders/;   


%Macro analyse(data_set);       
proc import datafile= "&&path&data_set";

     out=work..&data_set

     dbms=csv

     replace;             
     getnames=yes;

run;
proc print data="&&path&data_set";

run;

proc reg data=snail;
   model time_climb = proportion_back speed;
run;

 
%analyse(snail_csv);