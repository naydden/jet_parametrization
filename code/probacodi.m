%Per provar el codi de realengine.
PI.f=1;
PI.c=25;
T.t4=1700;
alpha=1;
T0=245;
P0=60000;
M0=0.8;
lamb.cold=1.4;
lamb.hot=1.4;
TAU.lamb=6.93;
TAU.r=1.128;
T.t0=276.36;
P.t0=912000;
CP.hot=1005;
CP.cold=1005;
[ PI,TAU,T,P,f ] =realengine( PI,TAU,T0,P0,M0,T,P,CP,lamb,alpha);