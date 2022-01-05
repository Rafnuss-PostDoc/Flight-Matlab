function [Pmech,Pind,Ppar,Ppro] = mechanicalPowerHeerenbrink(bird,varargin)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

assert(class(bird)=="Bird")


g = 9.80665; % Constant of gravity [ms-2] 
rho = 1.225; %Air density
viscosity = 14.6e-6 ; % Kinematic air viscosity m2 /s

climbAngle =0;

k=1.2; % Induced power factor k=1.1-1.2 for aircraft and helicopter. 1.04 in ﻿Spedding (1987a) (p. 45).
CDb = 0.2; % body drag coefficient (p. 51).[-] % 0.2 in https://github.com/MarcoKlH/afpt-r/blob/f5850c125491c3d54fe9a2473f9f849b56956876/R/Bird.R#L56
kp = 0.03; % profile drag factor https://github.com/MarcoKlH/afpt-r/blob/f5850c125491c3d54fe9a2473f9f849b56956876/R/Bird.R#L55

syms V

% lift
L = bird.mass*g*cos(climbAngle);

% dynamic pressure
q = 1/2 * rho * V^2;

% Induce drag
Dind = L^2/(q*pi*bird.wingSpan^2);

% Parasitie / Body drag
Dpar = (q * bird.bodyFrontalArea * CDb) + bird.mass*g*sin(climbAngle);

%﻿Profile drag
ReynoldsNo = V*bird.wingArea/bird.wingSpan/viscosity;
CDpro0 = 2.66/sqrt(ReynoldsNo);
Dpro0 = q * bird.wingArea * CDpro0;
% Lift dependent profile drag
Dpro2 = kp * L^2 / (q * bird.wingArea);

%Reduce frequency
kf = 2*pi*bird.wingbeatFrequency*bird.wingSpan/V;
phi = powercurve.strokeplane;
Cind = [9.25 2.931   0 -1.969   0   0];
Cpro0 = [-0.59 -1.145 0.239 0.197 0.446 -0.715];
Cpro2 = [9.298 1.301 -0.659 -1.521   0   0];
fD.ind = (Cind(1)+Cind(2)*tan(phi)^2)/kf + (Cind(3)+Cind(4)*tan(phi)+Cind(5)*tan(phi)^2);
fD.pro0 = (Cpro0(1)+Cpro0(2)*tan(phi)^2) + (Cpro0(3)+Cpro0(4)*tan(phi)+Cpro0(5)*tan(phi)^2)*kf + (Cpro0(6))/kf^2;
fD.pro2 = (Cpro2(1)+Cpro2(2)*tan(phi)^2)/kf + (Cpro2(3)+Cpro2(4)*tan(phi)+Cpro2(5)*tan(phi)^2);


% Thrust ratio
ToverL = (Dind + Dpro0 + Dpro2 + Dpar)/(L - fD.ind(kf,phi)*Dind - fD.pro0(kf,phi)*Dpro0 - fD.pro2(kf,phi)*Dpro2);

Ppro = V * (Dpro0 + Dpro2);

% Total Mechanical Power (eq 1 of Box 3.4) 
Pmech = Pind + Ppar + Ppro;

end

