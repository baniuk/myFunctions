function out = scalepoly(vert,edges,len)
% funkcja skaluje wielkok¹t dany jako vert [N,2] i edges [N+1,2] o wartoœæ
% len. Wielok¹t musi byæ w kierunku wskazówek zegara zrobiony, jeœli len
% jest + to powiêkszanie jeœli - to zmniejszanie
% Wartoœæ len jest d³ugoœci¹ wektora o który jest przeówany dany
% wierzcho³ek. Nie jest to skala.

% na postawie kodu w progowanie


% skalowanie na wektorach
% budowanie wektorów opisuj¹cych kszta³t
V = cell(1,size(vert,1));
for e=1:size(vert,1)
    p0 = vert(edges(e,1),:); % pocz¹tek
    p1 = vert(edges(e,2),:); % koniec
    P0 = Point(p0(1),p0(2));
    P1 = Point(p1(1),p1(2));
    
    V{e} = Vector(P0,P1);
    
end

% rysowanie
% figure;grid on
% for e=1:length(V)
%    V{e}.Plot('g',2) 
% end

% wektory prostopad³e i osadzone w poczatkach
VP = cell(1,length(V));

if len>0
    for e=1:length(V)
       VP{e} = V{e}.getVectorPerpendicularCW(); 
       VP{e} = VP{e}.SetVectorLen(abs(len));
    end
else
    for e=1:length(V)
       VP{e} = V{e}.getVectorPerpendicularCCW(); 
       VP{e} = VP{e}.SetVectorLen(abs(len));
    end
end

% hold on
% for e=1:length(VP)
%    VP{e}.Plot('r',1) 
% end

% dla ka¿dego odcinka tworz¹cego kszta³t wyznaczam nowe punkty koñcowe. Dla punktu 1 bêdzie to punkt koñcowy wektora
% prostopad³ego zaczepionego w tym punkcie, dla punktu koñcowego 2, bêdzie to punkt koñcowy wektora z punktu 1 zaczepionego w punkcie 2
VK = cell(1,length(V));
for e=1:length(V)   % po wektorach
    vp = VP{e}; % wektor prost, zaczepiony w pocz¹tku wektora kszta³tu V
    p_konca = V{e}.getVectorEnd();  % koniec wektora kszta³u
    VK{e} = vp.NewP0(p_konca);         % wektor prost VP przesuniêty do koñca    
end

% for e=1:length(VK)
%    VK{e}.Plot('y',1) 
% end

% sumowanie wektorów 
% VP VK
% 1   N
% 2   1
% 3   2
% .....
% N   N-1 
% tablica przesuniêc na indeksach bo nie mo¿na przesówaæ cell
K = [ [1:length(V)]' circshift( [1:length(V)]',1)];
% sumowanie
VS = cell(1,length(V));
for e=1:length(V)
    VS{e} = VP{K(e,1)} + VK{K(e,2)};
    VS{e} = VS{e}.SetVectorLen(abs(len));
end

% for e=1:length(V)
%    VS{e}.Plot('m',1) 
% end

% zbieranie punktów koñcowych nowej figury
PK = cell(1,length(V));
vertk = zeros(length(V),2);
clear PK vertk
for e=1:length(VK)
   PK{e} = VS{e}.getVectorEnd();
   vertk(e,:) = [PK{e}.x PK{e}.y];
end


% hold on;plotFigure(vertk,edges);    % nowa powiêkszona figura zadana przez punkty 
% % PK lub vert, przy zachowanych edges z orygina³u
% axis square

out = vertk;