function [Tmf,Tfis,Tfire,Tfiresum,x0]=Cmakrofis(numwe,nummf,tren,przec,varargin)
% ta funkcja dziala jak makro wywolujac funkcje skladowe potrzebne do
% zrobienia kompetnej struktury fis
%----------------- odwrotnie niz w makrofis---------------
% pobiera: ilosz wejsc, ilosc mf, dane treningowe, przeciecie mf
% format danych treningowych: w rzêdach oklejne wejœcia, w kolumnach koejne
% próbki. Ostatni rz¹d to jest wyjœcie
% Format MF - w rzêdach wejœcia, w kolumnach kolejne wartoœci sigma i c dla
% danej mf
% zwraca strukture  mf ilwe x ilmf*2
%                   fis - gotowa struktura fis
%                   rule - macierz
%                   fire - wyjscia z regul dla wszystkich punktow
%                   firesum - suma wszystkich wyjsc z rule dla kazdego
%                               punktu
% w varargin jest zewnetrzne mf lub/i 'optim' jesli ma zostac wykonana
% optymalizcja (wtedy zwracany jest gotowy fis)
czyoptim = 0;
czymf = 0;

if nargin>4
    for vv=1:nargin-4
        if isequal(varargin{vv},'optim')
            czyoptim = 1;
        else
            Tmf = varargin{vv};
            czymf = 1;
        end
    end
end

if ~czymf
    Tmf=Ccreatemf(numwe,nummf,tren,przec);   disp('MF done')
end

Tfis=newfis('qfisg','sugeno','prod','probor','prod','max','wtaver');
for a=1:numwe
    name=sprintf('we%d',a);
    Tfis=addvar(Tfis,'input',name,[min(min(tren)) max(max(tren(1:numwe,:)))]);
end
Tfis=addvar(Tfis,'output','wy',[0 1]);
licznik=1;
for a=1:numwe
    for b=1:nummf
        Tfis=addmf(Tfis,'input',a,sprintf('we%dmf%d',a,b),'gaussmf',[Tmf(licznik,a) Tmf(licznik+1,a)]);       % dla gauss
%         fis=addmf(fis,'input',a,sprintf('we%dmf%d',a,b),'gauss2mf',[tmp(a,licznik) tmp(a,licznik+1) tmp(a,licznik+2) tmp(a,licznik+3)]);       % dla 2gauss
        licznik=licznik+2;                              % zmiana dla gauus +2 !!!!!!!!!!!!!!!!!!!!!!!!11
    end
licznik=1;
end
[comp,act,Tfire,Tfiresum]=C_fillrule(tren,Tmf); % opis w pliku c
so=size(act);
for a=1:so(2)
    Tfis.rule(a).antecedent=act(:,a)';
    Tfis.rule(a).consequent= a;
    Tfis.rule(a).weight=1;
    Tfis.rule(a).connection=1;
    Tfis.output.mf(a).name=sprintf('out%d',a);
    Tfis.output.mf(a).type = 'constant';
    Tfis.output.mf(a).params = rand;
end

sss=sprintf('%d rules',length(Tfis.rule));
disp(sss);
disp('fis & rule done')
mm=minmax(Tfiresum');
sss=sprintf('Min max dla firesum: %d    %d',mm(1),mm(2));
disp(sss);

s=size(Tfire);
x0=rand(1,s(1));

if czyoptim
    Toptions1 = optimset('LargeScale','off','MaxFunEvals',60000,'Display','final','TolFun',1e-9,'LevenbergMarquardt','on','Jacobian','on','Diagnostics',...
        'off','TolX',1e-20,'DerivativeCheck','off','LineSearchType','quadcubic');
    [xfit,Qresnorm,Qresidual,Qexitflag,Qoutput]  = lsqnonlin(@Cobject,x0,[],[],Toptions1,Tfire,Tfiresum,tren);
    for a=1:length(x0) Tfis.output.mf(a).params=xfit(a);    end; disp('fis done')
end