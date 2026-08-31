function alpha = Fig_alpha(alt_ft, M)
% alpha - Cycle specific thrust lapse for engine design
% Values calculated per GasTurb with maximum TET of 1850

% Input(s)
% alt_ft - flight altitude of aircraft
% M - flight Mach number
% Output(s)
% alpha - cycle specific thrust lapse

% Test
% alt_ft = 15000;
% M = 0.6;
L = length(alt_ft);
alpha = zeros(1,L);

for k = 1:L
X2 = 0:5000:45000;
X1 = 0:0.1:0.9;
Y1 = {[1.0000    0.9416    0.8961    0.8614    0.8353    0.8130    0.7897    0.7670    0.7445    0.7221]
      [0.8762    0.8270    0.7894    0.7616    0.7421    0.7303    0.7212    0.7099    0.6941    0.6774]
      [0.7585    0.7176    0.6871    0.6655    0.6515    0.6435    0.6401    0.6403    0.6386    0.6286]
      [0.6475    0.6140    0.5897    0.5735    0.5641    0.5601    0.5606    0.5642    0.5697    0.5741]
      [0.5528    0.5248    0.5041    0.4901    0.4819    0.4805    0.4839    0.4901    0.4983    0.5073]
      [0.4691    0.4461    0.4292    0.4177    0.4111    0.4092    0.4117    0.4194    0.4295    0.4406]
      [0.3964    0.3776    0.3638    0.3544    0.3490    0.3474    0.3494    0.3548    0.3637    0.3766]
      [0.3329    0.3177    0.3065    0.2990    0.2947    0.2935    0.2952    0.2995    0.3065    0.3162]
      [0.2638    0.2518    0.2430    0.2370    0.2337    0.2328    0.2341    0.2377    0.2433    0.2510]
      [0.2054    0.1961    0.1892    0.1846    0.1820    0.1814    0.1826    0.1854    0.1901    0.1960]};
nm = length(X2);
Y2 = zeros(size(nm));
for i = 1:nm
    Y2(i) = interp1(X1,Y1{i},M(k),'pchip');
end
alpha(k) = interp1(X2,Y2,alt_ft(k),'linear','extrap');
end
end