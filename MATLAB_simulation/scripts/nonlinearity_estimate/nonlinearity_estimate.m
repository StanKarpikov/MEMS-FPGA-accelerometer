%>
%> @file nonlinearity_estimate.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Calculates and compares the nonlinearity for different settings
%>

%> ------------------------------------------------------------------------
%> Global model parameters
%> ------------------------------------------------------------------------

NeedCompute=1;% Set to 1 to run calculation. Otherwice prints the result
close all;

if(NeedCompute)
    nclear NeedCompute
end
set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Times New Roman'); 

global externalF;
externalF=0;

global DWIDTH;
DWIDTH=2;

ShowGraphs=1;
ShowGraphs2=0;

global Fkp;
global Fdirnowneed;
global Fdirnow;
global ttstart;
global tfinal;
global fstart
global ffinish
global Amp
global t_last_kp;
global t_start_crit;
global xepsA;
global xepsB;
global xepsAoff;
global xepsBoff;
global tfstart;
global FintextKP;
global Fint;
global ax;
global bx;
global cx;
global dx;
global m;
global c;
global cd;
global T1;
global t_next_stop;

%> ------------------------------------------------------------------------
%> Global sensor parameters
%> ------------------------------------------------------------------------

if(NeedCompute)
    c=double(2.5);
    m=double(7e-7);
    
    cd=double(0.00005);
    
    r=double(0.1);
    Rx=double(300);
    T1=double(sqrt(m/c));
    L=double(0.1e-3);
    T2=double(L/(Rx+r));
    Eps=double(cd/c);
    I=double(1e-3);
    K=double(1);
    U=double(1);
    
    ax=((T1^2)*T2);
    bx=(T1^2+Eps*T2);
    cx=(Eps+T2);
    dx=1;
    
    % Resonant frequency
    fres=sqrt(c/m)*sqrt(1-(cd/(2*sqrt(c*m)))^2)/6.28
    %f=sqrt(c/m)/6.28
    %ksi=cd/(2*sqrt(c*m))
    
    Fintext=900;
    FintextKP=1550e-6*externalF;
    Fint=1;
    
    Fkp=1550e-6*(1-externalF);
    Fdirnow=-1;
    Fdirnowneed=Fdirnow;
    Amp=1;% External acceleration
    fstart  = 0;
    ffinish = 1500;
    tfstart = 0.05;
    
    xepsA=atan(7e-6/2e-3);
    xepsB=atan(7e-6/2e-3);
    
    xepsAoff=inf;%4e-6;
    xepsBoff=inf;%4e-6;
    
    t_OFF_A=100e-4;
    t_OFF_B=100e-4;
    
    tstart = tfstart-tfstart;% Start time
    ttstart=tstart;    
    tfinal = 5; % The end time
    tfinish=5;
    t_next_stop=tfinal;
    % [tmp ind]=min(abs(sArray_t_OFF_A-t_OFF_A));
    %  Amp=Amp*1.790480677548652e-04/stau(ind)
    
    t_start_crit=0.5;%10.3;
    y0 = zeros(DWIDTH,1);
      %   y0 = [3e-5,0];
    %     y0 = [0,0,0];
    refine = 4;
    options = odeset('Events',@events,...
        'Refine',refine,'RelTol',1e-6,'AbsTol',1e-8);
    % NOTE: Additional parameters:
    %'OutputFcn',@odeplotmy,'OutputSel',[1 3],  ...
    
    %     fig = figure;
    %     ax = axes;
    %     ax.XLim = [tstart tfinal];
    %   % ax.YLim = [-1.5e-4 1.5e-4];
    %     box on
    %     hold on;
    
    tout = zeros(400000*10,1);
    yout = zeros(400000*10,DWIDTH);
    teout = zeros(20000*10,1);
    yeout = zeros(20000*10,DWIDTH);
    ieout = zeros(size(teout));
    h = waitbar(0);
    lastr=0;
    tfinter=zeros(5000*10,1);
    finter=zeros(size(tfinter));
    tau=zeros(size(tfinter));
    itau=zeros(size(tfinter));
    %     Array_t_OFF_A=zeros(size(tau));
    %     Array_t_OFF_B=zeros(size(tau));
    %     Array_Amp=zeros(size(tau));
    fkpint=zeros(40000*10,1);
    tkpint=zeros(size(fkpint));
    t_last_kp=0;
    t_1=0;
    t_2=1e-3;
    t_3=2e-3;
    tpA=0;
    t_lapse1=0;
    t_lapse2=0;
    t_lapse3=0;
    format compact;
    
    i_tout=1;
    i_teout=1;
    i_tau=1;
    i_kp=1;
    
    %     kp=double(1.34);
    %     ki=double(1.0);
    %     kd=double(0.4);
    
    e=double(0);
    e1=double(0);
    e2=double(0);
    %     k1=kp+ki+kd;
    %     k2=-kp-2*kd;
    %     k3=kd;
    
    k1=double(3.4029e+03);
    k2=double(-0.6514e+03);
    k3=double(0.1620e+03);
    
