% Function: eul2dcm
% Euler ->  Cbn
% 由B系到N系
% E-N-U Coordinate
% 旋转顺序 roll -> pitch -> yaw

function cbn = eul2dcm(pitch,roll,yaw)


cosp = cos(pitch);
sinp = sin(pitch);

cosr = cos(roll);
sinr = sin(roll);

cosy = cos(yaw);
siny = sin(yaw);


cbn = [ cosr*cosy-sinp*sinr*siny                      -cosp*siny                          cosy*sinr+cosr*sinp*siny;...
        cosr*siny+cosy*sinp*sinr                       cosp*cosy                          sinr*siny-cosr*cosy*sinp;...
       -cosp*sinr                                      sinp                               cosp*cosr];
