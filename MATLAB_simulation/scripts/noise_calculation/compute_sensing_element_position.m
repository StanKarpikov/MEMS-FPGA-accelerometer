%>
%> @file compute_sensing_element_position.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Returns the calculated position of the sensing element
%>

%> 
%> @brief Returns the calculated position of the sensing element
%> 
%> @param t Current time
%> @param t_1 Time of the previous frame
%> @param x_1 Position of the previous frame
%> @param xp_1 Velocity of the previous frame
%> @param xpp_1 Acceleration of the previous frame
%> 
%> @retval x Current position 
%> @retval xp Current velocity 
%> @retval xpp Current acceleration 
%>
function [ x, xp, xpp ] = compute_sensing_element_position( t , t_l,  x_l, xp_l, xpp_l)
    global c;
    global Fkp;
    global I;
    global Epsi;
    global T1;
    global T2;
    global y;
    global U;
    global Ax;
    global Bx;
    global L;
    global m;
    global cd;
    global sgn;
    global Kf;
    global Fbr;
    %------------------ Parameters ----------------------------------
    T2=L*I/U;
    %T2=L/(Rx+r); % Alternative variant for coils
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
    expAxt=exp(Ax*t);
    expx3t=exp(x3*t);
    cosBxt=cos(Bx*t);
    sinBxt=sin(Bx*t);
    expsinf=expAxt*sinBxt;
    expcosf=expAxt*cosBxt;
    Axexpcosf=Ax*expcosf;
    Axexpsinf=Ax*expsinf;
    Bxexpcosf=Bx*expcosf;
    Bxexpsinf=Bx*expsinf;
    %------------------ Results
    x=C(1)*expcosf+C(2)*expsinf+C(3)*expx3t-sgn*Kf*I/c+y/c+Fbr/c;

    xp=C(1)*(Axexpcosf-Bxexpsinf)...
        +C(2)*(Axexpsinf+Bxexpcosf)...
        +x3*C(3)*expx3t;

    xpp=C(1)*(...
        Ax*(Axexpcosf-Bxexpsinf)...
        -Bx*(Axexpsinf+Bxexpcosf))...
        +C(2)*(...
        Ax*(Axexpsinf+Bxexpcosf)...
        +Bx*(Axexpcosf-Bxexpsinf))...
        +x3^2*C(3)*expx3t;

end

