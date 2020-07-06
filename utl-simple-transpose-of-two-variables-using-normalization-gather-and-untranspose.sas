Simple transpose of two variables using normalization gather and untranspose                                                            
                                                                                                                                        
SAS Forum                                                                                                                               
https://tinyurl.com/yb9roj42                                                                                                            
https://communities.sas.com/t5/SAS-Programming/Transpose-Column-into-rows/m-p/667058                                                    
                                                                                                                                        
see                                                                                                                                     
                                                                                                                                        
                                                                                                                                        
  Two Solutions                                                                                                                         
                                                                                                                                        
       a. gather macro      (Alea Iacta https://github.com/clindocu)                                                                    
       b. untranspose macro (Arthur Tabachneck, Gerhard Svolba, Joe Matise and Matt Kastin)                                             
       c. normalize then transpose                                                                                                      
/*                   _                                                                                                                  
(_)_ __  _ __  _   _| |_                                                                                                                
| | `_ \| `_ \| | | | __|                                                                                                               
| | | | | |_) | |_| | |_                                                                                                                
|_|_| |_| .__/ \__,_|\__|                                                                                                               
        |_|                                                                                                                             
*/                                                                                                                                      
                                                                                                                                        
                                                                                                                                        
data have;                                                                                                                              
 input Owner$ Owner1$ Owner2$;                                                                                                          
cards4;                                                                                                                                 
Tom Sam Radha                                                                                                                           
Tom Sam Jane                                                                                                                            
Tom Jack Chang                                                                                                                          
Jane Vijay Ajay                                                                                                                         
Jane Uma Sandeep                                                                                                                        
Jane Peter Brian                                                                                                                        
Jane Peter Lance                                                                                                                        
;;;;                                                                                                                                    
run;quit;                                                                                                                               
                                                                                                                                        
Up to 40 obs WORK.HAVE total obs=7                                                                                                      
                                                                                                                                        
Obs    OWNER    OWNER1    OWNER2                                                                                                        
                                                                                                                                        
 1     Tom      Sam       Radha                                                                                                         
 2     Tom      Sam       Jane                                                                                                          
 3     Tom      Jack      Chang   ** make one observation out of these three records and reduce dups;                                   
                                                                                                                                        
 4     Jane     Vijay     Ajay                                                                                                          
 5     Jane     Uma       Sandeep                                                                                                       
 6     Jane     Peter     Brian                                                                                                         
 7     Jane     Peter     Lance                                                                                                         
                                                                                                                                        
/*           _               _                                                                                                          
  ___  _   _| |_ _ __  _   _| |_                                                                                                        
 / _ \| | | | __| `_ \| | | | __|                                                                                                       
| (_) | |_| | |_| |_) | |_| | |_                                                                                                        
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                                       
                |_|                                                                                                                     
*/                                                                                                                                      
                                                                                                                                        
Up to 40 obs WORK.WANT total obs=2                                                                                                      
                                                                                                                                        
 OWNER    OWNER1    OWNER2    OWNER3    OWNER4     OWNER5    OWNER6    OWNER7    OWNER8                                                 
                                                                                                                                        
 Jane     Vijay     Ajay       Uma      Sandeep    Peter     Brian     Peter     Lance                                                  
 Tom      Sam       Radha      Sam      Jane       Jack      Chang                                                                      
                                                                                                                                        
/*                     _   _                                                                                                            
  __ _      __ _  __ _| |_| |__   ___ _ __                                                                                              
 / _` |    / _` |/ _` | __| `_ \ / _ \ `__|                                                                                             
| (_| |_  | (_| | (_| | |_| | | |  __/ |                                                                                                
 \__,_(_)  \__, |\__,_|\__|_| |_|\___|_|                                                                                                
           |___/                                                                                                                        
*/                                                                                                                                      
                                                                                                                                        
proc datasets lib=work;                                                                                                                 
 delete haveXpo havSrt want;                                                                                                            
run;quit;                                                                                                                               
                                                                                                                                        
%utl_gather(have,var,val,owner,havXpo,valformat=$8.);                                                                                   
                                                                                                                                        
/*                                                                                                                                      
p to 40 obs WORK.HAVXPO total obs                                                                                                       
                                                                                                                                        
bs    OWNER     VAR      VAL                                                                                                            
                                                                                                                                        
 1    Tom      OWNER1    Sam                                                                                                            
 2    Tom      OWNER1    Sam  ** only transpose one of these;                                                                           
 3    Tom      OWNER2    Radha                                                                                                          
 4    Tom      OWNER2    Jane                                                                                                           
 5    Tom      OWNER1    Jack                                                                                                           
 6    Tom      OWNER2    Chang                                                                                                          
 7    Jane     OWNER1    Vijay                                                                                                          
 8    Jane     OWNER2    Ajay                                                                                                           
 9    Jane     OWNER1    Uma                                                                                                            
10    Jane     OWNER2    Sandeep                                                                                                        
11    Jane     OWNER1    Peter                                                                                                          
12    Jane     OWNER2    Brian                                                                                                          
13    Jane     OWNER1    Peter                                                                                                          
14    Jane     OWNER2    Lance                                                                                                          
*/                                                                                                                                      
                                                                                                                                        
* remove dups;                                                                                                                          
proc sort data=havXpo out=havSrt noequals nodupkey;                                                                                     
  by owner val;                                                                                                                         
run;quit;                                                                                                                               
                                                                                                                                        
* note the prefix option;                                                                                                               
proc transpose data=havSrt prefix=owner out=want(drop=_name_);                                                                          
  by owner;                                                                                                                             
  var val;                                                                                                                              
run;quit;                                                                                                                               
                                                                                                                                        
/*                                                                                                                                      
WORK.WANT total obs=2                                                                                                                   
                                                                                                                                        
 OWNER    OWNER1    OWNER2    OWNER3    OWNER4    OWNER5     OWNER6    OWNER7                                                           
                                                                                                                                        
 Jane     Ajay      Brian     Lance     Peter     Sandeep     Uma      Vijay                                                            
 Tom      Chang     Jack      Jane      Radha     Sam                                                                                   
*/                                                                                                                                      
                                                                                                                                        
/*           _                                                                                                                          
 _   _ _ __ | |_ _ __ __ _ _ __  ___ _ __   ___  ___  ___                                                                               
| | | | `_ \| __| `__/ _` | `_ \/ __| `_ \ / _ \/ __|/ _ \                                                                              
| |_| | | | | |_| | | (_| | | | \__ \ |_) | (_) \__ \  __/                                                                              
 \__,_|_| |_|\__|_|  \__,_|_| |_|___/ .__/ \___/|___/\___|                                                                              
                                    |_|                                                                                                 
*/                                                                                                                                      
                                                                                                                                        
proc datasets lib=work;                                                                                                                 
 delete haveXpo havSrt want;                                                                                                            
run;quit;                                                                                                                               
                                                                                                                                        
* creates the same intermediate datasets as gether;                                                                                     
%untranspose(data=have, out=want, by=owner, var=owner1 owner2)                                                                          
                                                                                                                                        
proc sort data=havXpo out=havSrt noequals nodupkey;                                                                                     
  by owner val;                                                                                                                         
run;quit;                                                                                                                               
                                                                                                                                        
proc transpose data=havSrt prefix=owner out=want(drop=_name_);                                                                          
by owner notsorted;                                                                                                                     
var val;                                                                                                                                
run;quit;                                                                                                                               
                                                                                                                                        
/*                                _ _                                                                                                   
 _ __   ___  _ __ _ __ ___   __ _| (_)_______                                                                                           
| `_ \ / _ \| `__| `_ ` _ \ / _` | | |_  / _ \                                                                                          
| | | | (_) | |  | | | | | | (_| | | |/ /  __/                                                                                          
|_| |_|\___/|_|  |_| |_| |_|\__,_|_|_/___\___|                                                                                          
                                                                                                                                        
*/                                                                                                                                      
                                                                                                                                        
                                                                                                                                        
proc datasets lib=work mt=data mt=view;                                                                                                 
 delete havVue haveXpo havSrt want ;                                                                                                    
run;quit;                                                                                                                               
                                                                                                                                        
data havVue/view=havVue;                                                                                                                
  set have;                                                                                                                             
  var="owner1";val=owner1;output;                                                                                                       
  var="owner2";val=owner2;output;                                                                                                       
  drop owner1 owner2;                                                                                                                   
run;quit;                                                                                                                               
                                                                                                                                        
proc sort data=havVue out=havSrt noequals nodupkey;                                                                                     
  by owner val;                                                                                                                         
run;quit;                                                                                                                               
                                                                                                                                        
proc transpose data=havXpo                                                                                                              
  out=want(drop=_name_ rename=(col1-col8=owner1-owner8));;                                                                              
by owner notsorted;                                                                                                                     
var val;                                                                                                                                
run;quit;                                                                                                                               
                                                                                                                                        
                                                                                                                                        
