%first load the whole image, then the cut version.
%all images need to be lateral corrected!

[file,path] = uigetfile('*.tif');

FileName = file;

vi=imread(FileName);



format long;

leerrot = vi(330:401,845:916,1); 
leergruen = vi(330:401,845:916,2);


lr=double(leerrot);
mlr=mean(lr,'all');

lg=double(leergruen);
mlg=mean(lg,'all');



%cut image:

[file,path] = uigetfile('*.tif');

FileName = file;

i=imread(FileName);

y=double(i);


format long;

r=y(:,:,1);
xr= log10(mlr./r);

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
          
g=y(:,:,2);
xg= log10(mlg./g);



p1g =   50.31    ;
p2g =   21.31  ;
p3g =    10.22  ;
p4g =  -0.01239 ;


ag =    -16.35    ;
bg =  74.64  ;
cg =    -3.616    ;
dg =  1.119     ;
 

A1 = size(xr,1);  
A2 = size(xr,2);
syms d 'real'    

kleinr  = p1r*xr.^4 + p2r*xr.^3 + p3r*xr.^2 + p4r*xr + p5r; disp('Rot 1/4');
kleinrd = p1r*(xr*d).^4 + p2r*(xr*d).^3 + p3r*(xr*d).^2 + p4r*(xr*d) + p5r; disp('Rot 2/4');
kleinr( xr > 0.2109319)= 0;
kleinrd( xr > 0.2109319)= 0;
        
grossr = ar*xr.^4 + br*xr.^3 + cr*xr.^2 + dr*xr+er;disp('Rot 3/4');
grossrd = ar*(xr*d).^4 + br*(xr*d).^3 + cr*(xr*d).^2 + dr*(xr*d) +er;disp('Rot 4/4');
grossr( xr <= 0.2109319)= 0;
grossrd( xr <= 0.2109319)= 0;

rot=grossr + kleinr;
rotd=grossrd + kleinrd;
clearvars grossr kleinr grossrd kleinrd xr

kleing = p1g*xg.^3 + p2g*xg.^2 + p3g*xg + p4g;disp('Grün 1/4');
kleingd = p1g*(xg*d).^3 + p2g*(xg*d).^2 + p3g*(xg*d) + p4g;disp('Grün 2/4');
kleing( xg > 0.1655474)= 0;
kleingd( xg > 0.1655474)= 0;

grossg = ag*xg.^3 + bg*xg.^2 + cg*xg + dg;disp('Grün 3/4');
grossgd = ag*(xg*d).^3 + bg*(xg*d).^2 + cg*(xg*d) + dg;disp('Grün 4/4');
grossg( xg <= 0.1655474)= 0;
grossgd( xg <= 0.1655474)= 0;

gruen=grossg + kleing;
gruend=grossgd + kleingd;
clearvars grossg kleing grossgd kleingd xg



mm =(rot-gruend).^2+(gruen-rotd).^2;
clearvars rot rotd gruen gruend 

%% Minima Part 1
count=0;
n_counts = A1;
disp('Run solver:');
parpool('local');
for w = 1 : A1
    tic
    parfor t = 1 : A2
        
     %Method 1
     dmm= diff(mm(w,t),d);
     extrema = vpasolve(dmm == 0, d);  
     [global_min(w,t),g_pos(w,t)]=(min(subs(mm(w,t),extrema)));
     d_min(w,t)=extrema(g_pos(w,t));
 
%    fplot(mm);
%    hold on
%    plot(d_min(w,t), global_min(w,t), '*');
%    hold off
    end
  t=toc;
  count=count+1;
  restzeit = duration(0,0,(t*(n_counts-count)));
  fprintf('Solve %d/%d (%.2f%%) Geschätzte Restzeit:', count,n_counts,(count/n_counts)*100);   
  disp(restzeit);

end
delete(gcp('nocreate')); 
         



d=double(d_min);
d=real(d);


x= log10(mlr./y);


p1 =       504.3  ;
p2 =      -180.5  ;
p3 =       39.71 ;
p4 =      4.016   ;
p5 =   -0.001867 ;

a =-78.28   ;
b =    233.7   ;
c =-122.7     ;
f =42.47   ;
e =  -3.621 ;
       

 
       


iteration_max = size(x,1);
iteration =0 ;
w=0;
t=0;
for w = 1 : size(x,1)
   iteration=iteration+1;
  
    for t = 1 : size(x,2)
   
         if x(w,t)<= 0.2109319
         kleinfit(w,t)  = p1*(x(w,t)*d(w,t)).^4 + p2*(x(w,t)*d(w,t)).^3 + p3*(x(w,t)*d(w,t)).^2 + p4*(x(w,t)*d(w,t)) + p5;
         else 
          kleinfit(w,t)=0 ;
         end;
     
         if x(w,t) > 0.2109319
         grossfitpoly(w,t) = a*(x(w,t)*d(w,t)).^4 + b*(x(w,t)*d(w,t)).^3 + c*(x(w,t)*d(w,t)).^2 + f*(x(w,t)*d(w,t)) +e;
         else grossfitpoly(w,t) = 0;
     
         end;
     
    end;
    
end
       
  

rot=grossfitpoly + kleinfit;

pvr = 65535*(1-(rot./20));


bild = uint16(pvr);

imwrite(bild,['Mickecal_Dual_' FileName],'Resolution', 72, 'Compression', 'none');