function [out,J]=Cobject(x,fire,firesum,trn)

% fire=evalin('base','Tfireada');
% firesum=evalin('base','Tfireadasum');
% trn = evalin('base','trening752148260');
% trn = evalin('base','treningadapt');
si = size(fire);
st = size(trn);

wy = x*fire;
wy = wy'./firesum;
                                    % dla constat
out = wy'-trn(st(1),:);

if nargout > 1   % Two output arguments
    cps=repmat(firesum,1,si(1));
    J = fire'./cps;
end



