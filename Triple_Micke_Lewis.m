%first load the whole image, then the cut version.
%all images need to be lateral corrected!

[file,path] = uigetfile('*.tif');

FileName = file;

vi=imread(FileName);



format long;

leerrot = vi(330:402,845:917,1); 
leergruen = vi(330:402,845:917,2);
leerblau = vi(330:402,845:917,3);

lr=double(leerrot);
mlr=mean(lr,'all');

lg=double(leergruen);
mlg=mean(lg,'all');

lb=double(leerblau);
mlb=mean(lb,'all');


%geschnittenes Bild laden

[file,path] = uigetfile('*.tif');

FileName = file;

i=imread(FileName);

y=double(i);


format long;



r=y(:,:,1);
xr= log10(mlr./r)*Ar;

p1r =       495.8  ;
p2r =      -180.1  ;
p3r =       40.42  ;
p4r =       3.951  ;
p5r =   -0.001643 ;

ar =  -39.55    ;
br =   156.7   ;
cr =  -69.36  ;
dr = 27.11  ;
er =  -2.064      ;
          
g=y(:,:,2);
xg= log10(mlg./g)*Ag;


p1g =   35.28    ;
p2g =   25.59  ;
p3g =    9.919  ;
p4g =  -0.01296 ;


ag =   -6.1    ;
bg =  62.99   ;
cg =   0.4459    ;
dg =  0.6768     ;

b=y(:,:,3);
xb= log10(mlb./b)*Ab;

  p1b =       -178.8 ;
       p2b =       200.2  ;
       p3b =        19.62    ;
       p4b =     -0.0256   ;
 
      ab =        68.19  ;
      bb =      100.6   ;
      cb =         25.71  ;
       db =      -0.06762 ;

A1 = size(xr,1);  
A2 = size(xr,2);
syms d 'real'    

kleinr  = p1r*xr.^4 + p2r*xr.^3 + p3r*xr.^2 + p4r*xr + p5r; disp('Rot 1/4');
kleinrd = p1r*(xr*d).^4 + p2r*(xr*d).^3 + p3r*(xr*d).^2 + p4r*(xr*d) + p5r; disp('Rot 2/4');
kleinr( xr > 0.263181)= 0;
kleinrd( xr > 0.263181)= 0;
        
grossr = ar*xr.^4 + br*xr.^3 + cr*xr.^2 + dr*xr+er;disp('Rot 3/4');
grossrd = ar*(xr*d).^4 + br*(xr*d).^3 + cr*(xr*d).^2 + dr*(xr*d) +er;disp('Rot 4/4');
grossr( xr <= 0.263181)= 0;
grossrd( xr <= 0.263181)= 0;

rot=grossr + kleinr;
rotd=grossrd + kleinrd;
clearvars grossr kleinr grossrd kleinrd xr

kleing = p1g*xg.^3 + p2g*xg.^2 + p3g*xg + p4g;disp('Grün 1/4');
kleingd = p1g*(xg*d).^3 + p2g*(xg*d).^2 + p3g*(xg*d) + p4g;disp('Grün 2/4');
kleing( xg > 0.241181)= 0;
kleingd( xg > 0.241181)= 0;

grossg = ag*xg.^3 + bg*xg.^2 + cg*xg + dg;disp('Grün 3/4');
grossgd = ag*(xg*d).^3 + bg*(xg*d).^2 + cg*(xg*d) + dg;disp('Grün 4/4');
grossg( xg <= 0.241181)= 0;
grossgd( xg <= 0.241181)= 0;

gruen=grossg + kleing;
gruend=grossgd + kleingd;
clearvars grossg kleing grossgd kleingd xg

kleinb = p1b*xb.^3 + p2b*xb.^2 + p3b*xb + p4b;disp('Blau 1/4');
kleinbd = p1b*(xb*d).^3 + p2b*(xb*d).^2 + p3b*(xb*d) + p4b;disp('Blau 2/4');
kleinb( xb > 0.065227)= 0;
kleinbd( xb > 0.065227)= 0;

grossb = ab*xb.^3 + bb*xb.^2 + cb*xb + db;disp('Blau 3/4');
grossbd = ab*(xb*d).^3 + bb*(xb*d).^2 + cb*(xb*d) + db;disp('Blau 4/4');
grossb( xb <= 0.065227)= 0;
grossbd( xb <= 0.065227)= 0;

blau=grossb + kleinb;
blaud=grossbd + kleinbd;
clearvars grossb kleinb grossbd kleinbd xb

mm =(rot-gruend).^2+(rot-blaud).^2+(gruen-rotd).^2+(gruen-blaud).^2+(blau-rotd).^2+(blau-gruend).^2;
clearvars rot rotd gruen gruend blau blaud

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



x= log10(mlr./y)*Ar;


 p1 =       495.8  ;
p2 =      -180.1  ;
p3 =       40.42  ;
p4 =       3.951  ;
p5 =   -0.001643 ;

a =  -39.55    ;
b =   156.7   ;
c =  -69.36  ;
f = 27.11  ;
e =  -2.064      ;

 
       


iteration_max = size(x,1);
iteration =0 ;
w=0;
t=0;
for w = 1 : size(x,1)
   iteration=iteration+1;
  
    for t = 1 : size(x,2)
   
         if x(w,t)<= 0.263181
         kleinfit(w,t)  = p1*(x(w,t)*d(w,t)).^4 + p2*(x(w,t)*d(w,t)).^3 + p3*(x(w,t)*d(w,t)).^2 + p4*(x(w,t)*d(w,t)) + p5;
         else 
          kleinfit(w,t)=0 ;
         end;
     
         if x(w,t) > 0.263181
         grossfitpoly(w,t) = a*(x(w,t)*d(w,t)).^4 + b*(x(w,t)*d(w,t)).^3 + c*(x(w,t)*d(w,t)).^2 + f*(x(w,t)*d(w,t)) +e;
         else grossfitpoly(w,t) = 0;
     
         end;
     
    end;
    
end
       
  

rot=grossfitpoly + kleinfit;


pvr = 65535*(1-(rot./20));


bild = uint16(pvr);

imwrite(bild,['Micke_Triple_Lewis_' FileName],'Resolution', 72, 'Compression', 'none');