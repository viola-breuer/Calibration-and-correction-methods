m = 878;

 p1 =  -2.389e-07  ;
 p2 =   0.0002117 ;
 p3 =      0.9516  ;

for x = 1 : m
  
      r(x) = p1*x.^2 + p2*x + p3;
      
end



p1 =  -2.091e-07  ;
p2 =   0.0001925  ;
p3 =      0.9541 ;

x=1;

for x = 1 : m
  
      g(x) = p1*x.^2 + p2*x + p3;
    
end

       p1 =  -2.147e-07  ;
       p2 =   0.0002061 ;
       p3 =      0.9445  ;

x=1;

for x = 1 : m
  
      b(x) = p1*x.^2 + p2*x + p3;
    
end


[file,path] = uigetfile('*.tif');

FileName = file;

i=imread(FileName);


dI = double(i);

redimage=dI(:,:,1);
korrot = redimage./r';

greenimage=dI(:,:,2);
korgruen = greenimage./g';

blueimage=dI(:,:,3);
korblau = blueimage./b';




format long;

leerrot = korrot(330:401,845:916,1); 
leergruen = korgruen(330:401,845:916,1);
leerblau = korblau(330:401,845:916,1);

lr=double(leerrot);
mlr=mean(lr,'all');

lg=double(leergruen);
mlg=mean(lg,'all');

lb=double(leerblau);
mlb=mean(lb,'all');



xr= log10(mlr./korrot);

 p1r =       504.3  ;
p2r =      -180.5  ;
p3r =       39.71 ;
p4r =      4.016   ;
p5r =   -0.001867 ;

ar =-78.28   ;
br =    233.7   ;
cr =-122.7     ;
dr =42.47   ;
er =  -3.621 ;
          

xg= log10(mlg./korgruen);



p1g =   50.31    ;
p2g =   21.31  ;
p3g =    10.22  ;
p4g =  -0.01239 ;


ag =    -16.35    ;
bg =  74.64  ;
cg =    -3.616    ;
dg =  1.119     ;
      



xb= log10(mlb./korblau);

  
   p1b =        480 ;
       p2b =      116.5  ;
       p3b =        22.02    ;
       p4b =     -0.02637   ;
 
      ab =        -9.398 ;
      bb =       145.6  ;
      cb =        17.93  ;
       db =    0.3496  ;
       

iteration_max = size(xr,1);
iteration =0 ;
for w = 1 : size(xr,1)
   iteration=iteration+1;
  
    for t = 1 : size(xr,2)
   
         if xr(w,t)<= 0.2109319
            kleinr(w,t)  = p1r*xr(w,t).^4 + p2r*xr(w,t).^3 + p3r*xr(w,t).^2 + p4r*xr(w,t) + p5r;
           
         else 
            kleinr(w,t)=0 ;
           
         end;
     
         if xr(w,t) > 0.2109319
            grossr(w,t) = ar*xr(w,t).^4 + br*xr(w,t).^3 + cr*xr(w,t).^2 + dr*xr(w,t) +er;
            
         else
             grossr(w,t) = 0;
            
     
         end;
         
         rot(w,t)=grossr(w,t) + kleinr(w,t);
         
         
         if xg(w,t)<= 0.1655474
            kleing(w,t)  = p1g*xg(w,t).^3 + p2g*xg(w,t).^2 + p3g*xg(w,t) + p4g;
            
         else 
            kleing(w,t)=0 ;
            
         end;
     
         if xg(w,t) > 0.1655474
            grossg(w,t) = ag*xg(w,t).^3 + bg*xg(w,t).^2 + cg*xg(w,t) + dg;
            
         else
             grossg(w,t) = 0;
             
         end;
         
         gruen(w,t)=grossg(w,t) + kleing(w,t);
       
         
         
         if xb(w,t)<= 0.0782058
            kleinb(w,t)  = p1b*xb(w,t).^3 + p2b*xb(w,t).^2 + p3b*xb(w,t) + p4b;
            
         else 
            kleinb(w,t)=0 ;
          
         end;
     
         if xb(w,t) > 0.0782058
            grossb(w,t) = ab*xb(w,t).^3 + bb*xb(w,t).^2 + cb*xb(w,t) + db;
          
         else
            grossb(w,t) = 0;
          
         end;
         
         blau(w,t)=grossb(w,t) + kleinb(w,t);
      
         
         
    
     
    end;
    
end;
       


final= gruen./3 +rot./3+ blau./3;


pv = 65535*(1-(final./20));


bild = uint16(pv);

imwrite(bild,['Tripel_Mean_lateralcorrected_' FileName],'Resolution', 72, 'Compression', 'none');