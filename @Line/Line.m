classdef Line
% Klasa implementuj¹ca linie
% dla pionowej, b = x
    properties (SetAccess = private, GetAccess = public)
        a = 0;
        b = 0;    
    end
    properties (SetAccess = private, GetAccess = public)
        % Jesli 1 to prosta pionowa
        pion = 0;
    end
    properties (SetAccess = private, GetAccess = private)
        angle_in = 'radians'
    end
    properties  (Constant)
        DEN = 100;
    end
    methods
 %----- konstruktor -----------------------------------------
        function obj = Line(a,b)
            if nargin==2
                obj.a = a;
                obj.b = b;
                if isnan(a)
                    obj.a = NaN;
                    obj.pion = 1;
                end
            end
        end
%------ zmienianie k¹tów -----------------------------------
        function obj = SetAnglesIn(obj,a)
            if strcmpi(a,'radians')
                obj.angle_in = 'radians';
            elseif strcmpi(a,'degrees')
                obj.angle_in = 'degrees';
            else
                fprintf('Use RADIANS or DEGREES\n');
                return;
            end
        end
%------ dostêp do typu --------------------------------------
        function out = get.angle_in(obj)
            switch obj.angle_in
                case 'radians'
                    disp('Angle is set to radians');
                case 'degrees'
                    disp('Angle is set to degrees');
            end
            out = obj.angle_in;
        end
%------ definicja linii na podstawie a i b -----------------
        function obj = DefineLine(obj,a,b)
            obj.a = a;
            obj.b = b;
            if isnan(a)
                obj.a = NaN;
                obj.pion = 1;
            end
        end
