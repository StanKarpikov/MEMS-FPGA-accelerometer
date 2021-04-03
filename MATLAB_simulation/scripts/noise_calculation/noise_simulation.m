%>
%> @file noise_simulation.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Runs the simulation of the sensor noise
%>

global c;
global Fkp;
global xeps;
global I;
global Epsi;
global T1;
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

global xx;

format compact;
format short e;

%> ------------------------------------------------------------------------
%> Global model parameters
%> ------------------------------------------------------------------------

comp=1;    % 1 - Run the simulation, 0 - Only show the results

spectr=0;  % 1 - Print the spectrum output

Inoise=1;  % Add current noise
Bnoise=0;  % Add magnetoc field noise
Xnoise=0;  % Add position noise
XTnoise=0; % Add temperature noise for the position
Unoise=0;  % Add voltage noise
Aact=0;    % External acceleration

%> ------------------------------------------------------------------------
%> Global sensor parameters
%> ------------------------------------------------------------------------

normal_time=18; % The number of oscillation periods before the start of operation 

c=2.5;          % Suspension stiffness
m=7e-7;         % Inertial mass
cd=0.0005;      % Damping coefficient
xeps=5e-6;      % Minimal threshold point
L=1e-3;         % Inductance
Fkp=10e-6;      % Power drivers force
I=1e-3;         % Coils current

Um=3.3;         % Power voltage
Ku=0.1/Um;
U=Ku*Um;        % Coils voltage

Kf=Fkp/I;
Fbr=0;
Amax=1.7;        % Maximum allowed acceleration in g

xeps_nom=xeps;
Inom=I;
Um_nom=Um;

%> ------------------------------------------------------------------------
%> Noise calculation settings
%> ------------------------------------------------------------------------

R=U/I;           % Coils resistance
df=100;          % Dynamic range (Hz)
Temp=273+85;     % Temperature [Kelvin]
kb=1.38e-23;     % Boltzmann constant

Um_noise=100e-6; % Noise in power voltage

%> ------------------------------------------------------------------------
%> Photo diodes settings
%> ------------------------------------------------------------------------

rise_time=5e-9; % Signal rise time [s]
Ileakage=5e-9;  % Dark current / Leakage current[A] 

Is_nom=2.5e-14; % Photodiode Shot noise [A]
Ij_nom=5.6e-15; % Photodiode Johnson noise [A]
Rload=100e3;    % Load resistance value [Ohm]
Rshunt=5e8;     % Shunt resistance value [Ohm]
Rseries=100;    % Serial resistance (10...1000) [Ohm]
Isignal=1e-5;   % Photo current [A]

%> ------------------------------------------------------------------------
%> Main algorithm
%> ------------------------------------------------------------------------

% Photodiode power voltage
Kum=((Isignal+Ileakage)*(Rload*Rshunt)/(Rload+Rshunt+Rseries))/Um;