%> ------------------------------------------------------------------------
%> Calculation
%> ------------------------------------------------------------------------

    lasty=1;
    while tstart<tfinal
        if(round(10000*tstart/tfinal)>lastr)
            lastr=round(10000*tstart/tfinal);
            waitbar(tstart/tfinal,h, sprintf('Progress\n%.2f%%',100*tstart/tfinal));
            %  t_lapse1
            %  t_lapse2
        end
        % Solve until the first terminal event.
        tic;
        if(externalF)
            [t,y,te,ye,ie] = ode23(@equations,[tstart tstart+1/Fintext/2],y0,options);
            Fint=-Fint;
        else
            [t,y,te,ye,ie] = ode23(@equations,[tstart tfinal],y0,options);
        end
        t_lapse1=toc;
        tic;
        % Accumulate output.  This could be passed out as output arguments.
        nt = length(t);
        tout(i_tout:i_tout+(nt-2)) = t(2:nt);
        yout(i_tout:i_tout+(nt-2),:) = y(2:nt,:);
        i_tout=i_tout+(nt-2);
        
        % Set the new initial conditions, with        
        y0(1) = y(end,1);
        y0(2) = y(end,2);
       % y(end,2)
       % y0(2)
        if(DWIDTH==3)
            y0(3) = y(nt,3);
        end
        
        if(~isempty(ie))
            i_end=i_teout+length(te)-1;
            teout(i_teout:i_end) = te;          % Events at tstart are never reported.
            yeout(i_teout:i_end,:) = ye(:,:);
            ieout(i_teout:i_end) = ie;
            i_teout=i_end+1;
            
            for j=1:length(ie)
                switch ie(j)
                    case 1
                        Fdirnow = -1;
                        t_2=te(j);
                        Fdirnowneed=Fdirnow;
                        if(i_teout>3)
                        %    options = odeset(options,'InitialStep',teout(i_teout-2)-teout(i_teout-3));
                        end
                        
                        t_next_stop=te(j)+t_OFF_B;
                    case 2
                        Fdirnow = 1;
                        
                        t_3=te(j);
                        tau1=(t_3-t_2);
                        tau2=(t_2-t_1);
                        tpA=(tau1-tau2)/(tau1+tau2);
                        t_1=t_3;
                        
                        i_tau=i_tau+1;
                        tau(i_tau)=tpA;
                        itau(i_tau)=geta((te(j)+tfinter(i_tau-1))/2);
                        finter(i_tau)= 1/(te(j)-tfinter(i_tau-1));
                        tfinter(i_tau) = te(j);
                        
                        e2=e1;
                        e1=e;
                        e=tau(i_tau);
                        Fdirnowneed=Fdirnow;
                        if(i_teout>3)
                       %     options = odeset(options,'InitialStep',teout(i_teout-2)-teout(i_teout-3));
                        end
                        %----
                        t_next_stop=te(j)+t_OFF_A;
                    case 3
                        Fdirnow = 0;
                        if(i_teout>3)
                       %     options = odeset(options,'InitialStep',teout(i_teout-2)-teout(i_teout-3));
                        end
                    case 4
                        Fdirnow = 0;
                        if(i_teout>3)
                       %     options = odeset(options,'InitialStep',teout(i_teout-2)-teout(i_teout-3));
                        end
                    case 5
                        Fdirnow = 0;
                      %  options = odeset(options,'InitialStep',3e-8);
                end
            end
        end
        t_last_kp=t(nt);
        i_kp=i_kp+1;
        fkpint(i_kp)=fkpint(i_kp-1);
        tkpint(i_kp)=t_last_kp;
        
        i_kp=i_kp+1;
        fkpint(i_kp)=Fdirnow;
        tkpint(i_kp)=t_last_kp;
        
        tstart = t(nt);
        t_lapse2=toc;
        if(t(nt)>tfinish)
            break;
        end
    end
    tout=tout(1:i_tout);
    yout=yout(1:i_tout,:);
    
    teout=teout(1:i_teout);          % Events at tstart are never reported.
    yeout=yeout(1:i_teout,:);
    ieout=ieout(1:i_teout);
    
    finter=finter(1:i_tau-20);
    tfinter=tfinter(1:i_tau-20);
    tau=tau(1:i_tau-20);
    itau=itau(1:i_tau-20);
    
    fkpint=fkpint(1:i_kp);
    tkpint=tkpint(1:i_kp);

