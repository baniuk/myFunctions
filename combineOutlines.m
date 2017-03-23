function  im = combineOutlines(image, red, green, blue)
%combineChannels Plots red, green, blue channel on image im
%   Plots without transparecny, usefull for showing outlines on image
%   Empty channels are skipped.
%   image - should be 8-bit
%   red,green,blue - masks of objects that will be outlined

orgrgb = ind2rgb(image,gray(256));

if ~isempty(red)
    outline_redo = bwmorph(red,'remove');
    outline_red = logical(cat(3,outline_redo,zeros(size(image)),zeros(size(image))));
    outline_redn = logical(cat(3,zeros(size(image)),outline_redo,outline_redo));
    orgrgb(outline_red) = 1;
    orgrgb(outline_redn) = 0;
end
if ~isempty(green)
    outline_greeno = bwmorph(green,'remove');
    outline_green = logical(cat(3,zeros(size(image)),outline_greeno,zeros(size(image))));
    outline_greenn = logical(cat(3,outline_greeno,zeros(size(image)),outline_greeno));
    orgrgb(outline_green) = 1;
    orgrgb(outline_greenn) = 0;
end
if ~isempty(blue)
    outline_blueo = bwmorph(blue,'remove');
    outline_blue = logical(cat(3,zeros(size(image)),zeros(size(image)),outline_blueo));
    outline_bluen = logical(cat(3,outline_blueo,outline_blueo,zeros(size(image))));
    orgrgb(outline_blue) = 1;
    orgrgb(outline_bluen) = 0;
end

im = orgrgb;

end

