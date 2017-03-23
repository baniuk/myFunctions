function varargout = createcrackgui(varargin)
% Graficzny interfejs do tworzenia wad
% varargin - sizepointx
%          - sizepointy
%          - sizex
%          - sizey
%          - 'stop' - zatrzymuje pobieranie danych
% INFO - maks dlugosc wady jest zdefiniowana w funkcjach click, plotgrid,
% updatepic, modifyfigure
%-----------------------Debug config---------------------------------------
global mode;
mode = 0;
%-----------------------End of Debug---------------------------------------

stopgetdata = 1;
persistent wada;
persistent wadaout;
persistent wadatlo;
kolorki;
%------------------------ Parametry konfiguracyjne ------------------------
if nargin==0
    sizepointx = 1e-3;           % rozmiar jedego punktu po osi x
    sizepointy = 1e-3;           % rozmiar jedego punktu po osi y
    sizex = 40e-3;               % d³ugoœæ obszaru rysowanego, rozmiar wady (maksymalny)
    sizey = 10e-3;               % gruboœæ obszaru rysowanego
end
switch varargin{1}
    case 'clear'
        % varargin:
        %       2 - gcfhandle
        %       3 - [sizepointx sizepointy]
        %       4 - [sizex,sizey]
        % varargout - zwraca wyczyszczon¹ macerz wady
        gcfHandle = varargin{2};
        sizepoints = varargin{3};
        sizes = varargin{4};
        updatepic(gcfHandle,sizepoints,sizes,kolory(1,:),ones(sizes(2)/sizepoints(2),sizes(1)/sizepoints(1)));
        wada = zeros(sizes(2)/sizepoints(2),sizes(1)/sizepoints(1));
        wadatlo = zeros(sizes(2)/sizepoints(2),sizes(1)/sizepoints(1));
        wadaout = wada;
        varargout{1} = wadaout;
        varargout{2} = wadatlo;
    case 'new'
        % varargin:
        %       2 - [sizepointx sizepointy]
        %       3 - [sizex,sizey]
        %       4 - wada (opcjonalnie)
        % varargout - zwraca uchwyt do wykresu
        sizepoints = varargin{2};
        sizes = varargin{3};
        numpoints = sizes./sizepoints;
        if nargin<4
            wada = zeros(numpoints(2),numpoints(1));      % podstawowa macierz trzymaj¹ca zarys wady (0-1)
        else
            wada = varargin{4};
        end
        wadatlo = zeros(numpoints(2),numpoints(1));
        gcfHandle = figure;
        varargout{1} = gcfHandle;
        plotgrid(gcfHandle,sizepoints,sizes);
        updatepic(gcfHandle,sizepoints,sizes,kolory(2,:),wada);
        modifyfigure(gcfHandle,sizepoints,sizes);
    case 'update'
        % varargin:
        %       2 - gcfhandle
        %       3 - [sizepointx sizepointy]
        %       4 - [sizex,sizey]
        %       5 - wada 
        % varargout 1 - uchwyt jesli otwierany
        %           2 - 1 jesli otwierany
        gcfHandle = varargin{2};
        sizepoints = varargin{3};
        sizes = varargin{4};
        numpoints = sizes./sizepoints;
        wadatlo = varargin{5};
        if ~ishandle(gcfHandle)
            gcfHandle = figure;
            plotgrid(gcfHandle,sizepoints,sizes);
            varargout{1} = gcfHandle;
            varargout{2} = 1;
        else
            varargout{2} = 0;
        end
        updatepic(gcfHandle,sizepoints,sizes,kolory(3,:),wadatlo);
        return
    case 'cont'
        % varargin:
        %       2 - gcfhandle
        %       3 - [sizepointx sizepointy]
        %       4 - [sizex,sizey]
        %       5 - wadatlo
        % varargout 1 - uchwyt jesli otwierany
        %           2 - wada
        gcfHandle = varargin{2};
        sizepoints = varargin{3};
        sizes = varargin{4};
        wadatlo = varargin{5};
        numpoints = sizes./sizepoints;
        wada = zeros(numpoints(2),numpoints(1));
        modifyfigure(gcfHandle,sizepoints,sizes);
%         updatepic(gcfHandle,sizepoints,sizes,kolory(3,:),wadatlo);
end

%------------------ End of Parametry konfiguracyjne -----------------------


while stopgetdata
    wadaout = click(gcfHandle,sizepoints,sizes,kolory,wada,wadatlo);
    if isempty(wadaout)         % jesli pusty to byl stop
        stopgetdata = 0;
        wadaout = wada;         % ostatni dobry
        varargout{2} = wadaout; % 1 to gcfhandle
    else
        wada = wadaout;
    end
