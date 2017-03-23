classdef Vector
    % klasa implementuj¹ca wektor
    properties (SetAccess = private, GetAccess = public)
        P0 = Point(0,0);  % pocz¹tek wektora
        VEC = [1;0];    % wspó³rzêdne wektora
    end
    properties (SetAccess = private, GetAccess = public)
        P1 = Point(1,0);  % koniec wektora  
    end
    properties (SetAccess = private, GetAccess = private)
        angle_in = 'radians'
    end
    methods
    %----- konstruktor -----------------------------------------
        function obj = Vector(P0,P1)
            if nargin==2
                if ~(isa(P0,'Point') && (isa(P1,'Point') || (isnumeric(P1) && length(P1)>1)) )
                    fprintf('P0 P1 must be POINT class objects\nor P0 must be point and P1 vector [lx;ly]\ndefining lengths\n');
                    return;
                end
                if isa(P0,'Point') && isa(P1,'Point') % konstrultor z dwóch punktów
                    obj.P0 = P0;
                    obj.P1 = P1;
                    obj.VEC = [P1.x-P0.x;P1.y-P0.y];
                elseif isa(P0,'Point') && (isnumeric(P1) && length(P1)>1) % konstruktor z punktu startowego i d³ugoœci
                    obj.P0 = P0;
                    if isrow(P1), P1 = P1'; end;
                    obj.VEC = P1;
                    obj = RecalculateEnd(obj);
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
        function out = getAngle(obj)
            switch obj.angle_in
                case 'radians'
                    disp('Angle is set to radians');
                case 'degrees'
                    disp('Angle is set to degrees');
            end
            out = obj.angle_in;
        end        
    %----- wyœwietlanie ---------------------------------- 
        function disp(obj)
            fprintf('\tWektor\n\t[ %f;\n\t  %f ]\n',obj.VEC(1),obj.VEC(2));
            fprintf('\tP0\n\t[ %f;\n\t  %f ]\n',obj.P0.x,obj.P0.y);
        end
    %----- Rysowanie -----------------------------------------    
        function Plot(obj,LineColor,LineWidth)
            hold on
            line([obj.P0.x;obj.P1.x],[obj.P0.y;obj.P1.y],'Color',LineColor,'LineWidth',LineWidth);
            obj.P0.Plot('r','o',LineColor,5);
            obj.P1.Plot('r','v',LineColor,5);
            hold off
        end
        function PlotSmall(obj,LineColor,LineWidth,MarkerSize)
            hold on
            line([obj.P0.x;obj.P1.x],[obj.P0.y;obj.P1.y],'Color',LineColor,'LineWidth',LineWidth);
            obj.P0.Plot([0.5 0.5 0.5],'o',LineColor,MarkerSize);
            obj.P1.Plot([0.5 0.5 0.5],'v',LineColor,MarkerSize);
            hold off
        end
    %----- Dodawanie podpisu ------------------------------    
        function AddLabel(obj,lab,fs)
            P0t = Point(0,0); P1t = Point(1,0);
            Vx = Vector(P0t,P1t);
            cp = getMiddlePoint(obj);
            text('position',[cp.x,cp.y],'string',num2str(lab),'FontSize',fs,...
                'VerticalAlignment','bottom',...
                'Rotation',getVectorsAngle(obj,Vx)*180/pi,...
                'BackgroundColor','white');
        end    
    %----- Nowy punkt przy³o¿enia ----------------------------   
        function obj = NewP0(obj,P0new)
            if ~(isa(P0new,'Point') || (isnumeric(P0new) && length(P0new)>1))
                fprintf('Operands must be Point Class or tab [x;y]\n');
                return;
            end

            if isa(P0new,'Point')
                obj.P0.x = P0new.x;
                obj.P0.y = P0new.y;
                obj = RecalculateEnd(obj);
            else
                P0tmp = Point(P0new(1),P0new(2));
                obj.P0 = P0tmp;
                obj = RecalculateEnd(obj);
            end

        end
    %----- Dodawanie -----------------------------------------
        function out = plus(obj1,obj2)
            if ~(isa(obj1,'Vector') && isa(obj2,'Vector'))
                fprintf('Operands must be VECTOR Class\n');
                return;
            end
            out = Vector(obj1.P0,obj1.VEC+obj2.VEC);
        end
    %----- Odejmowanie -----------------------------------------
        function out = minus(obj1,obj2)
            if ~(isa(obj1,'Vector') && isa(obj2,'Vector'))
                fprintf('Operands must be VECTOR Class\n');
                return;
            end
            out = Vector(obj1.P0,obj1.VEC-obj2.VEC);
        end
     %----- Iloczyn skalarny -----------------------------------------
        function out = mtimes(obj1,obj2)
            if ~(isa(obj1,'Vector') && isa(obj2,'Vector'))
                fprintf('Operands must be VECTOR Class\n');
                return;
            end
            out = obj1.VEC'*obj2.VEC;
        end  
    %----- Ustawianie d³ugoœci -----------------------------------------   
        function out = times(obj1,obj2)
            if ~(isa(obj1,'Vector') && (isnumeric(obj2) && length(obj2)<2))
               fprintf('Operands must be: VECTOR Class and scalar\n');
               return;
            end
            tt = (obj1.VEC./obj1.GetVectorLen)*obj2;
            out = Vector(obj1.P0,tt);
        end
    %----- D³ugoœæ -----------------------------------------
        function out = GetVectorLen(obj)
            out = sqrt(sum(obj.VEC.^2));        
        end
    %----- Ustawienie d³ugoœci----------------------------------
        function obj = SetVectorLen(obj,len)
            obj.VEC = (obj.VEC./obj.GetVectorLen)*len;
            obj = RecalculateEnd(obj);
        end
    %----- wsp koñca wektora ---------------------------------- 
        function out = getVectorEnd(obj)
            out = obj.P1;
        end
    %----- k¹t miêdzy wektorami ----------------------------------   
        function out = getVectorsAngle(obj,V1)
            if ~isa(V1,'Vector')
                fprintf('Operands must be VECTOR Class\n');
                return;
            end
            a = (obj*V1)/(obj.GetVectorLen*V1.GetVectorLen);
            
            switch obj.angle_in
                case 'radians'
                    out = acos(a);
                case 'degrees'
                    out = acos(a)*180/pi;
             end
        end
    %----- wektor prostopad³y osadzony w punkcie poczatkowym zgodny ze wskazówkami
        function out = getVectorPerpendicularCW(obj)
            P0tmp = obj.P0;
            P1tmp = [obj.VEC(2),-obj.VEC(1)];
                  
            out = Vector(P0tmp,P1tmp);
        end
    %----- wektor prostopad³y osadzony w punkcie poczatkowym przeciwny ze wskazówkami
        function out = getVectorPerpendicularCCW(obj)
            P0tmp = obj.P0;
            P1tmp = [-obj.VEC(2),obj.VEC(1)];
                  
            out = Vector(P0tmp,P1tmp);
        end
    %----- obracanie wektora o dowolny k¹t (jednostka zgodna z angle_in
        function out = getVectorRotated(obj,centre,angle)
            if ~isa(centre,'Point')
                fprintf('Operands must be POINT Class\n');
                return;
            end
            switch obj.angle_in
                case 'radians'
                    type = 'radians';
                case 'degrees'
                    type = 'degree';
            end
            XY = [  obj.P0.x obj.P0.y;
                    obj.P1.x obj.P1.y];
            center = [centre.x,centre.y];    
            rotated_coords = rotation(XY,center,angle,type);
            
            P0tmp = Point(rotated_coords(1,1),rotated_coords(1,2));
            P1tmp = Point(rotated_coords(2,1),rotated_coords(2,2));
            out = Vector(P0tmp,P1tmp);
        end    
    %----- zwraca œrodek wektora
        function out = getMiddlePoint(obj)
            s = [obj.P0.x+obj.P1.x obj.P0.y+obj.P1.y]/2;    
            out = Point(s(1),s(2));
        end     
    end
    methods (Access=private)
        function obj = RecalculateEnd(obj)
            obj.P1.x = obj.P0.x+obj.VEC(1);
            obj.P1.y = obj.P0.y+obj.VEC(2);
        end
        
        function rotated_coords = rotation(input_XY,center,anti_clockwise_angle,varargin)
            degree = 1; %Radians : degree = 0; Default is calculations in degrees

            % Process the inputs
            if ~isempty(varargin)
                for n = 1:1:length(varargin)
                    if strcmp(varargin{n},'degree') 
                        degree = 1;
                    elseif strcmp(varargin{n},'radians')
                        degree = 0;
                    end
                end
                clear n;
            end
            [~,c] = size(input_XY);
            if c ~= 2
                error('Not enough columns in coordinates XY ');
            end
            [r,c] = size(center);
            if (r~=1 && c==2) || (r==1 && c~=2)
                error('Error in the size of the "center" matrix');
            end

            % Format the coordinate of the center of rotation
            center_coord = input_XY;
            center_coord(:,1) = center(1);
            center_coord(:,2) = center(2);

            % Turns the angles given to be such that the +ve is anti-clockwise and -ve is clockwise
            anti_clockwise_angle = -1*anti_clockwise_angle;
            % if in degrees, convert to radians because that's what the built-in functions use. 
            if degree == 1 
                anti_clockwise_angle = deg2rad(anti_clockwise_angle);
            end

            %Produce the roation matrix
            rotation_matrix = [cos(anti_clockwise_angle),-1*sin(anti_clockwise_angle);...
                               sin(anti_clockwise_angle),cos(anti_clockwise_angle)];
            %Calculate the final coordinates
            rotated_coords = ((input_XY-center_coord) * rotation_matrix)+center_coord;
        end        
    end

end