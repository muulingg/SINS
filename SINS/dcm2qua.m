function q = dcm2qua(cbn)
%%% rn=q*rb*q' 
q0 = 1/2*sqrt(1+cbn(1,1)+cbn(2,2)+cbn(3,3));
q = [q0;
     1/4/q0*(cbn(3,2)-cbn(2,3));
     1/4/q0*(cbn(1,3)-cbn(3,1));
     1/4/q0*(cbn(2,1)-cbn(1,2))];