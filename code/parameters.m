clear; clc; close all;
%{
%}
%C = @tau2pi;
%% Values
T.t4 = 1780; %[K]
height = 9500; %[m]
[T0, a0, P0, rho0] = atmosisa(height);
v0 = 600/3.6; %[m/s]
gam.cold = 1.4;
gam.hot=1.3;
CP.hot=1200;
CP.cold=1004;

% Eficiencias i ratis
h=43e6; 
PI.d=0.96;
ETA.f=0.98; %Suposició
ETA.cH=0.98;
PI.b=0.94;
ETA.b=0.99;
ETA.tH=0.87;
ETA.tL=0.87;
PI.n=0.98;
ETA.mec=0.99;

%Calculations
M0 = v0/a0;
T.t0 = T0*(1+(gam.cold-1)/2*M0^2);
P.t0=P0*(1+(gam.cold-1)/2*M0^2)^(gam.cold/(gam.cold-1));
TAU.lamb = T.t4/T0;
TAU.r = T.t0/T0;
PI.r=pi2tau(TAU.r,gam.cold);


%% OPTIMIZATION
%input {PI.c, alpha}
inc_c = 0.8;
inc_a = 0.8;

i = 1;
j = 1;
PI.c = 1 : inc_c : 60;

for pc = PI.c
    TAU.c(i) = pi2tau(pc, gam.cold); 
    for alpha = 0: inc_a : 30
        TAU.f(i,j) = (TAU.lamb - TAU.r*(TAU.c(i) - 1) - TAU.lamb/(TAU.r*TAU.c(i)) + alpha*TAU.r+1)*1/(TAU.r*(1+alpha));
        PI.f(i,j) = tau2pi(TAU.f(i,j), gam.cold);
        j = j + 1;
    end
    j = 1;
    i = i + 1;
end
alpha = 0: inc_a : 30;

%% PLOT
%surf(PI.c, alpha, PI.f')
%xlabel('\pi_c'); ylabel('\alpha'); zlabel('\pi_f');

%% Adimensional F vs. PI.c
%book page 461
R.c = (gam.cold-1)/gam.cold*CP.cold;
R.t = (gam.hot-1)/gam.hot*CP.hot;
V.v0 = a0*M0;
if M0 <= 1
    ETA.r = 1;
else
    ETA.r = 1-0.075*(M0-1)^1.35;
end
i = 1;
j = 1;
f = zeros(size(PI.c));
M9 = zeros(74,38);
M19 = zeros(74,38);
gc = 6.674e-11;%[ m3?kg?1?s?2] constante newton
P0_P9 = 1;
P0_P19 = 1;
for pc = PI.c
    f(i) = (TAU.lamb - TAU.r*TAU.c(i))/(ETA.b*h/(CP.cold*T0)-TAU.lamb);
    for alpha = 0: inc_a : 30
        TAU.t(i,j) = 1-1/(ETA.mec*(1+f(i)))*TAU.r/TAU.lamb*(TAU.c(i)-1+alpha*(TAU.f(i,j)-1));
        PI.t(i,j) = tau2pi(TAU.t(i,j), gam.hot);
        
        %core
        P.t9_9(i,j) = PI.r*PI.d*PI.c(i)*PI.b*PI.t(i,j)*PI.n ; %Suposem adaptada P0/P9 = 1
        M9(i,j) = sqrt(2/(gam.hot-1)*(P.t9_9(i,j)^((gam.hot-1)/gam.hot)-1));
        % [rows,cols,vals] =find(M9(imag(M9)== 0))
        T.T9_T0(i,j) = TAU.lamb*TAU.t(i,j)*CP.cold/(pi2tau(P.t9_9(i,j),gam.hot)*CP.hot);
        V.v9_a0(i,j) = M9(i,j)*sqrt((gam.hot*R.t)/(gam.cold*R.c)*T.T9_T0(i,j));
        
        %secondary
        P.t19_19(i,j) = PI.r*PI.d*PI.f(i,j)*PI.n ; %Suposem adaptada P0/P19 = 1
        M19(i,j) = sqrt(2/(gam.cold-1)*(P.t19_19(i,j)^((gam.cold-1)/gam.cold)-1));
        T.T19_T0(i,j) = TAU.lamb*TAU.f(i,j)/(pi2tau(P.t19_19(i,j),gam.cold));
        V.v19_a0(i,j) = M19(i,j)*sqrt(T.T19_T0(i,j));
        
        F.adim(i,j) = a0/((1+alpha)*gc)*((1+f(i))*V.v9_a0(i,j)-M0+(1+f(i))*...
            (R.t*T.T9_T0(i,j)*(1-P0_P9))/(R.c*V.v9_a0(i,j)*gam.cold))+...
            alpha*a0/((1+alpha)*gc)*(V.v19_a0(i,j)-M0+...
            T.T19_T0(i,j)/V.v19_a0(i,j)*(1-P0_P19)/gam.cold);
                
        j = j + 1;
    end
    j = 1;
    i = i + 1;
end