if(comp)
    %---------------- Parameters to calculate -----------------------------
    T1=sqrt(m/c);
    Epsi=cd/c;
    %---------------- Modeling constants ----------------------------------
    
    N=0.5e6;        % The number of values
    maxT=0.0001;    % Simulation time limit [s]
    t_start=0;      % Simulation start [s]
    t_end=30;       % Simulation end [s]
    teps=(t_end-t_start)/N; % Time increase interval
    Nsm=round((t_end-t_start)/(2*pi*T1)*2);       % The number of switches
    
    %--------------- Modeling variables -----------------------------------
    
    t=0;            % Simulation timer
    ttt=0;          % Accumulator value for the timer
    t1=0;
    t2=-1.5e-3;
    t3=-3e-3;
    tnd=0;
    t2nd=1e-4;
    y=0;            % Extenal acceleration
    inn=1;          % Actual number of switches
    sgn=1;          % Power driver force direction, trigger value
    Aext=0;
    
    x=zeros(1,N);     % Coordinates array
    xp=zeros(1,N);    % Velocity array
    xpp=zeros(1,N);   % Acceleration array
    
    Anx=zeros(1,N);   % Applied acceleration array
    
    It=zeros(1,N);    % Current array
    It(1)=I;
    
    xepst=zeros(1,N);  % Photodiodes position array
    xepst(1)=xeps;
    
    Un=zeros(1,N);     % Voltages array
    Un(1)=Um;
    
    Fbrt=zeros(1,N);   % Brownian forces array 
    Fbrt(1)=Fbr;
    
    tau=zeros(1,Nsm);   % Measured acceleration array
    tn=zeros(1,Nsm);    % Timer array for switching points
    tx=zeros(1,Nsm);    % Timer array
    An=zeros(1,Nsm);    % Acceleration array
    
    Is_n=zeros(1,Nsm);
    Ij_n=zeros(1,Nsm);
    E0_n=zeros(1,Nsm);
    
    t3n=[];
    t2n=[];
    %---------------- Precalculation --------------------------------------
    ax=T1^2;
    bx=Epsi;
    cx=1;
    rx = roots([ax bx cx]);
    Bx=abs(imag(rx(1)));
    Ax=real(rx(1));
    %================== Calculation cycle =================================
    h = waitbar(0);
    for i=2:N
        %---------------------- Parameter changes -------------------------
        %------- Power voltage --------------------------------------------
        if(Unoise)
            Um=Um_nom+Um_noise*(rand()-0.5)*2; %#ok<*UNRCH>
            U=Ku*Um;
        end
        Un(i)=Um;
        %------- Current (Johnson–Nyquist noise) Irms=G*sqrt(4*kb*Temp*df/R)
        % I=Inom+Inom*0.01*(rand()-0.5)*2;
        Irms=sqrt(4*kb*Temp*df/R);
        if(Inoise)
            I=Inom+Irms*(rand()-0.5)*2;
        end
        It(i)=I;
        %------- Brownian movement S=4*kb*Temp*m*w0/Q ---------------------
        % w0/Q=Epsi*c/m;
        S=sqrt(4*kb*Temp*Epsi*c);
        if(Bnoise)
            Fbr=S*(rand()-0.5)*2;
        end
        Fbrt(i)=Fbr;
        %------- Diffraction ----------------------------------------------
        if(Xnoise)
            xeps=xeps_nom+xeps_nom*0.01/100*(rand()-0.5)*2;
        end
        xepst(i)=xeps;
        %----------------------- Waitbar ----------------------------------
        if(rem(i,N/1000)==0)
            waitbar(i/N,h, sprintf('Progress\n%.2f%%',100*i/N));
        end
        %------------------ External acceleration -------------------------
        if(Aact)
            Aext=-Amax/10+(ttt+t-t_start)/(t_end-t_start)*(Amax+Amax/10);
        end
        Anx(i)=Aext;
        y=Aext*m*9.8;
        %------------------ Timer processing ------------------------------
        t=t+teps;
        tnd=tnd+teps;
        %----------------------- Clearing ---------------------------------
        if(t>maxT)
            ttt=ttt+t;
            t=0;
        end
        
        tx(i)=t+ttt;
        %------------------ Equiation solve -------------------------------
        [x(i),xp(i),xpp(i)]=compute_sensing_element_position(t,tx(i-1)-ttt,x(i-1),xp(i-1),xpp(i-1));
        %------------------ Non-linear element switch ---------------------
        if(x(i)>=xeps && sgn==-1)
            k=(tx(i)-tx(i-1))/(x(i)-x(i-1));
            t2=tx(i-1)+(xeps-x(i-1))*k;         % Switching time
            %t2nd=tnd-teps+(xeps-x(i-1))*k;
            %--------------- More accurate time calculation ---------------
            xx=xeps;      
            %t2=compute_accurate_time(t2-ttt,tx(i-1)-ttt,x(i-1),xp(i-1),xpp(i-1))+ttt;
            %--------------- Noise ----------------------------------------
            if(XTnoise)
                Is=Is_nom*(rand()-0.5)*2;
                Ij=Ij_nom*(rand()-0.5)*2;
                Inoise=sqrt(Is^2+Ij^2);     % Full noise
                Inoise_n(inn)=Inoise;
                E0=(Isignal+Ileakage+Inoise)*(Rload*Rshunt)/(Rload+Rshunt+Rseries)/2;   % Threshold level 1/2
                E0_n(inn)=E0;
                
                t2=t2+rise_time/(Kum*Um/E0); % Switching time delay due to the noise
            end
            
            t=t2-ttt;   % Timer correction
            tx(i)=t2;
            %t2n=[t2n,t2-t1];
            % Position correction
            [x(i),xp(i),xpp(i)]=compute_sensing_element_position(t,tx(i-1)-ttt,x(i-1),xp(i-1),xpp(i-1));
            
            sgn=1;      % Trigger switch
        end
        if(x(i)<=-xeps && sgn==1)
            t1=t3;
            
            k=(tx(i)-tx(i-1))/(x(i)-x(i-1));
            t3=tx(i-1)+(-xeps-x(i-1))*k;         % Switching time
            %tnd=tnd-teps+(xeps-x(i-1))*k;
            %--------------- More accurate time calculation ---------------
            xx=-xeps;            
            %t3=compute_accurate_time(t3-ttt,tx(i-1)-ttt,x(i-1),xp(i-1),xpp(i-1))+ttt;
            %--------------- Noise ----------------------------------------
            if(XTnoise)
                Is=Is_nom*(rand()-0.5)*2;
                Ij=Ij_nom*(rand()-0.5)*2;
                Is_n(inn)=Is;
                Ij_n(inn)=Ij;
                E0=(Isignal+Ileakage+Is+Ij)*(Rload*Rshunt)/(Rload+Rshunt+Rseries)/2;   % Threshold level 1/2
                E0_n(inn)=E0;
                
                t3=t3+rise_time/(Kum*Um/E0); % Switching time delay due to the noise
            end
            
            t=t3-ttt;   % Timer correction
            tx(i)=t3;
            %t3n=[t3n,t3-t1];
            
            % Position correction
            [x(i),xp(i),xpp(i)]=compute_sensing_element_position(t,tx(i-1)-ttt,x(i-1),xp(i-1),xpp(i-1));
            
            sgn=-1;     % Trigger switch
            
            % Mesured acceleration calculation
            tau1=t3-t2;
            tau2=t2-t1;
            %tau1=tnd-t2nd;
            %tau2=t2nd;
            tau(inn)=(tau1-tau2)/(tau1+tau2);
            tn(inn)=tx(i);
            An(inn)=Aext;
            
            %tnd=0;
            
            inn=inn+1;
        end
    end
    %------------------------------- Array trim ---------------------------
    inn=inn-1;
    tau=tau(1:inn);
    tn=tn(1:inn);
    An=An(1:inn);
    Is_n=Is_n(1:inn);
    Ij_n=Ij_n(1:inn);
    E0_n=E0_n(1:inn);
