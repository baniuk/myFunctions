function out = DistributePlots(data,skala,plotfunction,varargin)
% Rysuje wykresy o tym samym wymiarze na ekranie rozk�adaj�c je r�wnomiernie
% data - dane w cell do narysowania. W pierwszej kom�rce zawsze dane,
% p�niej dowolne inne: {{dane,opis},{dane1,opis1}}
% skala - skala wykresu (od 0 do niesko�czono�ci)
% plotfunction - uchwyt do funkcji wywo�ywanej dla ka�dego
% wykresu - typowe rzeczy formatuj�ce
% zwraca uchwyty
% Funkcja plotfunction musi obslugiwac parametr 'pre' i zwracac aspect
% ratio dla tego parametru.
%             if isequal(data,'pre')
%                 varargout{1} = [9.5000   23.5000    1.0000];
%                 return;
%             end
% Funkcja plotfunction musi obslugiwac parametr 'size' i zwracac rozmiar obrazka - tylko dla wykres�w 2d 
%             if isequal(data,'size')
%                 varargout{1} = [100 200]
%                 return;
%             end


% function handles = PlotAllIndicators(fuzzy,dane,dx,skala)
% rysuje wykresy dla wszystkich wska�nik�w z dane obrobionych wg zasad
% fuzzy
% dx = [3 4] dla 8
% dx = [7 8] dla 16
% skala - wielkosc wykresu (0.1......
% 
% fi = fieldnames(dane);
% sfi = length(fi);
% licznik = 1;
% for a=1:sfi
%     t1 = findstr('m',fi{a});
%     t2 = findstr('Coryg',fi{a});
%     if ~isempty(t1) & ~isempty(t2)
%         pola{licznik} = fi{a};
%         licznik = licznik + 1;
%     end
% end
% 
% originalImage = dane.OriginalImage;
% imshow(originalImage,[]);
% licznik = 1;
% wyniki = cell(1,length(pola)*3);    % do funkcji distributeplots
% for aa=1:length(pola)
%     training = dane.(pola{aa});
%     si = size(training);
%     dx1 = dx(1); dx2 = dx(2); % przesuniecie wsporzednych w obrazku w stosunku do training
%     dy1 = dx(1); dy2 = dx(2); % dla rozmiaru 8x8
%     % skalowanie
%     mi = min(min(training));
%     training = training - mi;
%     ma = max(max(training));
%     training = training/ma;
%     a = evalfis(reshape(training,1,prod(si)),fuzzy); a = reshape(a,si(1),si(2));
%     so = size(originalImage);
%     oryg = originalImage(dy1:so(1)-dy2-1,dx1:so(2)-dx2-1);
%     modoryg = oryg+a.*oryg;
%     
%     wyniki{licznik} = {training,sprintf('%s tr',pola{aa})};
%     wyniki{licznik+1} = {modoryg,sprintf('%s norm',pola{aa})};
%     wyniki{licznik+2} = {imcomplement(modoryg),sprintf('%s neg',pola{aa})};
%     licznik = licznik + 3;  
%     
% end
% handles = DistributePlots(wyniki,1,@myplotfunction);

ile = length(data);
typwidth = 400*skala;
aspect = plotfunction('pre');
si = plotfunction('size');
if isempty(si)
    si = size(data{1}{1});
    height = round(typwidth*si(1)/si(2)*aspect(1)/aspect(2));
else
    height = round(typwidth*si(1)/si(2));
end
    

xs=0;
ys=30;


scrsz = get(0,'ScreenSize'); scrsz = scrsz(3:4);

for q=1:ile
    out(q) = figure('Position',[xs,ys,typwidth,height],'menubar','none');
    
    set(gca,'Position',[0 0 1 1])
    plotfunction(data{q});
    set(gca,'DataAspectRatio',aspect);
    xs = xs + typwidth+2;
    if xs>scrsz(1)-typwidth
        ys = ys + height+4;
        if ys>scrsz(1), fprintf('Za du�o wykres�w\n'); break; end
        xs = 0;
    end
end

