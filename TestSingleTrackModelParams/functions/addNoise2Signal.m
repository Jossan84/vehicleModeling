function [y] = addNoise2Signal(mu,sigma, signal)

    [m n] = size(signal);

    y = signal + sigma * randn(m, 1) + mu;
   

end

