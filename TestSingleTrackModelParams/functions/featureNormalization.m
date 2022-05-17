% featureNormalization.m
% 26/03/2019

function xNorm = featureNormalization(x, x_max)
    xNorm = x ./ x_max;
end