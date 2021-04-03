%>
%> @file compute_accurate_time.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Returns the precise timer value for zero-line intersection
%>

%> 
%> @brief Returns the precise timer value for zero-line intersection
%> 
%> @param ts Current time
%> @param t_1 Time of the previous frame
%> @param x_1 Position of the previous frame
%> @param xp_1 Velocity of the previous frame
%> @param xpp_1 Acceleration of the previous frame
%> 
%> @retval t Intersection time
%>
function t = compute_accurate_time(ts,t_l,  x_l, xp_l, xpp_l)
    global c;
    global I;
    global T2;
    global y;
    global U;
    global Ax;
    global Bx;
    global L;
    global sgn;
    global Kf;
    global Fbr;

    global C;
    global x3;
    %------------------ Parameters ----------------------------------
    T2=L*I/U;
    x3=-1/T2;

    expAxt=exp(Ax*t_l);
    expx3t=exp(x3*t_l);
    cosBxt=cos(Bx*t_l);
    sinBxt=sin(Bx*t_l);
    expsinf=expAxt*sinBxt;
    expcosf=expAxt*cosBxt;
    Axexpcosf=Ax*expcosf;
    Axexpsinf=Ax*expsinf;
    Bxexpcosf=Bx*expcosf;
    Bxexpsinf=Bx*expsinf;
    %------------------ Constants C1, C2, C3 ----------------------------------
    Tm=[expcosf ...
        expsinf ...
        expx3t;...

        (Axexpcosf-Bxexpsinf) ...
        (Axexpsinf+Bxexpcosf) ...
        x3*expx3t;...

        (Ax*(Axexpcosf-Bxexpsinf)...
        -Bx*(Axexpsinf+Bxexpcosf)) ...
        (Ax*(Axexpsinf+Bxexpcosf)...
        +Bx*(Axexpcosf-Bxexpsinf)) ...
        x3^2*expx3t];

    Tm=Tm^-1;
    C=Tm*[(x_l+sgn*Kf*I/c-y/c-Fbr/c) xp_l xpp_l]';
    %------------------ Solve -----------------------------------------------
    t=fsolve(@nl_system_for_t,ts,optimset('Display','off', 'TolFun', 1.0e-15,'TolX', 1.0e-15,'MaxFunEvals',4000,'MaxIter',4000));
end

