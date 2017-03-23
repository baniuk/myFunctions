function out = scalepoly(vert,edges,len)
% funkcja skaluje wielkok�t dany jako vert [N,2] i edges [N+1,2] o warto��
% len. Wielok�t musi by� w kierunku wskaz�wek zegara zrobiony, je�li len
% jest + to powi�kszanie je�li - to zmniejszanie
% Warto�� len jest d�ugo�ci� wektora o kt�ry jest prze�wany dany
% wierzcho�ek. Nie jest to skala.

% na postawie kodu w progowanie


% skalowanie na wektorach
% budowanie wektor�w opisuj�cych kszta�t
V = cell(1,size(vert,1));
for e=1:size(vert,1)
    p0 = vert(edges(e,1),:); % pocz�tek
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

% wektory prostopad�e i osadzone w poczatkach
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

% dla ka�dego odcinka tworz�cego kszta�t wyznaczam nowe punkty ko�cowe. Dla punktu 1 b�dzie to punkt ko�cowy wektora
% prostopad�ego zaczepionego w tym punkcie, dla punktu ko�cowego 2, b�dzie to punkt ko�cowy wektora z punktu 1 zaczepionego w punkcie 2
VK = cell(1,length(V));
for e=1:length(V)   % po wektorach
    vp = VP{e}; % wektor prost, zaczepiony w pocz�tku wektora kszta�tu V
    p_konca = V{e}.getVectorEnd();  % koniec wektora kszta�u
    VK{e} = vp.NewP0(p_konca);         % wektor prost VP przesuni�ty do ko�ca    
end

% for e=1:length(VK)
%    VK{e}.Plot('y',1) 
% end

% sumowanie wektor�w 
% VP VK
% 1   N
% 2   1
% 3   2
% .....
% N   N-1 
% tablica przesuni�c na indeksach bo nie mo�na przes�wa� cell
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

% zbieranie punkt�w ko�cowych nowej figury
PK = cell(1,length(V));
vertk = zeros(length(V),2);
clear PK vertk
for e=1:length(VK)
   PK{e} = VS{e}.getVectorEnd();
   vertk(e,:) = [PK{e}.x PK{e}.y];
end


% hold on;plotFigure(vertk,edges);    % nowa powi�kszona figura zadana przez punkty 
% % PK lub vert, przy zachowanych edges z orygina�u
% axis square

out = vertk;