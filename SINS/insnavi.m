function [q2,vel2,lati2,longi2,h2] = insnavi(q1,vel1,lati1,longi1,h1,caldata)
global wie R e Nsam T;
   %%velocity computing
    %wie
    wien=[0 wie*cos(lati1) wie*sin(lati1)]; %东北天

    %rn re
    temp=1-e^2*sin(lati1)*sin(lati1);
    RN=R*(1-e^2)/temp^1.5;
    RE=R/temp^0.5;
    %wenn
    wenn=[-vel1(2)/(RN+h1) vel1(1)/(RE+h1) vel1(1)*tan(lati1)/(RE+h1)]; %东北天
    
    %gravity
    g0 = 9.7803698; 
    gln=[0 0 -g0]'; %东北天
    %% cbn,q
    cbn = qua2dcm(q1);
    %% winb
    winb=cbn'*(wien+wenn)';
    %% wnbb*T
    wnbb=caldata(:,1:3)-repmat(winb'*T,Nsam,1);
    %% sculling correction
    if Nsam~=1
        fbscull=sum(caldata(:,4:6),1)'+1/2*cross(sum(wnbb,1)',sum(caldata(:,4:6),1)')+ ...
            2/3*(cross(wnbb(1,:)',caldata(Nsam,4:6)')+cross(caldata(1,4:6)',wnbb(Nsam,:)'));
    else
        fbscull=sum(caldata(:,4:6),1)';
    end
    %dv/dt=cbn*fbscull-(2*wien+wenn)xv+gravity
    dv=cbn*fbscull+T*Nsam*(gln+cross(vel1',(2*wien+wenn)'));
    vel2=vel1+dv';

    h2=h1+T*Nsam*vel2(3); %东北天 高度计算
    lati2=lati1+T*Nsam*vel2(2)/(RN+h2); %东北天 纬度计算
    longi2=longi1+T*Nsam*vel2(1)/(RE+h2)/cos(lati2); %东北天 经度计算
    
    %%attitude computing...
    wien=[0 wie*cos(lati2) wie*sin(lati2)]; %东北天坐标系
    
    %rn re
    temp=1-e^2*sin(lati2)*sin(lati2);
    RN=R*(1-e^2)/temp^1.5;
    RE=R/temp^0.5;
    %wenn
    wenn=[-vel2(2)/(RN+h2) vel2(1)/(RE+h2) vel2(1)*tan(lati2)/(RE+h2)];%东北天坐标系

    %winb
    winb=cbn'*(wien+wenn)';
    %wnbb*T
    wnbb=caldata(:,1:3)-repmat(winb'*T,Nsam,1);
    %% coning correction
    if Nsam~=1
        detheta=sum(wnbb,1)'+2/3*cross(wnbb(1,:)',wnbb(Nsam,:)');
    else
        detheta=sum(wnbb,1)';
    end
    
    % Q
    detheta0=norm(detheta);
    a=sin(detheta0/2)/detheta0;
    b=cos(detheta0/2);
%     detheta0=detheta(1)^2+detheta(2)^2+detheta(3)^2;
%     a=1/2-detheta0/48;
%     b=1-detheta0/8+detheta0^2/384;
    q2=quamul(q1,[b;a*detheta]);
    %% Q normalization
    q2=q2/norm(q2);

    