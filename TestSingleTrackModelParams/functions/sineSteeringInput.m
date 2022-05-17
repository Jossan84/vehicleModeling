function [u] = sineSteeringInput(angle,n,Ts)

  Amp = deg2rad(angle);
  f   = 0.1;
  t = 0:Ts:(n*Ts);

  u = Amp * sin(2*pi*f*t);
  
  u = u(1:end-1);
   
end

