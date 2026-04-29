% function eul2qua
% N-E-D
% 欧垃角转为四元数

function q = eul2qua(roll,pitch,yaw)

cosr = cos(roll/2);
sinr = sin(roll/2);

cosp = cos(pitch/2);
sinp = sin(pitch/2);

cosy = cos(yaw/2);
siny = sin(yaw/2);


q=[ cosr*cosp*cosy+sinr*sinp*siny;
	sinr*cosp*cosy-cosr*sinp*siny;
	cosr*sinp*cosy+sinr*cosp*siny;
	cosr*cosp*siny+sinr*sinp*cosy];



