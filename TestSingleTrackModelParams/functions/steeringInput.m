function [u] = steeringInput(angle,n)

  k = round(n/10);
  
  ramp_1 = linspace(0,deg2rad(angle),k/2);
  ramp_2 = linspace(deg2rad(angle),0,k/2);
  ramp_3 = linspace(0,deg2rad(-angle),k/2);
  ramp_4 = linspace(deg2rad(-angle),0,k/2);
  
  u = [zeros(1,k*2) ramp_1 ones(1,k*2)*deg2rad(angle) ramp_2 ...
       zeros(1,k) ramp_3 ones(1,k*2)*deg2rad(-angle) ramp_4 zeros(1,k)];

end

