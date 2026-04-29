%%%% Initalize some parameters for navi and alignment
global wie R e R2D lati0 longi0 Nsam T  

wie = 7.292115e-5;
R = 6378137;
f = 1/298.257;
e = sqrt(f*(2-f));
R2D = 180/pi;
D2R = pi/180;

%%%% position for zupt15 data
lati0 =  20*pi/180;   %初始纬度
longi0 = 110*pi/180;   %初始经度
h0= 500;                    %初始高度

Nsam = 1;                   % 子样数
T = 0.01;                   % 采样时间
 