%------ obliczanie odcinka --------------------------------           
% oblicza wspó³rzêdne odcinka pomiêdzy P0 i P1 o gêstoœci den
% zwraca wektor [n,2], gdzie w pierwszej kolumnie x a w drugiej obliczony y
        function out = getSection(obj,P0,P1,den)
            if ~(isa(P0,'Point') && isa(P1,'Point'))
               fprintf('P0 P1 must be POINT class objects\n');
               return;
            end
            xx = linspace(P0.x,P1.x,den);
            yy = linspace(P0.y,P1.y,den);
            if obj.pion==1
                x = repmat(obj.b,den,1);
                out = [x yy'];
            else
                y = obj.a.*xx+obj.b;
                out = [xx' y'];
            end
        end
%------ obliczanie wartoœci --------------------------------   
% zwraca wektor [n,2], gdzie w pierwszej kolumnie x a w drugiej obliczony y
        function out = evalLine(obj,x)
            if obj.pion==1
                fprintf('Prosta pionowa\n');
                out = [obj.b,0];
            else
                if isrow(x), x = x';end
                out(:,1) = x;
                out(:,2) = obj.a.*x+obj.b;
            end
        end
%------ definicja linii przechodzacej przez P0 i P1 --------
        function obj = DefineLine2Points(obj,P0,P1)
            if ~(isa(P0,'Point') && isa(P1,'Point'))
               fprintf('P0 P1 must be POINT class objects\n');
               return;
            end
            if  (P1.x-P0.x)==0
                obj.a = NaN;
                obj.b = P0.x;
                obj.pion = 1;
            else
                obj.a = (P1.y-P0.y)/(P1.x-P0.x);
                obj.b = P0.y-obj.a*P0.x;
                obj.pion = 0;
            end
        end     
%------ Prosta równoleg³a i przechodz¹ca przez punkt --------     
        function out = getLineParallel(obj,P0)
            if ~(isa(P0,'Point'))
               fprintf('P0 must be POINT class objects\n');
               return;
            end
            out = Line;
            if obj.pion==1
               out = out.DefineLine(NaN,P0.x); 
            else
                atmp = obj.a;
                btmp = P0.y-atmp*P0.x;
                out = out.DefineLine(atmp,btmp);
            end
        end
%------ Prosta prostopad³a i przechodz¹ca przez punkt --------          
        function out = getLinePerpendicular(obj,P0) 
            if ~(isa(P0,'Point'))
               fprintf('P0 must be POINT class objects\n');
               return;
            end
            out = Line;
            if obj.a==0 % prosta pozioma, czyli prosta l bêdzie pionowa
                out = out.DefineLine(NaN,P0.x);
            elseif obj.pion==1  % prosta pionowa - bedzie pozioma
                out = out.DefineLine(0,P0.y);
            else
                atmp = -1/obj.a;
                btmp = P0.y-atmp*P0.x;
                out = out.DefineLine(atmp,btmp);                
            end
        end
%------ Przeciecie dwóch prostych--------------------------- --------   
% zwraca punkt przeciêcia albo []
        function out = LineCutLine(obj,L0)
           if ~(isa(L0,'Line'))
               fprintf('L0 must be LINE class objects\n');
               return;
            end
            if obj.pion==1 && L0.pion==1
                out = [];
            elseif obj.a==L0.a
                out = [];
            elseif obj.pion==1 && L0.pion~=1
                xtmp = obj.b;
                ytmp = L0.a*xtmp+L0.b;
                out = Point(xtmp,ytmp);
            elseif L0.pion==1 && obj.pion~=1
                xtmp = L0.b;
                ytmp = obj.a*xtmp+obj.b;
                out = Point(xtmp,ytmp);                
            else
                xtmp = (L0.b-obj.b)/(obj.a-L0.a);
                ytmp = obj.a*xtmp+obj.b;
                out = Point(xtmp,ytmp);
            end
            
        end
%------ Przeciecie prostej i odcinka P0P1--------------------------- --------   
% zwraca punkt przeciêcia albo []
        function out = LineCutSection(obj,P0,P1)
            if ~(isa(P0,'Point') && isa(P1,'Point'))
               fprintf('P0 P1 must be POINT class objects\n');
               return;
            end
            ltmp = Line;
            ltmp = ltmp.DefineLine2Points(P0,P1);
            O = ltmp.LineCutLine(obj);  % zwróci punkt przeciêcia z lini¹ przechodz¹c¹ przec P0P1. Trzeba teraz sprawdziæ czy punkt le¿y na odcinku
            if isempty(O)
                out = [];
            else
                X = [P0.x P1.x]; X = unique(X);
                Y = [P0.y P1.y]; Y = unique(Y);
                if O.x>=min(X) && O.x<=max(X) && O.y>=min(Y) && O.y<=max(Y)
                    out = O;
                else
                    out = [];
                end
            end
        end        
%------ Przeciecie prostej i okrêgu o œrodku P0 i promieniu R --------  
% Zwraca tablicê dwóch punktów
        function out = LineCutCircle(obj,P0,R)
            if ~(isa(P0,'Point'))
               fprintf('P0 must be POINT class objects\n');
               return;
            end
            Pout0 = Point;
            Pout1 = Point;
            if obj.pion==1
                Pout0.x = P0.x;
                Pout0.y = P0.y-R;
                Pout1.x = P0.x;
                Pout1.y = P0.y+R;
            else
                atmp = obj.a;
                Pout0.x = P0.x+R*sqrt(1/(atmp*atmp+1));
                Pout0.y = P0.y+R*atmp*sqrt(1/(atmp*atmp+1));
        		Pout1.x = P0.x-R*sqrt(1/(atmp*atmp+1));
                Pout1.y = P0.y-R*atmp*sqrt(1/(atmp*atmp+1));
            end
            out = [Pout0;Pout1];
        end
%----- wyœwietlanie ---------------------------------- 
        function disp(obj)
            if obj.pion==1
                fprintf('\tProsta pionowa\n');
            else
                fprintf('\tProsta\n');
            end
            fprintf('\ta = %f\n\tb = %f\n',obj.a,obj.b);
        end
%----- Rysowanie -----------------------------------------    
        function Plot(obj,LineColor,LineWidth,P0,P1)
            if isa(P0,'Point') && isa(P1,'Point')
                xx = linspace(P0.x,P1.x,obj.DEN);
                yy = linspace(P0.y,P1.y,obj.DEN);
            elseif isnumeric(P0) && length(P0)>1 && isnumeric(P1) && length(P1)>1
                xx = linspace(P0(1),P1(1),obj.DEN);
                yy = linspace(P0(2),P1(2),obj.DEN);
            else
               fprintf('P0 P1 must be POINT class objects or vectors [x;y]\n');
               return;
            end
            hold on
            if obj.pion==1
                x = obj.b;
                plot(repmat(x,1,length(yy)),yy,'Color',LineColor,'LineWidth',LineWidth);
            else
                y = obj.a.*xx+obj.b;
                plot(xx,y,'Color',LineColor,'LineWidth',LineWidth);
            end
            hold off
        end
        
        
        
    end
    
    
    
end

