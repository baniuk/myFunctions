function clearsmall;
% funkcja kasuje zmienne zaczynaj¹ce sie na male litery
vars = evalin('base','who');    % wczytanie zmiennych
lvars = length(vars);
varsL = lower(vars);
TF = strncmp(vars, varsL, 1);

for a=1:lvars
    if TF(a)
        str=sprintf('clear %s',vars{a});
        evalin('base',str);
    end
end