end

% wadaout = cutwada(wadaout);

function updatepic(gcfHandle,sizepoints,sizes,kolor,wada)
% funkcja transformuje macierz wady na parametry dla polecenia fill i
% updatuje rysunek wady
% - wada            - macierz stanu zmodyfikowana
% - gcfHandle       - uchwyt do wykresu
% - sizepoints      - rozmiar punktów jako wektor [sizepointx sizepointy]
% - size            - d³ugoœæ obszaru jako wektor [sizex sizey]
% - kolor          - kolor w jakim ma byæ zamalowane (umo¿liwia tworzenie
%                       zarówno podkladu jak i wady i czyszczenie
%-----------------------Debug config---------------------------------------
global mode;
%-----------------------End of Debug---------------------------------------

% zastapienie rozmiarów stalonymi wczesniej (zawsze takie samo okenko)
sizepoints  = [1 1];
sizes       = [40 10];
% -------------------------------------------------------------------------

hold(get(gcfHandle,'CurrentAxes'),'on');
set(gcfHandle,'CurrentAxes',get(gcfHandle,'CurrentAxes')) 
[y,x] = find(wada==1);        % gdzie zamalowaæ (musi byc odwrotnie)
x = x - 1; y = y - 1;
ilezamalowac = length(x);
if ilezamalowac~=0
    rect = [x*sizepoints(1) x*sizepoints(1) x*sizepoints(1)+sizepoints(1) x*sizepoints(1)+sizepoints(1);...
        y*sizepoints(2) y*sizepoints(2)+sizepoints(2) y*sizepoints(2)+sizepoints(2) y*sizepoints(2)];
    for a=1:ilezamalowac
        fill(rect(a,:),rect(a+ilezamalowac,:),kolor,'Parent',get(gcfHandle,'CurrentAxes'));
    end
end
hold(get(gcfHandle,'CurrentAxes'),'off');

function wadaout = click(gcfHandle,sizepoints,sizes,kolory,varargin)
% wywo³ywana po klikniêciu mysz¹ na wykresie. Zapala lub wygasza kwadrat
% - wadaout         - macierz stanu zmodyfikowana
% - varargin        - pierwszy to wada bez modyfikacji, nastêpne to
%                       podk³ady
% - gcfHandle       - uchwyt do wykresu
% - sizepoints      - rozmiar punktów jako wektor [sizepointx sizepointy]
% - size            - d³ugoœæ obszaru jako wektor [sizex sizey]
% - kolory          - macierz 3x3 w rzedach kolory dla kolejno: pusty,
%                       zamalowany, podklad
%-----------------------Debug config---------------------------------------
global mode;
%-----------------------End of Debug---------------------------------------
numpoints = sizes./sizepoints;
% zastapienie rozmiarów stalonymi wczesniej (zawsze takie samo okenko)
sizepoints  = [1 1];
sizes       = [40 10];
% -------------------------------------------------------------------------
pusty = kolory(1,:);
zamalowany = kolory(2,:);
podklad = kolory(3,:);
wada = varargin{1};
wadatlo = varargin{2};
wadaout = wada;
[rect xclick yclick] = getposition(sizepoints,sizes);
if (yclick>sizes(1)/sizepoints(1))||(xclick>sizes(2)/sizepoints(2))
    wadaout = [];
    return;
end
if xclick>numpoints(2)
    return
end
hold(get(gcfHandle,'CurrentAxes'),'on');
if wada(xclick,yclick)==1
    if wadatlo(xclick,yclick)==0
        fill(rect(1,:),rect(2,:),pusty,'Parent',get(gcfHandle,'CurrentAxes'));
    else
        fill(rect(1,:),rect(2,:),podklad,'Parent',get(gcfHandle,'CurrentAxes'));
    end
    wadaout(xclick,yclick)=0;
elseif wada(xclick,yclick)==0
    fill(rect(1,:),rect(2,:),zamalowany,'Parent',get(gcfHandle,'CurrentAxes'));
    wadaout(xclick,yclick)=1;
end
hold(get(gcfHandle,'CurrentAxes'),'off');

function [rectout, xclick, yclick] = getposition(sizepoints,sizes)
% funkcjia pobiera jedna wspolrzedna z wykresu na skutek klikniecia i
% zwraca:
% - rectout         - macierz 2-kolumnowa bedaca parametrami kwadraty do zamalowania do
%                       funkcji fill [X Y]: fill(rect(1,:),rect(2,:),'r');
% - xclick          - numer kliknietego kwadratu po x
% - yclick          - numer kliknietego kwadratu po y
% - sizepoints      - rozmiar punktów jako wektor [sizepointx sizepointy]
% - size            - d³ugoœæ obszaru jako wektor [sizex sizey]
[x,y] = ginput(1);

rectout = [floor(x/sizepoints(1))*sizepoints(1) floor(x/sizepoints(1))*sizepoints(1) floor(x/sizepoints(1))*sizepoints(1)+sizepoints(1) floor(x/sizepoints(1))*sizepoints(1)+sizepoints(1);...
    floor(y/sizepoints(2))*sizepoints(2) floor(y/sizepoints(2))*sizepoints(2)+sizepoints(2) floor(y/sizepoints(2))*sizepoints(2)+sizepoints(2) floor(y/sizepoints(2))*sizepoints(2)];
yclick = floor(x/sizepoints(1))+1;
xclick = floor(y/sizepoints(2))+1;


function plotgrid(gcfHandle,sizepoints,sizes)
% Rysowanie siatki punktów na wykresie

% - gcfHandle       - uchwyt do wykresu na którym ma byæ rysowanie
% - sizepoints      - rozmiar punktów jako wektor [sizepointx sizepointy]
% - size            - d³ugoœæ obszaru jako wektor [sizex sizey]

%-----------------------Debug config---------------------------------------
global mode;
%-----------------------End of Debug---------------------------------------

% zastapienie rozmiarów stalonymi wczesniej (zawsze takie samo okenko)
sizepoints  = [1 1];
sizes       = [40 10];
% -------------------------------------------------------------------------

basesize = 700;     % rozamiar d³u¿szego boku okienka
fs = 5;             % fontsize dla ticks
fs1 = 10;           % fontsize dla labels
stopget =  sizepoints;  % romiar pola stopu
sizes = sizes + stopget;

numpoints = sizes./sizepoints;   % iloœæ punktów jako wektor [numx numy]
set(0,'Units','normalized');     % rozmiar ekranu 0-1
screensize = get(0,'ScreenSize');

set(gcfHandle,'Position',[50 50 basesize-basesize*0.06 basesize*sizes(2)/sizes(1)]); % rozpatrywaæ razem z 'Position' axis
gcaHandle = get(gcf,'CurrentAxes');
if isempty(gcaHandle)                       % jeœli figura bez osi to tworzenie ich
    gcaHandle = axes;
end
set(gcaHandle,'Position',[0.017 0.07 1-0.017 1-0.09]);
set(gcfHandle,'MenuBar','none');
set(gcfHandle,'Name','Crack profile');
set(gcfHandle,'Resize','off');
set(gcaHandle,'XLim',[0 sizes(1)],'YLim',[0 sizes(2)]);   % limity na osiach
set(gcaHandle,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1]);
set(gcaHandle,'XTick',[0:sizepoints(1):sizes(1)],'YTick',[0:sizepoints(2):sizes(2)]);
set(gcaHandle,'XTickLabel',{[0:sizepoints(1):sizes(1)-stopget(2)]*sizepoints(1)^-1,''},...
    'YTickLabel',{[0:sizepoints(2):sizes(2)-stopget(2)]*sizepoints(2)^-1,''});