end

%> ------------------------------------------------------------------------
%> Results
%> ------------------------------------------------------------------------

%%
if(ShowGraphs)
    tau=tau(find(tfinter>(tfstart+ttstart)));
    itau=itau(find(tfinter>(tfstart+ttstart)));
    finter=finter(find(tfinter>(tfstart+ttstart)));
    tfinter=tfinter(find(tfinter>(tfstart+ttstart)));
    
    figure;
    plot(tfinter,tau,'-');
    %   plot(tfinter,tau,'b-');
    xlabel('tau');
    ylabel('time');
    
    figure;
    plot(tout,yout(:,1));
    %     plot(tout(find(tout>0.3797)),yout((find(tout>0.3797)),3),'r-');
    xlabel('x');
    ylabel('time');
    hold on;
    fmax=max(yout(:,1))*0.4;
        plot(tkpint,fkpint*fmax,':');
    
    plot(teout(find(ieout==1)),yeout(find(ieout==1),1),'kx')
    plot(teout(find(ieout==2)),yeout(find(ieout==2),1),'rx')
    plot(teout(find(ieout==3)),yeout(find(ieout==3),1),'ko')
    plot(teout(find(ieout==4)),yeout(find(ieout==4),1),'ro')
    plot(teout(find(ieout==5)),yeout(find(ieout==5),1),'g+')
    
    
    if(ShowGraphs2)
        figure;
        fext=zeros(length(tout),1);
        for i=1:length(tout)
            fext(i)=getf(tout(i));
        end
        plot(tout,fext);
        xlabel('fext');
        ylabel('time');
        
        figure;
        aext=zeros(length(tout),1);
        for i=1:length(tout)
            aext(i)=geta(tout(i));
        end
        plot(tout,aext);
        axis([min(tout) max(tout) min(aext)*1.2 max(aext)*1.2]);
        xlabel('aext');
        ylabel('time');
    end
    
    xtau=tau;
    
    figure;
    plot(itau,xtau);
    hold on;
    plot(itau,itau/3500);

 %  fampT = linspace(min(itau),max(itau),50);
 %  [ampT,fampT] = interpmax(itau,xtau,fampT);
 %  fampT=[0,fampT];
 %  ampT=[ampT(1),ampT];
 %  plot(fampT,ampT);

    title(' Tau');
    xlabel('A');
    ylabel('tau');
    
  %  figure;
  %  plot(fextf,finter);    
  %  title('Frequency response F');
  %  xlabel('f/fres');
  %  ylabel('F');
