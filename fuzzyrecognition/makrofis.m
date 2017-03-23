function [Tmf,Tfis,Tfire,Tfiresum,x0]=makrofis(numwe,nummf,tren,przec,varargin)
% ta funkcja dziala jak makro wywolujac funkcje skladowe potrzebne do
% zrobienia kompetnej struktury fis
% pobiera: ilosz wejsc, ilosc mf, dane treningowe, przeciecie mf
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
    Tmf=createmf(numwe,nummf,tren,przec);   disp('MF done')
end

[Tfis Trule computedmf]=makefiscompl(numwe,nummf,Tmf,tren);    disp('fis & rule done')
Tfire=calcfire(numwe,nummf,Tmf,tren,Trule,computedmf);         disp('fire done')

Tfiresum=sum(Tfire)';
mm=minmax(Tfiresum');
sss=sprintf('Min max dla firesum: %d    %d',mm(1),mm(2));
disp(sss);

s=size(Trule);
x0=rand(1,s(1));

if czyoptim
    Toptions1 = optimset('LargeScale','off','MaxFunEvals',60000,'Display','final','TolFun',1e-9,'LevenbergMarquardt','on','Jacobian','on','Diagnostics',...
        'off','TolX',1e-20,'DerivativeCheck','off','LineSearchType','quadcubic');
    [xfit,Qresnorm,Qresidual,Qexitflag,Qoutput]  = lsqnonlin(@object,x0,[],[],Toptions1,Tfire,Tfiresum,tren);
    for a=1:length(x0) Tfis.output.mf(a).params=xfit(a);    end; disp('fis done')
end