function out = StackProcessor( fcn, data, varargin )
%StackProcessor Process stack of images using list of functions
% Processed stack is saved back to disk as multilayer Tiff. Processors must
% be functions that accept image and return image. Any additional
% parameters should be provided on creating handle of function. Images are
% processed separately using processors in order as the are in fcn cell.
% Output stack is saved with name of the input data that can be extended by
% any string given in parameters.
% Processing functions can have one or two parameters. First parameter is
% always image to process, second parameter can be number of currently
% processed slice.
%
% Inputs:
%     fcn                - cell with handles to processors
%     data               - path to image
%     'nameext',[string] - string that added to end of original filename.
%                          Default value is ''
%     'outpath',[string] - path where output file will be written.
%                          Default is current directory
%     'idx',[vector]     - Vector of indexes indicating which slices to read
%                          from input file. Default is all slices.
%   
% Outputs:
%    File written on disk
%     out - resulting stack of images without scalling
%
% Usage:
%     % prepare handles to processors
%     h{1} = @(im)processImage_cut(im,min(size(i)));
%     h{2} = @(im)processImage_medfilt2(im,[81 81]);
%     h{3} = @(rImage)DICReconstructionSPLINE(rImage,'aver',1,'filter','yes','angle',45);
%     h{4} = @(rImage)processImage_fftfilt2(rImage,45,20,50);
%     name_ext = '_med81_spline1-45_fft20-50';
%     StackProcessor(h,'/Data/file.tif','nameext',name_ext,'outpath',pout);
%
% Dependencies:
%
% Author: Piotr Baniukiewicz
% Email: p.baniukiewicz@warwick.ac.uk
%
% History:
%     24 Jul 2015 - Initial version
%     02 Oct 2015 - Added output in form of unprocessed matrix
%     04 Oct 2015 - Added support for processing functions that accept slice number as well  

% default params:
name_ext = '';
pout = [cd filesep]; % outout path - default in local dir
idx = []; % indexes of stack to process
% decode input arguments
i = 1;
try
    while(i<=length(varargin))
        switch varargin{i}
            case 'nameext'
                name_ext = varargin{i+1};
                assert(ischar(name_ext),'name_ext must be string');
                i = i+2;
            case 'outpath'
                pout = varargin{i+1};
                assert(ischar(pout),'pout must be string');
                i = i+2;
            case 'idx'
                idx = varargin{i+1};
                assert(isnumeric(idx),'idx must be numeric');
                i = i+2;
            otherwise
                error('Unknown option');
        end
    end
catch exception
    error(['Wrong input parameters: ',exception.message]);
end

% check if data is string (probably path to file) or numeric matrix -
% probably Matlab array
if ischar(data) % string - assumes that this is path to file to load
    iminfo = imfinfo(data);
    lengthofdata = length(iminfo);
    [paths,name,ext]=fileparts(data);
    rImage = imread([paths,filesep,name,ext],'index',1); % read one image to get size of stack
    % decide if we process all or only part
    if isempty(idx)
        idx = 1:lengthofdata;
    end
    out = zeros([size(rImage) length(idx)]);
    count = 1; % only to know when is first image saved - cant be append
    for i = idx % process every (or selected) image in stack
        rImage = imread([paths,filesep,name,ext],'index',i); % read ith image
        % if there is more functions in fcn, all they except last process
        for f=1:length(fcn)
            if nargin(fcn{f})==1
                rImage = fcn{f}(rImage);
            elseif nargin(fcn{f})==2
                rImage = fcn{f}(rImage,i);
            else
                error('Wrong number of inputs');
            end
        end
        out(:,:,count) = rImage;
        dObject1 = myim2uint8(rImage);
        if count==1
            imwrite(dObject1,[pout,filesep,name,name_ext,ext]);
        else
            imwrite(dObject1,[pout,filesep,name,name_ext,ext],'WriteMode','append');
        end
        count = count + 1;
        disp(['i= ',num2str(i) '/' num2str(lengthofdata) ' from ' name])
    end
    disp(['Saved to ' pout,filesep,name,name_ext,ext])
elseif isnumeric(data)
    [~, ~, lengthofdata] = size(data); % assume 3D array, images in layers [rows cols]
    error('Not supported yet');
else
    error('Input data have wrong format');
end
    



end

