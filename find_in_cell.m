function out = find_in_cell(in,co)
% funkcja znajduje co w cell i zwraca indeksy. Przystosowana do 1D

% disp('Funkcja do wektorow tylko');

out = [];
licz = 1;
for a=1:length(in)
    if isequal(in{a},co)
        out(licz) = a;
        licz = licz + 1;
    end
end