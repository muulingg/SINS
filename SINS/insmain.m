%%  N-E-D coordinate
clear all;
close all;
clc;
disp('载入数据...')
load('Wibb');
load('Fb');
load('qq');
load('posi');
load('veloN');
load('atti');
%%
initpara;
N = size(Wibb,2);
% 前3列为陀螺增量数据，后3列为加速度计增量数据
caldata = zeros(N,6);
caldata(:,1) =  Wibb(1,1:end)';
caldata(:,2) =  Wibb(2,1:end)';
caldata(:,3) =  Wibb(3,1:end)';
caldata(:,4) =  Fb(1,1:end)';
caldata(:,5) =  Fb(2,1:end)';
caldata(:,6) =  Fb(3,1:end)';

%%
Nnavi = floor(size(caldata,1)/Nsam);
eulangle = zeros(Nnavi,3);
vel = zeros(Nnavi,3);
lati = zeros(Nnavi,1);
longi = zeros(Nnavi,1);
h = zeros(Nnavi,1);
ins_qq = zeros(4,Nnavi);

%姿态初始值
roll = (0)  * pi/180;
pitch = (0) * pi/180;
yaw = (0)   * pi/180;

%计算方向余弦矩阵初始值
cbn = eul2dcm(pitch,roll,yaw);  % 东北天

%计算四元数初始值
qq0 = dcm2qua(cbn);
vel0 = [0,0,0];

for i = 1:Nnavi
   
        %惯性导航
        if(i==1)
              [q,vel(i,:),lati(i),longi(i),h(i)] = insnavi(qq0,vel0,lati0,longi0,h0,caldata(i*Nsam-Nsam+1:i*Nsam,:));
        else
%             [q,vel(i,:),lati(i),longi(i),h(i),dv(i,:)] = insnavi(qq(:,i-1),vel(i-1,:),lati(i-1),longi(i-1),h(i-1),caldata(i*Nsam-Nsam+1:i*Nsam,:));
              [q,vel(i,:),lati(i),longi(i),h(i)] = insnavi(q,vel(i-1,:),lati(i-1),longi(i-1),h(i-1),caldata(i*Nsam-Nsam+1:i*Nsam,:));
        end
        %保存四元数
        ins_qq(:,i) = q;
        
        % 计算欧拉角
        cbn = qua2dcm(q);
        [aa,bb,cc] = dcm2eul(cbn);
        eulangle(i,1) = aa*R2D;
        eulangle(i,2) = bb*R2D;
        eulangle(i,3) = cc*R2D;
       
    if mod(i,100*100) == 0
        disp(strcat('t=',num2str(0.01*i*Nsam),'s/',num2str(0.01*Nnavi*Nsam),'s---:',num2str(eulangle(i,1)),',',num2str(eulangle(i,2)),',',num2str(eulangle(i,3))))
    end
    
end
%%
save('ins_qq','ins_qq');
save('eulangle','eulangle');

%%
% 轨迹图对比
image1=figure(1);
plot3(longi(1:end,1)*180/pi,lati(1:end,1)*180/pi,h,'b');
hold on;
plot3(posi(1,1:end),posi(2,1:end),posi(3,1:end),'r');
xlabel('经度/rad');
ylabel('纬度/rad');
grid on;
saveas(image1,'轨迹对比.fig');
 %%
%纬度误差
lati_error = zeros(Nnavi,1);
for i = 1:Nnavi
   lati_error(i,1) = (lati(i,1)-posi(2,i)*pi/180)*R;
end
% 
image2=figure(2);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,lati_error,'b');
xlabel('Time/Hour');
ylabel('纬度误差/m');
grid on;
saveas(image2,'纬度误差.fig');
save('lati_error','lati_error');
%%
%经度误差
longi_error = zeros(Nnavi,1);
for i = 1:Nnavi
   longi_error(i,1) = (longi(i,1)-posi(1,i)*pi/180)*R*cos(posi(2,i)*pi/180);
end
% 
image3=figure(3);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,longi_error,'b');
xlabel('Time/Hour');
ylabel('经度误差/m');
grid on;
saveas(image3,'经度误差.fig');
save('longi_error','longi_error');

%%
%位置误差
pos_error = zeros(Nnavi,1);
for i = 1:Nnavi
   pos_error(i,1) = sqrt(   lati_error(i,1)^2 +   longi_error(i,1) ^2 );
end
% 
image4=figure(4);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,pos_error,'b');
xlabel('Time/Hour');
ylabel('位置误差/m');
grid on;
saveas(image4,'位置误差.fig');
save('pos_error','pos_error');
%%
% 东向速度误差
ve_error = zeros(Nnavi,1);
for i = 1:Nnavi
   ve_error(i,1) = (vel(i,1)-veloN(1,i));
end
% 
image5=figure(5);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,ve_error,'b');
xlabel('Time/Hour');
ylabel('东向速度误差/(m/s)');
grid on;
saveas(image5,'东向速度误差.fig');
save('ve_error','ve_error');
%%
% 北向速度误差
vn_error = zeros(Nnavi,1);
for i = 1:Nnavi
   vn_error(i,1) = (vel(i,2)-veloN(2,i));
end
% 
image6=figure(6);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,vn_error,'b');
xlabel('Time/Hour');
ylabel('北向速度误差/(m/s)');
grid on;
saveas(image6,'北向速度误差.fig');
save('vn_error','vn_error');
%%
%俯仰角误差
pitch_error = zeros(Nnavi,1);
for i = 1:Nnavi
   pitch_error(i,1) = eulangle(i,1)-atti(1,i)*R2D;
end
% 
image7=figure(7);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,pitch_error,'b');
xlabel('Time/Hour');
ylabel('俯仰角误差/°');
grid on;
saveas(image7,'俯仰角误差.fig');
%%
% 横滚角误差
roll_error = zeros(Nnavi,1);
for i = 1:Nnavi
   roll_error(i,1) = eulangle(i,2)-atti(2,i)*R2D;
end
% 
image8=figure(8);
time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
plot(time,roll_error,'b');
xlabel('Time/Hour');
ylabel('横滚角误差/°');
grid on;
saveas(image8,'横滚角误差.fig');

%%
% 航向角误差
% yaw_error = zeros(Nnavi,1);
% for i = 1:Nnavi
%    yaw_error(i,1) = eulangle(i,3)-atti(3,i*2);
% end
% % 
% image11=figure(11);
% time = 0.01/3600:0.01/3600:(Nnavi*0.01)/3600;
% plot(time,yaw_error,'b');
% xlabel('Time/Hour');
% ylabel('俯仰角误差/°');
% grid on;
% saveas(image11,'航向角误差.fig');