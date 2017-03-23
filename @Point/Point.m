classdef Point
% Klasa implementuj¹ca punkt
    properties (SetAccess = public, GetAccess = public)
        x=0;
        y=0;
    end
    methods
        function obj = Point(x,y)
            if nargin==2
                obj.x = x;
                obj.y = y;
            end
        end    
   %----- odleg³osc 2 punktów ----------------------------------     
        function out = getPointDistance(obj,P0)
            if ~(isa(P0,'Point'))
               fprintf('P0 must be POINT class objects\n');
               return;
            end
            out = sqrt( (obj.x-P0.x).^2 + (obj.y-P0.y).^2);
        end
        function out = eq(obj1,obj2)
            if ~(isa(obj1,'Point') && isa(obj2,'Point'))
               fprintf('Operands must be: Point Class\n');
               return;
            end
            if obj1.x==obj2.x && obj1.y==obj2.y
                out = 1;
            else
                out = 0;
            end
        end
   %----- wyœwietlanie ---------------------------------- 
        function disp(obj)
            fprintf('\tPunkt\n\t[ %f;\n\t  %f ]\n',obj.x,obj.y);
         end
        function Plot(obj,MarkerEdgeColor,Marker,MarkerFaceColor,MarkerSize)
            hold on
            plot(obj.x,obj.y,'MarkerEdgeColor',MarkerEdgeColor,...
                'Marker',Marker,...
                'MarkerFaceColor',MarkerFaceColor,...
                'MarkerSize',MarkerSize);
            hold off
        end
    end    
end