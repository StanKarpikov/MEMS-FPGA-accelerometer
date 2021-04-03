%>
%> @file calclate_parameters_fo_prototype.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Calculation of the prototype parameters
%>

global T;
global A;
global b;
global U;
global R;
global t1;
global t2;
global t3;
global tx;
global ty;
global k;
global m;
global G;
global c;
global L;

Tavt=21.86e-3;
T=22e-3;

t1=0;
t3=Tavt;
t2=t3/2;
tx=4.75e-3;
ty=15.5e-3;

b=((1.36+0.57)/2)*pi/180;
A=(9.53/2)*pi/180;

U=0.5;
R=272;
L=1e-3;

k=0.0653;%0.08;
m=9.7475e-07;%0.4e-3*2.5e-3;
c=1.0728e-05;%1e-5;
G=0.0010;%1e-3*2.5e-3;

V1=24;

Ax=-c/(2*m);
Bx=sqrt(k/m);
%%
% Coefficients C1 C2
Tm=[exp(Ax*t1)*cos(Bx*t1) exp(Ax*t1)*sin(Bx*t1);...
    (Ax*exp(Ax*t1)*cos(Bx*t1)-Bx*exp(Ax*t1)*sin(Bx*t1)) (Ax*exp(Ax*t1)*sin(Bx*t1)+Bx*exp(Ax*t1)*cos(Bx*t1))];
Tm=Tm^-1;
C=Tm*[(b+G/k) V1]';
C1=C(1);
C2=C(2);

Tm=[exp(Ax*t2)*cos(Bx*t2) exp(Ax*t2)*sin(Bx*t2);...
    (Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2)) (Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))];
Tm=Tm^-1;
C=Tm*[(-b-G/k) -V1]';
C3=C(1);
C4=C(2);

%plotfunmaket(A,b,t1,t2,t3,tx,ty,k,m,c,G,V1);

xans=[k m c G C1 C2 C3 C4 V1 tx ty];
xans=fsolve(@nl_sys_prototype_findpar,xans,...
    optimset('Display','on', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',10000,'MaxIter',4000));

nl_sys_prototype_findpar(xans)
k=abs(real(xans(1)))
m=abs(real(xans(2)))
c=abs(real(xans(3)))
G=abs(real(xans(4)))
C1=abs(real(xans(5)))
C2=abs(real(xans(6)))
C3=abs(real(xans(7)))
C4=abs(real(xans(8)))
V1=abs(real(xans(9)))

%%
% Transfer function
Ae=[];
nu=[];
Amax=1.7*9.8;
N=100;

h1 = waitbar(0);
xans1=[t2 t3 C1 C2 C3 C4 V1 -V1];
for Aext=0:Amax/N:Amax
    waitbar(Aext/Amax,h1, sprintf('Progress\n%.2f%%',100*Aext/Amax));
    
    y=Aext*m/3e-3;
    Ae=[Ae,Aext/9.8];
    xans1=fsolve(@nl_sys_prototype,xans1,...
        optimset('Display','on', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    t2=abs(real(xans1(1)));
    t3=abs(real(xans1(2)));
    nu=[nu,-(t3-2*t2)/t3];
end

plot(Ae,nu,'k');
%axis([0 Amax 0 1]);
%grid on;

%%
function f  = nl_sys_prototype_findpar( x )
global A;
global b;
global t1;
global t2;
global t3;

    kk=abs(real(x(1)));
    mm=abs(real(x(2)));
    cc=abs(real(x(3)));
    GG=abs(real(x(4)));

    C1=real(x(5));
    C2=real(x(6));
    C3=real(x(7));
    C4=real(x(8));

    V1=abs(real(x(9)));
 
    tx=abs(real(x(10)));
    ty=abs(real(x(11)));
    
    Ax=-cc/(2*mm);
    Bx=sqrt(kk/mm);
    
    f(1)=C1*exp(Ax*t1)*cos(Bx*t1)+C2*exp(Ax*t1)*sin(Bx*t1)-GG/kk-b;
    f(2)=C1*exp(Ax*t2)*cos(Bx*t2)+C2*exp(Ax*t2)*sin(Bx*t2)-GG/kk+b;
    f(3)=C3*exp(Ax*t2)*cos(Bx*t2)+C4*exp(Ax*t2)*sin(Bx*t2)+GG/kk+b;
    f(4)=C3*exp(Ax*t3)*cos(Bx*t3)+C4*exp(Ax*t3)*sin(Bx*t3)+GG/kk-b;
    
    f(5)=C1*(Ax*exp(Ax*t1)*cos(Bx*t1)-Bx*exp(Ax*t1)*sin(Bx*t1))...
        +C2*(Ax*exp(Ax*t1)*sin(Bx*t1)+Bx*exp(Ax*t1)*cos(Bx*t1))-V1;
    
    f(6)=C3*(Ax*exp(Ax*t3)*cos(Bx*t3)-Bx*exp(Ax*t3)*sin(Bx*t3))...
        +C4*(Ax*exp(Ax*t3)*sin(Bx*t3)+Bx*exp(Ax*t3)*cos(Bx*t3))-V1;
    
    f(7)=C1*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2))...
        +C2*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))+V1;
    
    f(8)=C3*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2))...
        +C4*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))+V1;
    
    f(9) =C1*exp(Ax*tx)*cos(Bx*tx)+C2*exp(Ax*tx)*sin(Bx*tx)-GG/kk-A;
    f(10)=C3*exp(Ax*ty)*cos(Bx*ty)+C4*exp(Ax*ty)*sin(Bx*ty)+GG/kk+A;
    
    f(11)=C1*(Ax*exp(Ax*tx)*cos(Bx*tx)-Bx*exp(Ax*tx)*sin(Bx*tx))...
        +C2*(Ax*exp(Ax*tx)*sin(Bx*tx)+Bx*exp(Ax*tx)*cos(Bx*tx))...
        +C3*(Ax*exp(Ax*ty)*cos(Bx*ty)-Bx*exp(Ax*ty)*sin(Bx*ty))...
        +C4*(Ax*exp(Ax*ty)*sin(Bx*ty)+Bx*exp(Ax*ty)*cos(Bx*ty));
    
