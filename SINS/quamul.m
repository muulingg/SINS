function z = quamul(x,y)
%%% z = x*y
z = [x(1) -x(2) -x(3) -x(4);
    x(2) x(1) -x(4) x(3);
    x(3) x(4) x(1) -x(2);
    x(4) -x(3) x(2) x(1)]*y;