end
%=============================== Results ==================================
set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',12,'DefaultTextFontName','Times New Roman');
%--------------------------------------------------------------------------
plot(tn(normal_time:length(tn)),tau(normal_time:length(tau)),'b');
figure;

plot(tx,x,'b');
figure;

%subplot(2,2,1);
hist(tau(normal_time:length(tau))/0.5*100,12);  % Error in percent from maximum
title('Tau');
figure;

%subplot(2,2,2);
hist(It-Inom,12);
title('I');

figure;
%subplot(2,2,3);
hist(Fbrt,12);
title('Fbr');
figure;

%subplot(2,2,4);
hist(xepst-xeps_nom,12);
title('Xeps');
figure;

%subplot(2,2,1);
hist(Is_n,12);
title('Is');
figure;
%subplot(2,2,3);
hist(Ij_n,12);
title('Ij');
figure;
%subplot(2,2,2);
hist(E0_n-Kum*Um_nom/2,12);
title('E0');
figure;
%subplot(2,2,4);
hist(Un-Um_nom,12);
title('Um');

% figure;
% plot(t2n(normal_time:length(t2n))-t2n(normal_time));
% figure;
% plot(t3n(normal_time:length(t3n))-t3n(normal_time),'r');

%---------------------- Spectrum ------------------------------------------
if(spectr)
    %s = tau(normal_time:length(tau))/0.5*100; % Signal
    s=It-Inom;
    dt = teps;%tn(150)-tn(149); % Discretisation interval
    Fs = 1/dt; % Frequency
    N = length(s); % Signal length
    f = (0:N-1)/N*Fs; % FFT vector of frequencies
    figure;
    sfft=abs(fft(s));
    plot(f, sfft);
    axis([0 1/teps 0 max(sfft)]);
end