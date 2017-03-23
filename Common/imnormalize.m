function out = imnormalize(in)
%imnormalzie - Performs image normalization

out = (in-mean(in(:)))./std(in(:));