end
%%
function dydt = equations(t,y)
    global ax;
    global bx;
    global cx;
    global dx;
    global Fkp;
    global Fdirnow
    global FintextKP;
    global Fint;
    global m;
    global cd;
    global c;
    global T1;
    global DWIDTH;
    % x   = y(1) [м]
    % x'  = y(2) = v [м/с]
    % x'' = y(3) = a [м/с^2]
    % ax=((T1^2)*T2) [с^3];
    % bx=(T1^2+Eps*T2) [с^2];
    % cx=(Eps+T2) [с];
    % dx=1 [1];
    dydt=zeros(DWIDTH,1);
    l=1e-3;
    l1=200e-6;
    l2=2e-3;
    I=m*(l2^3/3-l1^3/3);
    if(DWIDTH==3)
        dydt(1) = y(2);%[м/с]
        dydt(2) = y(3);%[м/с^2]
        dydt(3) = (-bx*y(3)-cx*y(2)-dx*y(1)+(FintextKP*Fint+Fdirnow*Fkp)/m*T1^2+geta(t)*T1^2)/ax;% [м/с^3]
    else
        dydt(1) = y(2);
       % dydt(2) = geta(t)/l*cos(y(1))+Fdirnow*Fkp*l*cos(y(1))/I-cd*l*y(2)/I-c*y(1)/I;%[град/с2]
        dydt(2) = geta(t)/l*cos(y(1))+Fdirnow*Fkp*l*cos(y(1))/I/314-cd*y(2)/m-c*y(1)/m;%[град/с2]
       % y(1)
       %t
    end
end
%%
function [value,isterminal,direction] = events(t,y)
    % Locate the time when height passes through zero in a decreasing direction
    % and stop integration.
    global Fdirnowneed;
    global xepsA;
    global xepsB;
    global xepsAoff;
    global xepsBoff;
    global t_next_stop;
    global externalF;
    value=zeros(4,1);
    value(1) = (xepsA)-y(1);
    value(2) = (-xepsB)-y(1);
    value(3) = (xepsAoff)-y(1);
    value(4) = (-xepsBoff)-y(1);
    value(5) = t_next_stop-t;

    if(externalF)
        isterminal = [0;0;0;0;0];   % stop the integration
    else
        isterminal = [1;1;0;0;0];   % stop the integration
    end
    direction = [-1;1;-1;1;-1];   % both direction
end
%%
function ay = geta(t)
    global Amp
    global tfstart
    ay=t*720;
    %ay=Amp*sin(t*getf(t)*1*pi);%почему 1???
    %     if(t>tfstart+0.1)
    %         ay=3;
    %     else
    %         ay=0;
    %     end
end
%%
function fy = getf(t)
    global fstart
    global ffinish
    global tfinal
    global tfstart
    if(t>tfstart)
        fy=fstart+(ffinish-fstart)*(t-tfstart)/(tfinal-tfstart);
    else
        fy=0;
    end
end
%%
function [ind, mask] = pos_max(x)
    % function ind = pos_max(x)
    % returns positions of all maximums in vector x
    % for example, pos_max([1 2 3 4 3 4 5 4 3 4 5])
    % returns
    % [4 7]

    xd = diff(x);
    xds = sign(xd);
    ix = (xds(1:end-1)~=xds(2:end)); % all extrema
    ix = ix & (xds(1:end-1)>0); % only maximums
    mask(2:length(ix)+1) = ix;
    ind = find(mask);
end
%%
function [ind, mask] = pos_min(x)
    % function ind = pos_min(x)
    % returns positions of all minima in vector x
    % for example, pos_min([1 2 3 4 3 4 5 4 3 4 5])
    % returns
    % [5 9]

    xd = diff(x);
    xds = sign(xd);
    ix = (xds(1:end-1)~=xds(2:end)); % all extrema
    ix = ix & (xds(1:end-1)<0); % only minima
    mask(2:length(ix)+1) = ix;
    ind = find(mask);
end
%%
function nclear(varargin)
    tmp = evalin('base','whos');
    tmp = sprintf('%s ',tmp(~ismember({tmp.name},varargin)).name);
    evalin('base',['clear ' tmp]);
end
%%
function [yi,xii] = interpmax(x,y,xi)
    xstep=(x(end)-x(1))/length(xi);
    nextx=x(1);
    yi=zeros(size(xi));
    xii=zeros(size(xi));
    lm=0;
    for i=1:length(xi)
        nextx=nextx+xstep;
        array=find(x<nextx);
        if(isempty(y(array>lm)))
            if(i>1)
                xii(i)=xii(i-1);
                yi(i)=yi(i-1);
                xii(i)=xii(i-1);
            else
                xii(i)=0;
                yi(i)=0;
                xii(i)=0;
            end
        else
            [yi(i),ind]=max(y(array>lm));
            xiia=x(array>lm);
            xii(i)=xiia(ind);
        end
        lm=max(array);
    end
end