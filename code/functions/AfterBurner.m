function [ P,f_AB, fab ] = AfterBurner( PI,P,CP,TAU,gam,ETA,h,T0,R, T,f, M9)
%Pg 455 pdf elements of gass turbines
%data from Exercici43
%After Burner parameters
gam.AB = gam.hot;
CP.AB = CP.hot;
T.t7 = 2700;
ETA.AB = 0.98;

%% Exercici 43
T.t9 = T.t7;
P.t9 = P.t5;

T9 = T.t9/(1+(gam.AB-1)/2*M9^2);
TAU.AB = T.t7/T0;
fab = CP.AB*T0/h*1/ETA.AB*(TAU.AB-TAU.t*TAU.lamb);

P.t9_9 = (1+(gam.AB-1)/2*M9^2)^(gam.AB/(gam.AB-1));



%% BOOK pg 455
%compute main parameter
R.AB = (gam.AB - 1)/gam.AB*CP.AB;
TAU.lambAB = CP.AB*T.t7/(CP.cold*T0);
%fuel fraction afterburner definded on pg 453. f_AB = m_fAB/m0
f_AB = (1+f)*(TAU.lambAB-TAU.lamb*TAU.t)/(ETA.AB*h/(CP.cold*T0)-TAU.lambAB);





end

