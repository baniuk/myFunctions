function out = mFindDomainNumber(CP,P,E,I)
% Funkcja sprawdza wszystkie punkty z tablicy CP czy nale¿¹ do ktoregos
% trójk¹ta zdefiniowanego przez P i E. Jesli tak to zwraca indeks materialu
% tego trojkata.
% Zero na wyjsciu oznacza ze dany punkt nie nalezy do zadnego trojkata
% CP - punkty testowe [Px2]
% P - punkty wierzcholkow [2xN]
% E - indeksy wierzcholkow odpoiwdajace P [3xN]
% I - materialy odpowiadajace trojkatom [1xN]

% P, R, I pochodza z Comsola
% el = get(fem.mesh,'el');
% E = el{3}.elem;
% P = get(fem.mesh,'p');
% I = el{3}.dom;
% w el{3}.elem s¹ indeksy punktów z p dla których zdefiniowane sa trójk¹ty

% brak zabezpieczen

d = mexFindDomainNumber(CP,P,E,I);

% mapowanie tak aby mo¿na by³o u¿yæ bezpoœrednio w comsolu 
% equ.ind = mFind....
% cf musi mieæ tyle punktóe co domen w fem

for a=1:length(d)
    out(a) = find(d==a);
end
clear mexFindDomainNumber