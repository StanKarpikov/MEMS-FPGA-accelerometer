%>
%> @file frequency_response_analitical.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Runs the frquency responce calculation of the sensor using three aproaches
%>

%> ------------------------------------------------------------------------
%> Global model parameters
%> ------------------------------------------------------------------------

clear;
global A;
global B;
global m;
global k;
global Wo;
global xeps;
global cd;
global Gmax;

run_calculation = 1; % Set to 1 to run the calculation. Otherwise, prints the output
    
% Parameters. See calculate_parameters_for_prototype.m

k =   0.0655;     % Suspension stiffness
m =   9.7475e-07; % Inertial mass
cd =  1.0729e-05; % Damping coefficient
Gmax = 0.0010;    % Maximum force
xeps = ((1.36+0.57)/2)*pi/180;
A = (9.53/2)*pi/180;  % Oscillation magnitude
B = 9.8/3e-3;         % External acceleration magnitude

%> ------------------------------------------------------------------------
%> Calculation
%> ------------------------------------------------------------------------

h = waitbar(0,'Initializing waitbar...');
if(run_calculation)
    N=200;            % Number of points
    maxW=sqrt(k/m)*1; % Maximum frequency

    % Initial values
    tn=zeros(1,N);
    x =zeros(1,N);
    xa=zeros(1,N);
    xs=zeros(1,N);
    xr=zeros(1,N);
    Weps=maxW/N;
    Wo=0;

    % Calculation
    tx=[1 1 1];
    for  t=1:N
        tn(t)=Wo;
        waitbar(t/N,h,sprintf('%2.0f%% ...',t/N*100));
        Wo=Wo+Weps;
        %---------------------- Solution 1-----------------------------------
        d=Wo^2*sqrt(m/k)*B*m/(2*A*k);
        b=xeps/A;
        c=B*m/(k*A);
        
         tx(1)=(1-sqrt(1-4*d*sqrt(m/k)*(b-c)))/(2*d);
         tx(2)=(1-sqrt(1+4*d*sqrt(m/k)*(b+c+pi)))/(-2*d);
         tx(3)=(1-sqrt(1-4*d*sqrt(m/k)*(b-c+2*pi)))/(2*d);
 
         xa(t)=max((2*tx(2)-tx(1)-tx(3))/(tx(3)-tx(1)),0);
        if(t~=1)
            xa(t)=xa(t)/xa(1); 
        end
        %---------------------- Solution 2-----------------------------------
        tx=fsolve(@nl_sys_t1t2t3,[1 1 1],...
           optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
        
        tx(1)=abs(real(tx(1)));
        tx(2)=abs(real(tx(2)));
        tx(3)=abs(real(tx(3)));

        x(t)=max((2*tx(2)-tx(1)-tx(3))/(tx(3)-tx(1)),0);
        
        if(t~=1)
            x(t)=x(t)/x(1); 
        end
        %---------------------- Solution 3-----------------------------------
        tx=fsolve(@nl_sys_t1t2t3_asin,[0 10e-3 21.86e-3],...
           optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
        format short;
        tx(1)=abs(real(tx(1)));
        tx(2)=abs(real(tx(2)));
        tx(3)=abs(real(tx(3)));

        xs(t)=max((2*tx(2)-tx(1)-tx(3))/(tx(3)-tx(1)),0);
        if(t~=1)
            xs(t)=xs(t)/xs(1); 
        end
        %---------------------- Solution 4-----------------------------------
        tx=fsolve(@nl_sys_fmax,[0 0.002 0.003 1 1 1 1 1 1],...
           optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));

        format short;
        tx(1)=abs(real(tx(1)));
        tx(2)=abs(real(tx(2)));
        tx(3)=abs(real(tx(3)));

        xr(t)=(2*tx(2)-tx(1)-tx(3))/(tx(3)-tx(1))*150/18;
        if(t~=1)
            xr(t)=xr(t)/xr(1); 
        end
    end
end

%> ------------------------------------------------------------------------
%> Results
%> ------------------------------------------------------------------------

close(h);
set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman'); 
set(0,'DefaultTextFontSize',12,'DefaultTextFontName','Times New Roman');
%plot(tn./(2*pi),xr,'r');
x(1)=1;

if(1)    
    plot(tn./(2*pi),x,'k');
    axis([0 maxW/2/pi -1 1.1])
    hold on;    
    plot(tn./(2*pi),xs,'g');
    plot(tn./(2*pi),xa,'b');    
%   plot(tn./(2*pi),xr,'r'); 
    plot([0 maxW/2/pi],[1/sqrt(2) 1/sqrt(2)],'k','LineWidth',1);
end
%%
Bn=rms(xs)*length(xs);
%Bn=Bn/max(Bn);

%> ------------------------------------------------------------------------
%> Local functions
%> ------------------------------------------------------------------------

%%
function f  = nl_sys_fmax( x )
    %x(1)=t1
    %x(2)=t2
    %x(3)=t3
    %x(4)=C1
    %x(5)=C2
    %x(6)=C3
    %x(7)=C4
    %x(8)=V0
    %x(9)=V1

    global B;
    global m;
    global k;
    global Wo;
    global xeps;
    global cd;
    global Gmax;

    l=-cd/(2*m)+sqrt((cd/m)^2-4*k/m)/2;
    Bx=imag(l);
    Ax=real(l);

    f(1)=x(4)*exp(Ax*abs(real(x(1))))*cos(Bx*abs(real(x(1))))...
        +x(5)*exp(Ax*abs(real(x(1))))*sin(Bx*abs(real(x(1))))-Gmax/k-xeps+B*cos(Wo*abs(real(x(1))))*m/k;
    f(2)=x(4)*exp(Ax*abs(real(x(2))))*cos(Bx*abs(real(x(2))))...
        +x(5)*exp(Ax*abs(real(x(2))))*sin(Bx*abs(real(x(2))))-Gmax/k+xeps+B*cos(Wo*abs(real(x(2))))*m/k;

    f(3)=x(6)*exp(Ax*abs(real(x(2))))*cos(Bx*abs(real(x(2))))...
        +x(7)*exp(Ax*abs(real(x(2))))*sin(Bx*abs(real(x(2))))+Gmax/k+xeps+B*cos(Wo*abs(real(x(2))))*m/k;
    f(4)=x(6)*exp(Ax*abs(real(x(3))))*cos(Bx*abs(real(x(3))))...
        +x(7)*exp(Ax*abs(real(x(3))))*sin(Bx*abs(real(x(3))))+Gmax/k-xeps+B*cos(Wo*abs(real(x(3))))*m/k;

    f(5)=x(4)*(Ax*exp(Ax*abs(real(x(1))))*cos(Bx*abs(real(x(1))))...
        -Bx*exp(Ax*abs(real(x(1))))*sin(Bx*abs(real(x(1)))))...
        +x(5)*(Ax*exp(Ax*abs(real(x(1))))*sin(Bx*abs(real(x(1))))...
        +Bx*exp(Ax*abs(real(x(1))))*cos(Bx*abs(real(x(1)))))...
        -Wo*B*sin(Wo*abs(real(x(1))))*m/k-x(8);

    f(6)=x(6)*(Ax*exp(Ax*abs(real(x(3))))*cos(Bx*abs(real(x(3))))...
        -Bx*exp(Ax*abs(real(x(3))))*sin(Bx*abs(real(x(3)))))...
        +x(7)*(Ax*exp(Ax*abs(real(x(3))))*sin(Bx*abs(real(x(3))))...
        +Bx*exp(Ax*abs(real(x(3))))*cos(Bx*abs(real(x(3)))))...
        -Wo*B*sin(Wo*abs(real(x(3))))*m/k-x(8);

    f(7)=x(4)*(Ax*exp(Ax*abs(real(x(2))))*cos(Bx*abs(real(x(2))))...
        -Bx*exp(Ax*abs(real(x(2))))*sin(Bx*abs(real(x(2)))))...
        +x(5)*(Ax*exp(Ax*abs(real(x(2))))*sin(Bx*abs(real(x(2))))...
        +Bx*exp(Ax*abs(real(x(2))))*cos(Bx*abs(real(x(2)))))...
        -Wo*B*sin(Wo*abs(real(x(2))))*m/k-x(9);

    f(8)=x(6)*(Ax*exp(Ax*abs(real(x(2))))*cos(Bx*abs(real(x(2))))...
        -Bx*exp(Ax*abs(real(x(2))))*sin(Bx*abs(real(x(2)))))...
        +x(7)*(Ax*exp(Ax*abs(real(x(2))))*sin(Bx*abs(real(x(2))))...
        +Bx*exp(Ax*abs(real(x(2))))*cos(Bx*abs(real(x(2)))))...
        -Wo*B*sin(Wo*abs(real(x(2))))*m/k-x(9);

    f(9)=x(1);

end
%%
function f  = nl_sys_t1t2t3( x )
    global A;
    global B;
    global m;
    global k;
    global Wo;
    global xeps;

    f(1)=abs(x(1))-sqrt(m/k)*((xeps-B*m/k*cos(Wo*abs(x(1))))/A);
    f(2)=abs(x(2))-sqrt(m/k)*((xeps+B*m/k*cos(Wo*abs(x(2))))/A+pi);
    f(3)=abs(x(3))-sqrt(m/k)*((xeps-B*m/k*cos(Wo*abs(x(3))))/A+2*pi);
end
%%
function f  = nl_sys_t1t2t3_asin( x )
    global A;
    global B;
    global m;
    global k;
    global Wo;
    global xeps;

    f(1)=abs(real(x(1)))-sqrt(m/k)*(asin((xeps-B*m/k*cos(Wo*abs(real(x(1)))))/A));
    f(2)=abs(real(x(2)))-sqrt(m/k)*(asin((xeps+B*m/k*cos(Wo*abs(real(x(2)))))/A)+pi);
    f(3)=abs(real(x(3)))-sqrt(m/k)*(asin((xeps-B*m/k*cos(Wo*abs(real(x(3)))))/A)+2*pi);
end