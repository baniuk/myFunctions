function Outmy=myevalfis(data,fis)
Ilpar = length(fis.input(1).mf(1).params);  % ilosc parametrów do jednej mf
Ilwe = length(fis.input);   % ilosc wejsc
Ilmf = length(fis.input(1).mf);   % ilosc mf na wejœcie
Ilrule = length(fis.rule);
Ilparwy = Ilwe+1;  % iloscparametrów fcj liniowej = ilwe+1
Ilpartren = size(data,1); Ilpartren = Ilpartren(1);    % ilosc par tren

% uzyskanie macierzy z MF
% Format macierzy: rzedy wejœcia, kolumny kolejne parametry dla mf
%                   MF1we1par1 MF1we1par2 MF2we1par1 MF2we1par2

for we=1:Ilwe
    clear tmp
    for mf=1:Ilmf
        tmp(mf,:) = fis.input(we).mf(mf).params;
    end
    MF(we,:) = reshape(tmp',1,Ilmf*Ilpar);
end
% uzyskanie macierzy z out

for r=1:Ilrule
    Rule(r,:) = fis.output.mf(r).params;
end
% Solve
% obliczanie wartoœci mf dla kazdego wejscia i pary
% MFval = w rzedach wartoœci dla kolejnych ewjœci dla jednej pary
% treningowej. W kolumnach wartoœci dla kolejnych mf poszczegolnych wejsc

for para=1:Ilpartren
    for we=1:Ilwe
        ktora = 1;      % ktora mf
        for mf=1:Ilmf
            MFval(we,mf,para) = prvgaussmf(data(para,we),MF(we,ktora:ktora+Ilpar-1));
            ktora = ktora + Ilpar;
        end
    end
end
% rules
% generacja wariancji

for i=1:Ilrule
    Rules(i,:) = fis.rule(i).antecedent;
end

% obliczanie fire ka¿dej z regol (and = prod)
Fire = ones(Ilrule,Ilpartren);
for para=1:Ilpartren
    for r=1:Ilrule
        for we=1:Ilwe
            Fire(r,para) = Fire(r,para)*MFval(we,Rules(r,we),para);
        end
    end
end
% output
% out = a*we1+b*we2+c
we = data(:,1:Ilwe);
if size(Rule,2)<2
    wolny = Rule';
    Outrule = repmat(wolny,Ilpartren,1);
else
    wolny = Rule(:,Ilparwy)';
    wsp = Rule(:,1:Ilparwy-1)';
    Outrule = we*wsp+repmat(wolny,Ilpartren,1);
end
% clearsmall;

% out

Outmy = diag(Fire'*Outrule')./sum(Fire)';

function y = prvgaussmf(x, params)

if nargin ~= 2
    error('Two arguments are required by the Gaussian MF.');
elseif length(params) < 2
    error('The Gaussian MF needs at least two parameters.');
elseif params(1) == 0,
    error('The Gaussian MF needs a non-zero sigma.');
end

sigma = params(1); c = params(2);
y = exp(-(x - c).^2/(2*sigma^2));