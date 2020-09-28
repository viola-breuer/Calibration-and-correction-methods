

[file,path] = uigetfile('*.tif');

FileName = file;

i=imread(FileName);

j = i(:,:,1);

y=double(j);

format long;


lr= y(330:401,845:916,1);
mlr=mean(lr,'all');


x= log10(mlr./y)*Ar;

p1 =       504.3  ;
p2 =      -180.5  ;
p3 =       39.71 ;
p4 =      4.016   ;
p5 =   -0.001867 ;

a =-78.28   ;
b =    233.7   ;
c =-122.7     ;
d =42.47   ;
e =  -3.621 ;
       
       

iteration_max = size(x,1);
iteration =0 ;
for w = 1 : size(x,1)
   iteration=iteration+1;
  
    for t = 1 : size(x,2)
   
         if x(w,t)<= 0.2109319
         kleinfit(w,t)  = p1*x(w,t).^4 + p2*x(w,t).^3 + p3*x(w,t).^2 + p4*x(w,t) + p5;
         else 
          kleinfit(w,t)=0 ;
         end;
     
         if x(w,t) > 0.2109319
         grossfitpoly(w,t) = a*x(w,t).^4 + b*x(w,t).^3 + c*x(w,t).^2 + d*x(w,t) +e;
         else grossfitpoly(w,t) = 0;
     
         end;
     
    end;
    
end
       
  

rot=grossfitpoly + kleinfit;

pvr = 65535*(1-(rot./20));


bild = uint16(pvr);

imwrite(bild,['Redcalibrated_Lewis_' FileName],'Resolution', 72, 'Compression', 'none');