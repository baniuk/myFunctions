function out = mFindDomainNumber(CP,P,E,I)
% Funkcja sprawdza wszystkie punkty z tablicy CP czy nale�� do ktoregos
% tr�jk�ta zdefiniowanego przez P i E. Jesli tak to zwraca indeks materialu
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
% w el{3}.elem s� indeksy punkt�w z p dla kt�rych zdefiniowane sa tr�jk�ty

% brak zabezpieczen

d = mexFindDomainNumber(CP,P,E,I);

% mapowanie tak aby mo�na by�o u�y� bezpo�rednio w comsolu 
% equ.ind = mFind....
% cf musi mie� tyle punkt�e co domen w fem

for a=1:length(d)
    out(a) = find(d==a);
end
clear mexFindDomainNumber