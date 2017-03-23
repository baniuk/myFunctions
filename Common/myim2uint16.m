function [ out ] = myim2uint16( image )
%myim2uint8 Linearly scales image to unsigned 16 bits
%
% Inputs:
%     image           - image to scale
%   
% Outputs:
%    out              - scaled image
%
% Author: Piotr Baniukiewicz
% Email: p.baniukiewicz@warwick.ac.uk
%
% History:
%     08 Aug 2015 - Initial version
%
image = double(image);
mi = unique(min(image(:)));
out = image - mi;
ma = unique(max(out(:)));
out = out/ma;
out = round(out*65535);
out = uint16(out);


end

