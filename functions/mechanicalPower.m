function [Pmech,Pind,Ppar,Ppro] = mechanicalPower(bird,varargin)
% MECHANICALPOWER compute the mechanical power of a bird

assert(class(bird)=="Bird")

g = 9.80665; % Constant of gravity [ms-2] 
rho = 1.225; %Air density

k=1.2; % Induced power factor k=1.1-1.2 for aircraft and helicopter. 1.04 in ﻿Spedding (1987a) (p. 45).
CDb = 0.1; % body drag coefficient (p. 51).[-]
Cpro = 8.4;

syms V

% Induce power (eq 16 of Box 3.1)
% Pind﻿is due to the active acceleration of mass flow in order to produce a force opposing weight and drag
Pind = 2*k*(bird.mass*g)^2/(V*pi*bird.wingSpan^2*rho);

% Parasitie power (eq 3 of Box 3.2) (also called Body Power)
% due to drag on the body
Ppar = rho*V^3*bird.bodyFrontalArea*CDb/2;

%﻿Profile power
% due to the local drag on the wings
Pam = 1.05*k^(3/4)*bird.mass^(3/2)*g^(3/2)*bird.bodyFrontalArea^(1/4)*CDb^(1/4)./rho.^(1/2)/bird.wingSpan^(3/2);
Ppro = Cpro / bird.wingAspect*Pam;

% Total Mechanical Power (eq 1 of Box 3.4) 
Pmech = Pind + Ppar + Ppro;

end

