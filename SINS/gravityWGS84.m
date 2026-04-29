function g = gravityWGS84(lati,h)
%GRAVITYWGS84
% gravity using WGS84 earth model
%
% INPUTS
%   lati = latitude(rad)
%   h = altitude(m)
% OUTPUTS
%   g = gravity(m/s2)
%
%zhangkaidong,NUDT313
%2004.6.10

e	 =  0.0818191908426;
esinlati2 = (e*sin(lati))^2;
g0 = 9.7803267714*(1+0.00193185138639*sin(lati)*sin(lati))/(1-esinlati2)^0.5;
g = g0-(3.0877e-6 - 0.0044e-6 * sin(lati)*sin(lati))*h+0.072e-12*h*h;%自由空气矫正