set(gcaHandle,'box','on');
set(gcaHandle,'XGrid','on','YGrid','on','GridLineStyle','-');
set(gcaHandle,'FontSize',fs);
set(gcaHandle,'YDir','reverse');


hold(get(gcfHandle,'CurrentAxes'),'on');
rect = [sizes(1)-stopget(1) sizes(1)-stopget(1) sizes(1) sizes(1); 0 sizes(2) sizes(2) 0];
fill(rect(1,:),rect(2,:),[1 1 0],'Parent',get(gcfHandle,'CurrentAxes'));      % pionowy stop
rect = [0 0 sizes(1)-stopget(1) sizes(1)-stopget(1); sizes(2) sizes(2)-stopget(2) sizes(2)-stopget(2) sizes(2)];
fill(rect(1,:),rect(2,:),[1 1 0],'Parent',get(gcfHandle,'CurrentAxes'));      % poziomy stop
hold(get(gcfHandle,'CurrentAxes'),'off');
text((sizes(1)-stopget(2))/2,sizes(2)-stopget(2)+sizepoints(2)/2,'S T O P   F I E L D','FontSize',10)


function modifyfigure(gcfHandle,sizepoints,sizes,varargin)
% funkcja modyfikuje bierz¹cy wykres
if sizes(2)<10
    numpoints = sizes./sizepoints;
    hold(get(gcfHandle,'CurrentAxes'),'on');
    line([0,numpoints(1)],[numpoints(2) numpoints(2)],'LineWidth',2,'Color',[0.8 0.5 1],...
        'Parent',get(gcfHandle,'CurrentAxes'));
    hold(get(gcfHandle,'CurrentAxes'),'off');
end