%plotfunmaket(A,b,t1,t2,t3,tx,ty,kk,mm,cc,GG,V1);
    
end
%%
function f  = nl_sys_prototype( x )
    global b;
    global U;
    global R;
    global k;
    global m;
    global G;
    global c;
    global L;
    global y;

    I=U/R;
%     Epsi=c/k;
%     T1=sqrt(m/k);
    T2=L/R;

    t1=0;
    t2=abs(real(x(1)));
    t3=abs(real(x(2)));
    
    C1a=real(x(3));
    C2a=real(x(4));
    C3a=0;%real(x(5));
    
    C1b=real(x(5));
    C2b=real(x(6));
    C3b=0;%real(x(8));
    
    V1=real(x(7));
    V2=real(x(8));

    x3=-1/T2;

    Ax=-c/(2*m);
    Bx=sqrt(k/m);
    
    f(1)=C1a*exp(Ax*t1)*cos(Bx*t1)+C2a*exp(Ax*t1)*sin(Bx*t1)+C3a*exp(x3*t1)-G*U/(k*I*R)-b+y/k;
    f(2)=C1a*exp(Ax*t2)*cos(Bx*t2)+C2a*exp(Ax*t2)*sin(Bx*t2)+C3a*exp(x3*t2)-G*U/(k*I*R)+b+y/k;    
    f(3)=C1b*exp(Ax*t2)*cos(Bx*t2)+C2b*exp(Ax*t2)*sin(Bx*t2)+C3b*exp(x3*t2)+G*U/(k*I*R)+b+y/k;
    f(4)=C1b*exp(Ax*t3)*cos(Bx*t3)+C2b*exp(Ax*t3)*sin(Bx*t3)+C3b*exp(x3*t3)+G*U/(k*I*R)-b+y/k;
    
    f(5)=C1a*(Ax*exp(Ax*t1)*cos(Bx*t1)-Bx*exp(Ax*t1)*sin(Bx*t1))...
        +C2a*(Ax*exp(Ax*t1)*sin(Bx*t1)+Bx*exp(Ax*t1)*cos(Bx*t1))...
         +x3*C3a*exp(x3*t1)-V1;
    f(6)=C1a*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2))...
        +C2a*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))...
         +x3*C3a*exp(x3*t2)-V2;
    f(7)=C1b*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2))...
        +C2b*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))...
         +x3*C3b*exp(x3*t2)-V2;
    f(8)=C1b*(Ax*exp(Ax*t3)*cos(Bx*t3)-Bx*exp(Ax*t3)*sin(Bx*t3))...
        +C2b*(Ax*exp(Ax*t3)*sin(Bx*t3)+Bx*exp(Ax*t3)*cos(Bx*t3))...
         +x3*C3b*exp(x3*t3)-V1;
end