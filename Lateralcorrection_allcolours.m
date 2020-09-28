m = 878;

 p1 =  -2.389e-07  ;
 p2 =   0.0002117 ;
 p3 =      0.9516  ;

for x = 1 : m
  
      r(x) = p1*x.^2 + p2*x + p3;
      
end



l1 =  -2.091e-07  ;
o2 =   0.0001925  ;
n3 =      0.9541 ;

y=1;

for y = 1 : m
  
      g(y) = l1*y.^2 + o2*y + n3;
    
end

       q1 =  -2.147e-07  ;
       r2 =   0.0002061 ;
       s3 =      0.9445  ;

z=1;

for x = 1 : m
  
      b(x) = q1*x.^2 + r2*x + s3;
    
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

bild=dI;
bild(:,:,1)=korrot;
bild(:,:,2)=korgruen;
bild(:,:,3)=korblau;

bild=uint16(bild);

imwrite(bild,['Lateralcorrected_allcolours_' FileName],'Resolution', 72, 'Compression', 'none');