function out = rmse(in1,in2)
% liczy b³¹d RMSE

out = sqrt(sum((in1(:)-in2(:)).^2)/numel(in1));