function Genjpg(directory)
% funkcja konwertuje wszystkie obrazki *.tiff z katalogu do jpg
% dir - katalog to przerobienia. Jeœli [] to robi bierz¹cy

old = [];
if ~isempty(directory)
    old = cd;
    cd(directory);    
end
    
l = dir('*.tif');

for a=1:length(l);
    nazwa = l(a).name;
    nn = nazwa(1:end-4);
    disp([nn,'.jpg']);
    im = imread(nazwa);
    if numel(size(im))>2
        disp('not converted');
    else
        imc = imadjust(im);
        imc = uint8(round((double(imc)/65535)*255));   
        imwrite(imc,[nn,'.jpg'],'Quality',85);    
    end
end

if ~isempty(old)
    cd(old);
end



