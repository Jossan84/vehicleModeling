function [ y ] = sineU(u,T,tEnd,Fc)

   t = (0:T:tEnd-T)';    
   
   %%Sine wave:
   y = sin(t);


end

