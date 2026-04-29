% fucntion : dcm2eul Cbn -> Euler
function [pitch,roll,yaw] = dcm2eul(Cbn)

% roll=atan2(cbn(3,2),cbn(3,3)); 
% pitch=asin(-cbn(3,1));
% yaw=atan2(cbn(2,1),cbn(1,1)); 

pitch = asin(Cbn(3,2));
roll  = atan2(-Cbn(3,1),Cbn(3,3));
yaw   = atan2(-Cbn(1,2),Cbn(2,2));