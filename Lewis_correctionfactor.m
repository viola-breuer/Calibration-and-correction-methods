

[file,path] = uigetfile('*.tif');

FileName = file;

i=imread(FileName);



y=double(i);

format long;


lr= y(330:401,845:916,1);
mlr=mean(lr,'all');

lg= y(330:401,845:916,2);
mlg=mean(lg,'all');

lb= y(330:401,845:916,3);
mlb=mean(lb,'all');



%3 (440:512,960:1032,)
%refr=0.286097152;
%refg=0.197583;
%refb=0.088379256;

%6 (455:523,860:931,)
%refr=0.394010173;
%refg=0.312562513;
%refb=0.153220156;

%8 (580:651,845:916,)
%refr=0.455103272
%refg=0.357787408
%refb=0.183912237


%11 (585:657,960:1032,)
%refr=0.53175014;
%refg=0.42663816;
%refb=0.232055688;


%15 (330:402,955:1027,) 
%refr=0.581215407;
%refg=0.498336191;
%refb=0.270532955;




dr=y(580:651,855:926,1); 

dg=y(580:651,855:926,2); 

db=y(580:651,855:926,3); 


refr=0.455103272;
refg=0.357787408;
refb=0.183912237;

mdr=mean(dr,'all');
mdg=mean(dg,'all');
mdb=mean(db,'all');

Ar=refr/(log10(mlr/mdr))
Ag=refg/(log10(mlg/mdg))
Ab=refb/(log10(mlb/mdb))

