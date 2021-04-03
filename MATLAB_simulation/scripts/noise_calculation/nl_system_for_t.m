%>
%> @file nl_system_for_t.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Supplementary function for non-linear solver (timer value for zero-line intersection)
%>

%> 
%> @brief Supplementary function for non-linear solver
%> 
%> @param x Input parameter array
%> 
%> @retval f Output parameter array
%>
function  f  = nl_system_for_t( x )
    global c;
    global I;
    global y;
    global Ax;
    global Bx;
    global sgn;
    global Kf;
    global Fbr;

    global xx;
    global C;
    global x3;
    
    t=abs(real(x(1)));
    
    expAxt=exp(Ax*t);
    expx3t=exp(x3*t);
    cosBxt=cos(Bx*t);
    sinBxt=sin(Bx*t);
    expsinf=expAxt*sinBxt;
    expcosf=expAxt*cosBxt;
    
    f(1)=(C(1)*expcosf+C(2)*expsinf+C(3)*expx3t-sgn*Kf*I/c+y/c+Fbr/c)-xx;
end

