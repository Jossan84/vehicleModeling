function [ y ] = stepU(u,T,tEnd,t1)

    t = (0:T:tEnd);
    y = zeros(size(t));
    
    y = y + ((t >= t1) * u);
    
    y = (y(1:end-1))';

end

