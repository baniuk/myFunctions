function [ dImage_rotcutg ] = DifferentiateImage( imagein, varargin )
%DifferentiateImage Calculate differential image from original
%   Perform differentiation on selected angle up or reverse
% DICReconstructionLID_MD method.

% Inputs:
%     imagein           - image to reconstruct. Can be square or
%                         rectangular
%     'down'            - indicates that gradient is calculated from end of
%                         diagonal to its beginning.
%     'up'              - indicates that gradient is calculated from beginning of
%                         diagonal to its end.
%     'angle',[value]   - define shear angle of image. Default value is -45
%                         deg.
%   
% Outputs:
%    dImage_rotcut      - gradient image of size of input image
%
% Usage:
%     im = DifferentiateImage(rImage,'up','angle',45);
%
% Dependencies:
%     Image Processing Toolbox
%
% Author: Piotr Baniukiewicz
% Email: p.baniukiewicz@warwick.ac.uk
%
% History:
%     30 Jul 2015 - Initial version
%
% BUG Can not work for 0 90 180 degrees - problem with cutting final image defaults
% BUG output values differ in position from those from

angle = -45; % shear angle, can be 45 or -45. For positive value we flip image firs
direction = 'down'; % differentiation from begin to end or vice-versa

% decode input arguments
i = 1;
try
    while(i<=length(varargin))
        switch varargin{i}
            case 'down'
                direction = varargin{i};
                i = i+1;
            case 'up'
                direction = varargin{i};
                i = i+1;
            case 'angle'
                angle = varargin{i+1};
                assert(isnumeric(angle),'angle must be numeric');
                i = i+2;    
            otherwise
                error('Unknown option');
        end
    end
catch exception
    error(['Wrong input parameters: ',exception.message]);
end

% converting input image to double 
% WARNING may be not necessary for GPU processing
imagein = double(imagein);

% flipping image if angle is positive and changing it to negative
if angle>0
    imagein = fliplr(imagein);
    angletmp = -angle;
else
    angletmp = angle;
end
delta = (65535 + abs(min(imagein(:))));
% add bias
rObject_mean = imagein+delta;
% perform rotation
rObject_rot = imrotate(rObject_mean,angletmp,'nearest');
% prepare gradient image
dImageg = zeros(size(rObject_rot));

% get only columns
[rows, cols] = size(rObject_rot);

% TODO Think about NaNs here and process the whole matrix without for if
% possible
parfor d=1:cols % for every diagonal
    Y = rObject_rot(:,d)';
    % find real data indexes (no padded pixels). Image pixels have values
    % grater than 0
    real_ind = find(Y>=min(rObject_mean(:)));
    % may happen that there will not be any image pixel in column (because
    % of rotation and approximation)
    if isempty(real_ind) || length(real_ind)<5
        continue;
    end
    % revert back to original image pixels
    Yreal = Y(real_ind)-delta;
    if isequal(direction,'down')
        % we are on given diagonal - perform backward differentiation
        Ig = fliplr(gradient(fliplr(Yreal)));
    else
        Ig = gradient(Yreal);
    end
    % padding with zeros to make the same size as rotated original (needed
    % by parfor)
    dImageg(:,d) = [zeros(1,real_ind(1)-1) Ig zeros(1,rows-real_ind(end))];
end

dImage_rotg = imrotate((dImageg),-angletmp,'nearest','crop');
% cut extra borders - we are sure that there is nothing interesting there
% because they were added by imrotate
% size of extra borders
[rows, cols] = size(rObject_mean);
deltas = size(dImage_rotg) - [rows cols];
% if rotated on 0, 90, ... we must deal with 0 delta and also 0 indexing 
deltas(deltas==0) = 1;

dImage_rotcutg = dImage_rotg(int32(deltas(1)/2):int32(deltas(1)/2)+rows-1,...
    int32(deltas(2))/2:int32(deltas(2)/2)+cols-1);
% flipping back image if necessary
if angle>0
    dImage_rotcutg = fliplr(dImage_rotcutg);
end
end

