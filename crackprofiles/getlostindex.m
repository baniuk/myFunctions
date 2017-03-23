function varargout = getlostindex(name,roz,pak,varargin)
% zwraca brakujace pliki o nazwie: name_1_2_..., gdzie 1,2,..to kolejne
% varargin. W varargin s¹ wektory tego co powinno byæ
% varargout - kolejne indeksy brakuj¹ce dla odpowiednich varargin. [] jesli
% nic nie brakuje
% roz - rozszerzenie pliku (mat, fl)
% archivizer (rar,zip) Gdy [] to ni pakowane


inputs = nargin-1;
if inputs>5
    disp('Too many inputs. Only two levels supported!!')
    return
end
m1 = varargin{1};       lm1 = length(m1);   % 1 lewel
m2 = varargin{2};       lm2 = length(m2);   % 2 lewel
currentdir = cd;
licznik = 1;
outm1 = [];
outm2 = [];
for a = 1:lm1
    for b = 1:lm2
        if isempty(pak)
            nazwa = sprintf('%s_%d_%d.%s',name,m1(a),m2(b),roz);
        else
            nazwa = sprintf('%s_%d_%d.%s.%s',name,m1(a),m2(b),roz,pak);
        end
        nazwafull = fullfile(currentdir,nazwa);
        if ~exist(nazwafull,'file')
            outm1(licznik) = m1(a);
            outm2(licznik) = m2(b);
            licznik = licznik + 1;
        end
    end
end

varargout{1} = outm1;
varargout{2} = outm2;
            


