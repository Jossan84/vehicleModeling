% featureDeNormalization.m
% 26/03/2019

function xDeNorm = featureDeNormalization(x, x_max)
    xDeNorm = x .* x_max;
end