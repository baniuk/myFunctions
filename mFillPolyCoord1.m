function [XY,out] = mFillPolyCoord1(V,im,N,czy_plot)
% Dla zadanych wspó³rzêdnych zwraca wspó³rzêdne punktów które zawieraj¹
% siêw tej figurze.
% figura musi byæ dana za pomoc¹ 4 wierzcho³ków abcd

% krawêdzie sa dzielone na t¹ sam¹ iloœæ punktów, nastêpnie punkty z ab i
% cd oraz bc i ad s¹ ³¹czone. Nastêpnie szukane sa punkty przeciêcia
% wszytkich prostych

% V - tablica [Nx2] wierzcho³ków w okreslonym kierunku
% N - iloœæ punktów na d³ugoœæ i szerokoœæ
% czy_plot - jesli 0 to bez rysunków
%XY - punkty dla których jest out

% addpath('../../dane/DVD_Inteligentny');

% N = 100;
% czy_plot = 1;
% im = imread('200_14.tif');

if(czy_plot)
    imshow(im,[])
end

% V=[5245 1181;   %ab
%    5445 1181;   %bc
%    5445 1293
%    5245 1293];  %da

if(czy_plot)
    hold on
    plot(V(:,1),V(:,2),'o')
end

PA = Point(V(1,1),V(1,2));
PB = Point(V(2,1),V(2,2));
PC = Point(V(3,1),V(3,2));
PD = Point(V(4,1),V(4,2));

L_AB = Line; L_AB = L_AB.DefineLine2Points(PA,PB);
L_BC = Line; L_BC = L_BC.DefineLine2Points(PB,PC);
L_CD = Line; L_CD = L_CD.DefineLine2Points(PD,PC);
L_DA = Line; L_DA = L_DA.DefineLine2Points(PA,PD);  % wa¿ny jest kierunek

if(czy_plot)
    L_AB.Plot('r',2,PA,PB)
    L_BC.Plot('r',2,PB,PC)
    L_CD.Plot('r',2,PC,PD)
    L_DA.Plot('r',2,PD,PA)
end

% podzia³ linii na t¹ sam¹ iloœæ punktów

P_L_AB = L_AB.getSection(PA,PB,N); 
P_L_BC = L_BC.getSection(PB,PC,N); 
P_L_CD = L_CD.getSection(PD,PC,N); 
P_L_DA = L_DA.getSection(PA,PD,N); 

% generowanie napryeciwlegzch linii
L_Pion = cell(1,N);
L_Poziom = cell(1,N);
for a=1:N
    tmp = Line;
    tP1 = Point(P_L_AB(a,1),P_L_AB(a,2));
    tP2 = Point(P_L_CD(a,1),P_L_CD(a,2));
    L_Pion{a} = tmp.DefineLine2Points(tP1,tP2);
    if(czy_plot), L_Pion{a}.Plot('b',1,tP1,tP2);hold on; end   
    
    tmp = Line;
    tP1 = Point(P_L_BC(a,1),P_L_BC(a,2));
    tP2 = Point(P_L_DA(a,1),P_L_DA(a,2));
    L_Poziom{a} = tmp.DefineLine2Points(tP1,tP2);
    if(czy_plot), L_Poziom{a}.Plot('b',1,tP1,tP2);hold on; end  
end

% punkty przeciêcia
XY = zeros(N*N,2);
licz = 1;
PP = cell(1,N*N);
for a=1:N
    for b=1:N
        PP{licz} = L_Pion{a}.LineCutLine(L_Poziom{b});
        XY(licz,:) = [PP{licz}.x PP{licz}.y];        
        licz = licz + 1;

    end
end

if(czy_plot)
    for a=1:N*N
        PP{a}.Plot('y','.','y',4);
    end
end

% aproxymacja
% wycinam tylko fragment obrazu
minXY = floor(min(minmax(XY')'));
maxXY = ceil(max(minmax(XY')'));

imtmp = double(im(minXY(2):maxXY(2),minXY(1):maxXY(1)));
[XX,YY] = meshgrid(minXY(1):maxXY(1),minXY(2):maxXY(2));

out = interp2(XX,YY,imtmp,XY(:,1),XY(:,2));
