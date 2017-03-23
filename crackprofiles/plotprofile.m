function plotprofile(in,varargin)
% funkcja wchodzi w sklad pakietu do tworzenia wad. Rysuje profil wady
% in - struktura
% varargin  - parametry:
%           'smooth',x - wyg³adzanie z oknem x

licz = 1;
czysmooth = 0;
if nargin>1
    while licz<=nargin-1
        arg = varargin{licz};
        switch arg
            case 'smooth'
                czysmooth = 1;
                parsmooth = varargin{licz+1};
                licz = licz + 2;
        end
    end
end
fs = 14;

rozmiarx = in.param{4}(1);
rozmiary = in.param{4}(2);
oznaczx = [0:4:rozmiarx];
oznaczy = [0 0.6250 1.25];
punktx = in.param{5}(1);
punkty = in.param{5}(2);

wada = in.param{6};
wada = wada;

sw = length(wada);
w = zeros(1,rozmiarx);
w(round(rozmiarx/2)-round(sw/2):round(rozmiarx/2)+round(sw/2)-1) = wada;
xfill=[0 0 rozmiarx rozmiarx];
yfill=[0 rozmiary rozmiary 0];

if czysmooth
    w = smooth(w,parsmooth,'rlowess')';
end
xfillw = 1:rozmiarx;

fill(xfill,yfill,[0.9 0.9 0.9],xfillw,rozmiary-w,[0.6 0.6 0.6]);


set(gca,'DataAspectRatioMode','manual','DataAspectRatio',[1 0.25 1],'xtick',oznaczx,'ytick',oznaczy,'FontSize',fs);
set(gca,'yticklabel',fliplr(oznaczy)/rozmiary*100,'FontSize',fs);
set(gca,'xticklabel',oznaczx*punktx,'FontSize',fs);
xlabel('Pozycja sensora [mm]','FontSize',fs);
ylabel('D [%]','FontSize',fs);
mw = max(wada);
str = sprintf('L = %s [mm], D = %s [%%]',num2str(sw*punktx),num2str(mw(1)*100/rozmiary));
title(str)