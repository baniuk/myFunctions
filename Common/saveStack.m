function saveStack( filename, data )
%SAVESTACK Saves stack to file
% Saves 3D matrix as stack of images. Input required in uint8 or uint16.
% For 16 bits format proper extension of output file is required
%
% Inputs:
%     filename           - name of output file with extension
%     data               - 2D or 3D matrix of uint data
%   
% Usage:
%     name = 'stack.tif';
%     dirname = '/home/user';
%     out = uint8(255*rand(512,512,200));
%     saveStack(fullfile(dirname,name),out);
%
% Author: Piotr Baniukiewicz
% Email: p.baniukiewicz@warwick.ac.uk
%
% History:
%     08 Oct 2015 - Initial version

if ~(isequal(class(data),'uint8') || isequal(class(data),'uint16'))
    error('Data must be in uint8 format');
end

for i=1:size(data,3)
    slice = data(:,:,i);
    if i==1
        imwrite(slice,filename);
    else
        imwrite(slice,filename,'WriteMode','append');
    end
end

end

