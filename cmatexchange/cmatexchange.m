function out = cmatexchange(varargin)
% interface pomi�dzy c i matlabem
% mode          - write, read
% file          - filename
% data          - macierz do nagrania
% Je�eli data jest macierz� 3D to poszczeg�lne warstwy s� nagrywane w
% kolejnych podmacierzach.
% zapis 
%   cmatexchange('mode','write','file','test','data',b);
% odczyt
%   out=cmatexchange('mode','read','file','test');
%   je�li macierze s� r�ne to zwraca w cell
% default
mode = 'read';
file = 'test';

numofparam = nargin;
if (mod(nargin,2)~=0)||(numofparam==0)
    fprintf('Bad number of params\n');
    return;
end
for p=1:2:numofparam
    param = varargin{p};
    switch param
        case 'mode'
            mode = varargin{p+1};
        case 'file'
            file = varargin{p+1};
        case 'data'
            data = varargin{p+1};
        otherwise
            fprintf('Bad param\n');
            return;
    end
end

switch mode
    case 'write'
        if iscell(data)
            myio('writecell',file,data,0);
        else
            myio('write',file,data,0);
        end
    case 'read'
        nom = myio('GETNUMOFMATRIX',file,0,0);
        for w=1:nom
            out{w} = myio('read',file,0,w);
            ss(w,:) = size(out{w});
        end
        mr = max(max(ss(:,1)));
        mc = max(max(ss(:,2)));
        if isempty(find(ss(:,1)~=mr))
            if isempty(find(ss(:,2)~=mc))
                for w=1:nom
                    outtmp(:,:,w) = out{w};
                end
                out = outtmp;
            end
        end
        
end
        