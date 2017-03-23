% struktura g³ówna dlacreatectackgui
% Cpomoc przechowuje zapis textowy

% przyk³ad
% >> config{1}=2                            % tego najwiecej
% >> config{2}=1                            % wada
% >> config{3}=[147 292];config{4}=3;
% >> config{5}=163;config{6}=5;
% >> config{7}=[194 338];config{8}=4;
% >> config{9}=225;config{10}=1;
% >> config{11}=266;config{12}=1;


Config{1} = 2; Cpomoc{1} = '2';
Config{2} = 1; Cpomoc{2} = '1';
Config{3} = 0; Cpomoc{3} = '0';
Config{4} = 0; Cpomoc{4} = '0';
Config{5} = 0; Cpomoc{5} = '0';
Config{6} = 0; Cpomoc{6} = '0';
Config{7} = 0; Cpomoc{7} = '0';
Config{8} = 0; Cpomoc{8} = '0';
Config{9} = 0; Cpomoc{9} = '0';
Config{10} = 0; Cpomoc{10} = '0';
Config{11} = 0; Cpomoc{11} = '0';
Config{12} = 0; Cpomoc{12} = '0';

crackstruct = struct('Ssizepointx',1,...
                        'Ssizepointy',1,...
                        'Ssizex',40,...
                        'Ssizey',10,...
                        'Config',[],...
                        'Cpomoc',[],...
                        'Step',1);
crackstruct.Config = Config;
crackstruct.Cpomoc = Cpomoc;
clear Config Cpomoc;
                        