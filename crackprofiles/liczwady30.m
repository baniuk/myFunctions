function liczwady30(Freq, inputstruct,varargin)
% inputstruct - tablica z wszystkimi ind
% varargin - numery wad ze struktury do policzenia. Je�li nie ma to liczy
% wszystkie. Program sam okre�la kt�re z wymienionych wad juz sa na hdd

rozmiarx = 0.25e-3;
rozmiary = 0.1250e-3;
plytax = 0.04;
plytay = 1.25e-3;
maxbnd = 3408;
if isstruct(inputstruct)
    inputstruct = inputstruct.param;
end

indstruct = inputstruct{2};
if nargin>2
    jakiewady = varargin{1};
else
    [si,unused] = size(indstruct);
    jakiewady = 1:si;
end
sw = length(jakiewady);
nazwapliku = inputstruct{8};

[F,w]=getlostindex(nazwapliku,'mat',[],Freq,jakiewady); % !!!!!!!!!!!
if isempty(F)||isempty(w)
    disp('Nothing to calc');
    return;
end
% mainmatrix = transforminput(Freq,wada);
mainmatrix = [F;w];
[unused,sm] = size(mainmatrix);

flclear fem
clear vrsn
vrsn.name = 'FEMLAB 3.0';
vrsn.ext = '';
vrsn.major = 0;
vrsn.build = 181;
vrsn.rcs = '$Name:  $';
vrsn.date = '$Date: 2004/01/29 19:04:14 $';
fem.version = vrsn;

otocz = rect2(0.05,0.014+0.008,'base','corner','pos',[-0.025 -0.008]);
c1 = rect2(0.75e-3,3.75e-3,'base','corner','pos',[-5e-3 0.25e-3]);
c2 = rect2(0.75e-3,3.75e-3,'base','corner','pos',[-2.75e-3 0.25e-3]);
c3 = rect2(0.75e-3,3.75e-3,'base','corner','pos',[2e-3 0.25e-3]);
c4 = rect2(0.75e-3,3.75e-3,'base','corner','pos',[4.25e-3 0.25e-3]);
cm1 = rect2(0.5e-3,1.5e-3,'base','corner','pos',[-1.25e-3 0.25e-3]);
cm2 = rect2(0.5e-3,1.5e-3,'base','corner','pos',[0.75e-3 0.25e-3]);
carr={curve2([-0.00425,-0.00425],[2.5E-4,0.00625],[1,1]), ...
  curve2([-0.00425,0.00425],[0.00625,0.00625],[1,1]), ...
  curve2([0.00425,0.00425],[0.00625,2.5E-4],[1,1]), ...
  curve2([0.00425,0.00275],[2.5E-4,2.5E-4],[1,1]), ...
  curve2([0.00275,0.00275],[2.5E-4,0.0040],[1,1]), ...
  curve2([0.00275,7.5E-4],[0.0040,0.0040],[1,1]), ...
  curve2([7.5E-4,7.5E-4],[0.0040,2.5E-4],[1,1]), ...
  curve2([7.5E-4,-7.5E-4],[2.5E-4,2.5E-4],[1,1]), ...
  curve2([-7.5E-4,-7.5E-4],[2.5E-4,0.0040],[1,1]), ...
  curve2([-7.5E-4,-0.00275],[0.0040,0.0040],[1,1]), ...
  curve2([-0.00275,-0.00275],[0.0040,2.5E-4],[1,1]), ...
  curve2([-0.00275,-0.00425],[2.5E-4,2.5E-4],[1,1])};
rdzen=geomcoerce('solid',carr);

p1 = rect2(rozmiarx,rozmiary,'base','corner','pos',[-plytax/2 -0.25e-3]);


gap1 = geomarrayr(p1,rozmiarx,-rozmiary,plytax/rozmiarx,plytay/rozmiary);
for a=1:(plytay/rozmiary)*plytax/rozmiarx
    nazwa(a)={sprintf('W%d',a+10)};          % nazwa jest cell {}
end

name = {'otocz','rdzen','c1','c2','c3','c4','cm1','cm2'};
name = [name nazwa];
objs = {otocz,rdzen,c1,c2,c3,c4,cm1,cm2};
objs = [objs gap1];
clear s;
s.objs=objs;
s.name=name;
s.tags=name;
fem.draw=struct('s',s);
fem.geom=geomcsg(fem);

clear appl
appl.mode.class = 'PerpendicularCurrents';
appl.assignsuffix = '_qa';
clear prop
prop.analysis='harmonic';
appl.prop = prop;
clear bnd
bnd.type = {'A0','cont'};
bnd.ind = 2*ones(1,maxbnd);
bnd.ind(1:3) = 1;
bnd.ind(end) = 1;

appl.bnd = bnd;
clear equ
equ.mur = {1,1,1,1,1000,1};
equ.sigma = {0,9.86e5,0,0,0,0};
equ.Jez = {0,0,10e5,-10e5,0,0};

appl.equ = equ;
appl.var = {'nu','100000'};
fem.appl{1} = appl;

fem.mesh=meshinit(fem,'Hmaxfact',1, ...
                  'Hgrad',1.09,'Hcurve',0.3, ...
                  'Hcutoff',0.001,...
                  'Hmaxsub',[846 765; 1e-4 1e-4]);

for f=1:sm
    F=sprintf('%d',mainmatrix(1,f));
    fem.appl{1}.var={'nu',F};
    fem.appl{1}.equ.ind = indstruct(mainmatrix(2,f),:);
    fem = multiphysics(fem);
    fem.xmesh = meshextend(fem);
    fem=femlin(fem, ...
           'Out',{'fem'}, ...
           'solcomp',{'Az'}, ...
           'outcomp',{'Az'}, ...
           'nonlin','off',...
           'Rowscale','on');         % opisane w command.pdf pp 78

        
    np = sprintf('%s_%d_%d',nazwapliku,mainmatrix(1,f),mainmatrix(2,f));
    fprintf('%s\n',np);
    A20=postint(fem,'Az','dl',765,'intorder',4);   % dla 10
    A21=postint(fem,'Az','dl',846,'intorder',4);   % dla 10
    m = [A20 A21];
    save(np,'m');
%     flsave(np,'fem');
%     compress(np,'fl','compress')   % Sprawdzi� getlostindex!!!!! na pocz�tku
    
% nagrywanie calego fema
%             A20=postint(fem,'Az','dl',385,'intorder',4);
%         
%             A21=postint(fem,'Az','dl',426,'intorder',4);
%         
%         
%             data{1} = [A20 A21];
%             data{2} = '1 - sub 385, 2 - sub 426';
%             data{3} = Freq(f);
%             np = sprintf('%s_F_%d_w_%d',nazwapliku,Freq(f),d);
%             save(np,'data');    
            
%             postplot(fem1,'tridata','Jiz_qa','trimap','jet(1024)', ...
%          'contdata','normB_qa','contlevels',20, ...
%          'contmap','cool(1024)','solnum',1,'cont', ...
%          'internal','refine',1,'geom', ...
%          'on','Contbar','off','Tribar','off','Axis',[-0.02 0.02 -1.5e-3 6.5e-3]);
%         drawnow;
%         nazwa=sprintf('rys%04d',d);
%         saveas(gcf,nazwa,'bmp');
end;

