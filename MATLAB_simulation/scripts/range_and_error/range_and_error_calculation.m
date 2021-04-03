%>
%> @file range_and_error_calculation.m
%>
%> @author Stanislav Karpikov
%>
%> @brief Calculate the range and error for the sensor
%>

%> ------------------------------------------------------------------------
%> Global model parameters
%> ------------------------------------------------------------------------

global c;
global Fkp;
global xeps;
global I;
global Rx;
global r;
global Epsi;
global T1;
global T2;
global y;
global U;
global A;
global W;

format compact;
format short e;

% Enable/Disable computation stages
R1=1;
R2=1;
R3=1;

R2full=1;
R2fulllin=1;
R2simple=1;

R1linmodel=1;
R1fullmodel=1;

%> ------------------------------------------------------------------------
%> Global sensor parameters
%> ------------------------------------------------------------------------

c=3;
m=20e-7;
cd=0.0001;
xeps=15e-6;
r=0.1;
Rx=300;
L=32e-2;
I=1e-3;
K=1;
Fkp=50e-6;
U=1;

T1=sqrt(m/c);
T2=L/(Rx+r);
Epsi=cd/c;
N=500;
Amax=1400;
%%
if(R1)
    N=4e6; % Set the number of points
    Nsm=5000;
    
    t1=0;
    t3=10;
    %   tst1=0.2;
    %   tst2=0.7;
    tst=0.5;
    maxT=0.001;
    
    if(R1linmodel)
        y=0;
        yd=0;
        
        xans=fsolve(@NL_sys_lin_mich,[1 1],optimset('Display','off', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
        A=abs(xans(1))*1e-6;
        W=xans(2);
        q=4*U/(pi*A)*sqrt(1-(xeps^2)/(A^2));
        qp=-4*U*xeps/(pi*A^2);
        axl=((T1^2)*T2);
        bxl=(T1^2+Epsi*T2);
        cxl=(Epsi+Fkp*qp/(c*I*(Rx+r)*W)+T2);
        dxl=(Fkp*q/(c*I*(Rx+r))+1);
        rxl = roots([axl bxl cxl dxl]);
        if(isreal(rxl(1)))
            x1=rxl(1);
            Axl=real(rxl(2));
            Bxl=abs(imag(rxl(2)));
        elseif(isreal(rxl(2)))
            x1=rxl(2);
            Axl=reall(rx(1));
            Bxl=abs(imag(rxl(1)));
        elseif(isreal(rxl(3)))
            x1=rxl(3);
            Axl=real(rxl(1));
            Bxl=abs(imag(rxl(1)));
        end
        
        in=1;
        
        
        x=zeros(1,N);
        tx=zeros(1,N);
        x(1)=0;
        xp=A*W;
        xpp=0;
        t=0;
        h = waitbar(0);
        ttt=0;
        
        t1x=0;
        t2x=-0.0015;
        t3x=-0.003;
        t3n=-0.003;
        
        full_Al=zeros(1,Nsm);
        
        full_Alt=zeros(1,Nsm);
        
        n3=zeros(1,Nsm);
        n3x=zeros(1,Nsm);
        txn=zeros(1,Nsm);
        Axn=zeros(1,Nsm);
        
        Aext=0;
        FkpU=Fkp/(c*I*(Rx+r));
        
        iAstartL=1;
        stL=0;
        stt=1;
        %---------
        expx1t=exp(x1*t);
        expAxlt=exp(Axl*t);
        cosBxlt=cos(Bxl*t);
        sinBxlt=sin(Bxl*t);
        expcos=expAxlt*cosBxlt;
        expsin=expAxlt*sinBxlt;
        Tm=[expx1t ...
            expcos ...
            expsin;...
            
            x1*expx1t ...
            (Axl*expcos-Bxl*expsin) ...
            (Axl*expsin+Bxl*expcos);...
            
            x1^2*expx1t ...
            (Axl^2*expcos-Axl*Bxl*expsin-...
            Bxl*Axl*expsin-Bxl^2*expcos) ...
            (Axl^2*expsin+Axl*Bxl*expcos+...
            Bxl*Axl*expcos-Bxl^2*expsin)];
        Tm=Tm^-1;
        C=Tm*[(x(1)+yd/c/(FkpU*q+1)) xp xpp]';
        C1=C(1);
        C2=C(2);
        C3=C(3);

        Alin=[];
        ylin=[];
        for i=2:N
            if(rem(i,N/1000)==0)
                waitbar(i/N,h, sprintf('Progress\n%.2f%%',100*i/N));
                xans=fsolve(@NL_sys_lin_mich,xans,optimset('Display','off', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
                A=abs(xans(1))*1e-6;
                Alin=[Alin,A];
                ylin=[ylin,Aext];
                W=xans(2);
                q=4*U/(pi*A)*sqrt(1-(xeps^2)/(A^2));
                qp=-4*U*xeps/(pi*A^2);
                cxl=(Epsi+Fkp*qp/(c*I*(Rx+r)*W)+T2);
                dxl=(Fkp*q/(c*I*(Rx+r))+1);
                rxl = roots([axl bxl cxl dxl]);
                if(isreal(rxl(1)))
                    x1=rxl(1);
                    Axl=real(rxl(2));
                    Bxl=abs(imag(rxl(2)));
                elseif(isreal(rxl(2)))
                    x1=rxl(2);
                    Axl=reall(rx(1));
                    Bxl=abs(imag(rxl(1)));
                elseif(isreal(rxl(3)))
                    x1=rxl(3);
                    Axl=real(rxl(1));
                    Bxl=abs(imag(rxl(1)));
                end
            end
            if(t>maxT)
                ttt=ttt+t;
                t=0;
                
                expx1t=exp(x1*t);
                expAxlt=exp(Axl*t);
                cosBxlt=cos(Bxl*t);
                sinBxlt=sin(Bxl*t);
                expcos=expAxlt*cosBxlt;
                expsin=expAxlt*sinBxlt;
                Tm=[expx1t ...
                    expcos ...
                    expsin;...
                    
                    x1*expx1t ...
                    (Axl*expcos-Bxl*expsin) ...
                    (Axl*expsin+Bxl*expcos);...
                    
                    x1^2*expx1t ...
                    (Axl^2*expcos-Axl*Bxl*expsin-...
                    Bxl*Axl*expsin-Bxl^2*expcos) ...
                    (Axl^2*expsin+Axl*Bxl*expcos+...
                    Bxl*Axl*expcos-Bxl^2*expsin)];
                Tm=Tm^-1;
                C=Tm*[(x(i-1)+yd/c/(FkpU*q+1)) xp xpp]';
                C1=C(1);
                C2=C(2);
                C3=C(3);
            end
            
            if((ttt+t)>tst)
                Aext=-Amax/10+(ttt+t-tst)/(t3-tst)*(Amax+Amax/10);
                if(stt && Aext>0)
                    stL=1;
                    stt=0;
                end
            end
            %------------------ New state processing
            t=t+(t3-t1)/N;
            tx(i)=t+ttt;
            y=Aext*m;
            yd=y;
            
            expx1t=exp(x1*t);
            expAxlt=exp(Axl*t);
            cosBxlt=cos(Bxl*t);
            sinBxlt=sin(Bxl*t);
            expcos=expAxlt*cosBxlt;
            expsin=expAxlt*sinBxlt;
            
            %------------------ Linearisation ----------------------------------
            x(i)=C1*expx1t+expAxlt*(C2*cosBxlt+C3*sinBxlt)-yd/c/(FkpU*q+1);
            
            xp=x1*C1*expx1t+...
                C2*(Axl*expcos-Bxl*expsin)+...
                C3*(Axl*expsin+Bxl*expcos);
            
            xpp=x1^2*C1*expx1t+...
                C2*(...
                Axl^2*expcos-Axl*Bxl*expsin-...
                Bxl*Axl*expsin-Bxl^2*expcos)+...
                C3*(...
                Axl^2*expsin+Axl*Bxl*expcos+...
                Bxl*Axl*expcos-Bxl^2*expsin);
            
            if(x(i-1)<xeps && x(i)>=xeps)
                k=(tx(i)-tx(i-1))/(x(i)-x(i-1));
                t2n=tx(i-1)+(xeps-x(i-1))*k;
                %smpl       t2x=tx(i);
            end
            if(x(i-1)>-xeps && x(i)<=-xeps)
                t1n=t3n;
                %smpl       t1x=t3x;
                k=(tx(i)-tx(i-1))/(x(i)-x(i-1));
                t3n=tx(i-1)+(-xeps-x(i-1))*k;
                %smpl       t3x=tx(i);
                
                n3(in)=-((t3n-t2n)-(t2n-t1n))/(t3n-t1n);
                full_Al(in)=abs((t3n-t2n)/(t2n-t1n));
                full_Alt(in)=abs((t3n-t2n)-(t2n-t1n));
                
                txn(in)=tx(i);
                Axn(in)=Aext;
                %smpl      n3x(in)=-((t3x-t2x)-(t2x-t1x))/(t3x-t1x);
                
                if(stL)
                    iAstartL=in;
                    stL=0;
                end
                in=in+1;
            end
        end
        
        plot(ylin,Alin);
        figure;
        
        in=in-1;
        full_Al=full_Al(1:in);
        n3=n3(1:in);
        full_Alt=full_Alt(1:in);
        txn=txn(1:in);
        Axn=Axn(1:in);
        n3x=n3x(1:in);
    end
    %==========================================================================
    if(R1fullmodel)
        y=0;
        yd=0;
        
        inn=1;
        
        Nsm=5000;
        
        txf=zeros(1,N);
        
        t=0;
        h = waitbar(0);
        ttt=0;
        
        t1n=0;
        t2n=-0.0015;
        t3n=-0.003;
        
        t1nx=0;
        t2nx=-0.0015;
        t3nx=-0.003;
        
        full_Ant=zeros(1,Nsm);
        
        Aext=0;
        FkpU=Fkp*U^2/(c*(Rx+r));
        
        %-----full
        full_An=zeros(1,Nsm);
        sgn=1;
        
        xn=zeros(1,N);
        xnp=zeros(1,N);
        xnpp=0;
        n3xn=zeros(1,Nsm);
        n3n=zeros(1,Nsm);
        txnn=zeros(1,Nsm);
        Axnn=zeros(1,Nsm);
        t1nn=0;
        t2nn=-0.0015;
        t3nn=-0.003;
        
        ax=T1^2;
        bx=Epsi;
        cx=1;
        rx = roots([ax bx cx]);
        Bx=abs(imag(rx(1)));
        Ax=real(rx(1));
        x3=-1/T2;
        
        iAstartF=1;
        stL=0;
        stF=0;
        stt=1;
        %---------
        
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
        C=Tm*[(xn(1)+sgn*FkpU-y/c) xnp(1) xnpp]';
        C1a=C(1);
        C2a=C(2);
        C3a=C(3);
        
        for i=2:N
            if(rem(i,N/1000)==0)
                waitbar(i/N,h, sprintf('Progress\n%.2f%%',100*i/N));
            end
            if(t>maxT)
                ttt=ttt+t;
                t=0;
                
                
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
                C=Tm*[(xn(i-1)+sgn*FkpU-y/c) xnp(i-1) xnpp]';
                C1a=C(1);
                C2a=C(2);
                C3a=C(3);
                
            end
            if((ttt+t)>tst)
                Aext=-Amax/10+(ttt+t-tst)/(t3-tst)*(Amax+Amax/10);
                if(stt && Aext>0)
                    stF=1;
                    stt=0;
                end
            end
            %------------------ New state processing
            t=t+(t3-t1)/N;
            txf(i)=t+ttt;
            y=Aext*m;
            yd=y;
            
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
            %------------------ Linearisation -----------------------------
            %----------- The full solution --------------------------------
            xn(i)=C1a*expcosf+C2a*expsinf+C3a*expx3t-sgn*FkpU+y/c;
            
            xnp(i)=C1a*(Axexpcosf-Bxexpsinf)...
                +C2a*(Axexpsinf+Bxexpcosf)...
                +x3*C3a*expx3t;
            
            xnpp=C1a*(...
                Ax*(Axexpcosf-Bxexpsinf)...
                -Bx*(Axexpsinf+Bxexpcosf))...
                +C2a*(...
                Ax*(Axexpsinf+Bxexpcosf)...
                +Bx*(Axexpcosf-Bxexpsinf))...
                +x3^2*C3a*expx3t;
            
            if(xn(i-1)<xeps && xn(i)>=xeps)
                k=(txf(i)-txf(i-1))/(xn(i)-xn(i-1));
                t2nn=txf(i-1)+(xeps-xn(i-1))*k;
                %smpl     t2nx=tx(i);
                %---------------------------------------
                t2ttt=t2nn-ttt;
                t=t2ttt;
                txf(i)=t2nn;
                expAxt=exp(Ax*t2ttt);
                expx3t=exp(x3*t2ttt);
                cosBxt=cos(Bx*t2ttt);
                sinBxt=sin(Bx*t2ttt);
                expsinf=expAxt*sinBxt;
                expcosf=expAxt*cosBxt;
                Axexpcosf=Ax*expcosf;
                Axexpsinf=Ax*expsinf;
                Bxexpcosf=Bx*expcosf;
                Bxexpsinf=Bx*expsinf;
                
                %xn(i)=C1a*expcosf+C2a*expsinf+C3a*expx3t-sgn*FkpU*U+y/c;
                xn(i)=xeps;
                
                xnp(i)=C1a*(Axexpcosf-Bxexpsinf)...
                    +C2a*(Axexpsinf+Bxexpcosf)...
                    +x3*C3a*expx3t;
                
                xnpp=C1a*(...
                    Ax*(Axexpcosf-Bxexpsinf)...
                    -Bx*(Axexpsinf+Bxexpcosf))...
                    +C2a*(...
                    Ax*(Axexpsinf+Bxexpcosf)...
                    +Bx*(Axexpcosf-Bxexpsinf))...
                    +x3^2*C3a*expx3t;
                %--------------
                sgn=1;
                %--------------
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
                C=Tm*[(xn(i)+sgn*FkpU-y/c) xnp(i) xnpp]';
                C1a=C(1);
                C2a=C(2);
                C3a=C(3);                
            end
            if(xn(i-1)>-xeps && xn(i)<=-xeps)
                %smpl      t1nx=t3nx;
                t1nn=t3nn;
                %smpl      t3nx=tx(i);
                
                k=(txf(i)-txf(i-1))/(xn(i)-xn(i-1));
                t3nn=txf(i-1)+(-xeps-xn(i-1))*k;
                
                n3n(inn)=((t3nn-t2nn)-(t2nn-t1nn))/(t3nn-t1nn);
                full_An(inn)=abs((t2nn-t1nn)/(t3nn-t2nn));
                full_Ant(inn)=abs((t2nn-t1nn)-(t3nn-t2nn));
                
                txnn(inn)=txf(i);
                Axnn(inn)=Aext;
                
                %smpl    n3xn(inn)=((t3nx-t2nx)-(t2nx-t1nx))/(t3nx-t1nx);
                
                if(stF)
                    iAstartF=inn;
                    stF=0;
                end
                inn=inn+1;
                %---------------------------------------
                t3ttt=t3nn-ttt;
                t=t3ttt;
                txf(i)=t3nn;
                
                expAxt=exp(Ax*t3ttt);
                expx3t=exp(x3*t3ttt);
                cosBxt=cos(Bx*t3ttt);
                sinBxt=sin(Bx*t3ttt);
                expsinf=expAxt*sinBxt;
                expcosf=expAxt*cosBxt;
                Axexpcosf=Ax*expcosf;
                Axexpsinf=Ax*expsinf;
                Bxexpcosf=Bx*expcosf;
                Bxexpsinf=Bx*expsinf;
                %--------------
                %xn(i)=C1a*expcosf+C2a*expsinf+C3a*expx3t-sgn*FkpU*U+y/c;
                xn(i)=-xeps;
                
                xnp(i)=C1a*(Axexpcosf-Bxexpsinf)...
                    +C2a*(Axexpsinf+Bxexpcosf)...
                    +x3*C3a*expx3t;
                
                xnpp=C1a*(...
                    Ax*(Axexpcosf-Bxexpsinf)...
                    -Bx*(Axexpsinf+Bxexpcosf))...
                    +C2a*(...
                    Ax*(Axexpsinf+Bxexpcosf)...
                    +Bx*(Axexpcosf-Bxexpsinf))...
                    +x3^2*C3a*expx3t;
                %--------------
                sgn=-1;
                %--------------
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
                C=Tm*[(xn(i)+sgn*FkpU-y/c) xnp(i) xnpp]';
                C1a=C(1);
                C2a=C(2);
                C3a=C(3);
            end
            
        end
        inn=inn-1;
        
        full_An=full_An(1:inn);
        full_Ant=full_Ant(1:inn);
        n3n=n3n(1:inn);
        txnn=txnn(1:inn);
        Axnn=Axnn(1:inn);
        n3xn=n3xn(1:inn);
    end
plot(tx,-x,'r');
hold on;
plot(txf,xn);
figure;
end

%%
if(R2)
    N=200;
    
    if(R2simple)
        n1=zeros(1,N);
        n2=zeros(1,N);
    end
    if(R2full)
        n4=zeros(1,N);
    end
    n3a=zeros(1,N);
    Ae=zeros(1,N);
    
    
    h1 = waitbar(0);
    
    ixx=0;
    xans=[1 1];
    % The first approximation
    y=0;
    xans=fsolve(@NL_sys_lin_mich,xans,optimset('Display','off', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    A=abs(xans(1))*1e-6;
    Adx=A;
    W=xans(2);
    Fd=W/(2*pi);
    xans2=[0.00152 0.00305 -1.1 24 0.00075 0.0023];
    xans1=[0.00151 0.00301 3.22e-05 0.00027 2.77e-06 0.000115 0.00026 -9.7 0.47 -0.47 127 -127];
    % Solution
    for Aext=0:Amax/N:Amax
        ixx=ixx+1;
        waitbar(ixx/N,h1, sprintf('Progress\n%.2f%%',100*ixx/N));
        
        y=Aext*m;
        Ae(ixx)=Aext;
        
        % Simplified solution
        if(R2simple)
            n1(ixx)=(asin((xeps+y/c)/Adx)-asin((xeps-y/c)/Adx))/pi;
            
            % Harmonic linearisation: Simplified solution
            xans=fsolve(@NL_sys_lin_mich,xans,optimset('Display','off', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
            A=abs(xans(1))*1e-6;
            W=xans(2);
            Fd=W/(2*pi);
            n2(ixx)=(asin((xeps+y/c)/A)-asin((xeps-y/c)/A))/pi;
        end
        % Full solution
        if(R2full)
            % xans1=[0.00151 0.00301 3.22e-05 0.00027 2.77e-06 0.000115 0.00026 -9.7 0.47 -0.47 127 -127];
            xans1=fsolve(@NL_sys_nl_full,xans1,...
                optimset('Display','on', 'TolFun', 1.0e-10,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
            t2=abs(real(xans1(1)));
            t3=abs(real(xans1(2)));
            n4=[n4,(t3-2*t2)/t3];
        end
        % Harmonic linearisation: Full solution
        if(R2fulllin)
            xans2=[0.00152 0.00305 -1.1 24 0.00075 0.0023];
            % plotfunlin(abs(real(xans2(2))),-abs(real(xans2(3))),abs(real(xans2(4))),0);
            [xans2,FVAL,EXITFLAG]=fsolve(@NL_sys_lin_full2,xans2,...
                optimset('Display','on', 'TolFun', 1.0e-8,'TolX', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
            t2=abs(real(xans2(1)));
            t3=abs(real(xans2(2)));
            n3a(ixx)=-(t3-2*t2)/t3;
        end
        %  plotfunlin(t3,-abs(real(xans2(3))),abs(real(xans2(4))),0);
     end
end
%%
set(0,'DefaultAxesFontSize',12,'DefaultAxesFontName','Times New Roman'); 
set(0,'DefaultTextFontSize',12,'DefaultTextFontName','Times New Roman');

% Simplified solution
plot([-flip(Ae), Ae],[-flip(n1), n1],'k');
hold on;
% Harmonic linearisation: Simplified solution
plot([-flip(Ae), Ae],[-flip(n2), n2],'k');

%plot(Axn,n3x,'r');% Harmonic linearisation: Modeling
[Y,i]=max(n3);
plot([-flip(Axn(iAstartL:i-10)), Axn(iAstartL:i-10)]...
    ,[-flip(n3(iAstartL:i-10)), n3(iAstartL:i-10)]...
    ,'k');% Harmonic linearisation: Modeling with compensation

%plot(Axnn,n3xn,'k');% Full modeling
[Y,i]=max(n3n);
plot([-flip(Axnn(iAstartF:i)), Axnn(iAstartF:i)]...
    ,[-flip(n3n(iAstartF:i)), n3n(iAstartF:i)]...
    ,'k');% Full modeling with compensation
axis([-1239 1239 -1 1]);
%gridxy(get(gca,'xtick'),get(gca,'ytick'),'color',[.6 .6 .6],'linewidth',1,'Linestyle',':') 
grid on;

figure;
plot(Axn,full_Alt,'b');
hold on;
plot(Axnn,full_Ant,'r');
axis([0 Amax 0 3e-3]);


[Y,Ass] = max(n3(iAstartL:length(n3)));
Ass=Ass+iAstartL-1;
sens_l=full_Alt(Ass)

[Y,i]=max(Axnn);
sens_f=full_Ant(i)

%axis([0 Amax 0 1]);
%grid on;
if(R2fulllin)
    figure;
    plot(Ae,n3a,'k');
    axis([0 Amax 0 1]);
end
%grid on;
%%
if(R3)
    % Linear part regulation
    clear Ae;
    clear xn;
    clear Ass;
    clear Ai1;
    clear Ai3;
    clear Ai5;
    clear Ain1;
    clear Ain3;
    clear Ain5;
    
    global Ae;
    global xn;
    global Npr;
    
    Ass=find(full_Al<0.8);
    lin08 =Axn(Ass(2))
    sens08_l=full_Alt(Ass(2))
    
    Ae=[-flip(Axn(iAstartL:Ass(2)))+2*Axn(iAstartL), Axn(iAstartL:Ass(2))];
    xn=[-flip(n3(iAstartL:Ass(2)))+2*n3(iAstartL), n3(iAstartL:Ass(2))];
    Npr=length(Ae);
    
    %Calculate coefficients A,B,C:
    %sum(Ae(i)-A-B*x(i)-C*x(i)^2)^2->min
    An1=fsolve(@MNK_nonlinear1,[0 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    An3=fsolve(@MNK_nonlinear3,[0 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    An5=fsolve(@MNK_nonlinear5,[0 1 1 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    
    for  t=1:Npr
        Ai1(t)=An1(1)+An1(2)*xn(t);
        Ai3(t)=An3(1)+An3(2)*xn(t)+An3(3)*xn(t)^2+An3(4)*xn(t)^3;
        Ai5(t)=An5(1)+An5(2)*xn(t)+An5(3)*xn(t)^2+An5(4)*xn(t)^3+An5(5)*xn(t)^4+An5(6)*xn(t)^5;
        
        if(abs(Ae(t))>0.0001)
            Ain1(t)=abs((Ai1(t)-Ae(t))/max(Ae)*100);
            Ain3(t)=abs((Ai3(t)-Ae(t))/max(Ae)*100);
            Ain5(t)=abs((Ai5(t)-Ae(t))/max(Ae)*100);
        else
            Ain1(t)=0;
            Ain3(t)=0;
            Ain5(t)=0;
        end
    end
    
    figure;
    plot(Ae,Ain1,'g');
    N_lin08_1=max(Ain1)
    hold on;
    plot(Ae,Ain3,'b');
    N_lin08_3=max(Ain3)
    plot(Ae,Ain5,'r');
    N_lin08_5=max(Ain5)
    title('Linear model 0.8')
    % Full modeling regulation
    clear Ae;
    clear xn;
    clear Ass;
    clear fAi1;
    clear fAi3;
    clear fAi5;
    clear fAin1;
    clear fAin3;
    clear fAin5;
    
    global Ae;
    global xn;
    global Npr;
    
    Ass=find(full_An<0.8);
    full08 =Axn(Ass(3))
    sens08_f=full_Ant(Ass(3))
    
    Ae=[-flip(Axnn(iAstartF:Ass(3)))+2*Axnn(iAstartF),  Axnn(iAstartF:Ass(3))];
    xn=[-flip(n3n(iAstartF:Ass(3)))+2*n3n(iAstartF), n3n(iAstartF:Ass(3))];
    Npr=length(Ae);
    
    %Calculate coefficients A,B,C:
    %sum(Ae(i)-A-B*x(i)-C*x(i)^2)^2->min
    fAn1=fsolve(@MNK_nonlinear1,[0 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    fAn3=fsolve(@MNK_nonlinear3,[0 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    fAn5=fsolve(@MNK_nonlinear5,[0 1 1 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    
    for  t=1:Npr
        fAi1(t)=fAn1(1)+fAn1(2)*xn(t);
        fAi3(t)=fAn3(1)+fAn3(2)*xn(t)+fAn3(3)*xn(t)^2+fAn3(4)*xn(t)^3;
        fAi5(t)=fAn5(1)+fAn5(2)*xn(t)+fAn5(3)*xn(t)^2+fAn5(4)*xn(t)^3+fAn5(5)*xn(t)^4+fAn5(6)*xn(t)^5;
        
        if(abs(Ae(t))>0.0001)
            fAin1(t)=abs((fAi1(t)-Ae(t))/max(Ae)*100);
            fAin3(t)=abs((fAi3(t)-Ae(t))/max(Ae)*100);
            fAin5(t)=abs((fAi5(t)-Ae(t))/max(Ae)*100);
        else
            fAin1(t)=0;
            fAin3(t)=0;
            fAin5(t)=0;
        end
    end
    
    figure;
    plot(Ae,fAin1,'g');
    N_full08_1=max(fAin1)
    hold on;
    plot(Ae,fAin3,'b');
    N_full08_3=max(fAin3)
    plot(Ae,fAin5,'r');
    N_full08_5=max(fAin5)
    title('Full model 0.8')
    % Linear part regulation
    clear Ae;
    clear xn;
    clear Ass;
    clear Ai1;
    clear Ai3;
    clear Ai5;
    clear xAin1;
    clear xAin3;
    clear xAin5;
    
    global Ae;
    global xn;
    global Npr;
    
    [Y,Ass] = max(n3(iAstartL:length(n3)));
    Ass=Ass+iAstartL-1-50;
    max_l=Axn(Ass)
    
    Ae=[-flip(Axn(iAstartL:Ass))+2*Axn(iAstartL), Axn(iAstartL:Ass)];
    xn=[-flip(n3(iAstartL:Ass))+2*n3(iAstartL), n3(iAstartL:Ass)];
    Npr=length(Ae);
    
    %Calculate coefficients A,B,C:
    %sum(Ae(i)-A-B*x(i)-C*x(i)^2)^2->min
    An1=fsolve(@MNK_nonlinear1,[0 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    An3=fsolve(@MNK_nonlinear3,[0 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    An5=fsolve(@MNK_nonlinear5,[0 1 1 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    
    for  t=1:Npr
        Ai1(t)=An1(1)+An1(2)*xn(t);
        Ai3(t)=An3(1)+An3(2)*xn(t)+An3(3)*xn(t)^2+An3(4)*xn(t)^3;
        Ai5(t)=An5(1)+An5(2)*xn(t)+An5(3)*xn(t)^2+An5(4)*xn(t)^3+An5(5)*xn(t)^4+An5(6)*xn(t)^5;
        
        if(abs(Ae(t))>0.0001)
            xAin1(t)=abs((Ai1(t)-Ae(t))/max(Ae)*100);
            xAin3(t)=abs((Ai3(t)-Ae(t))/max(Ae)*100);
            xAin5(t)=abs((Ai5(t)-Ae(t))/max(Ae)*100);
        else
            xAin1(t)=0;
            xAin3(t)=0;
            xAin5(t)=0;
        end
    end
    
    figure;
    plot(Ae,xAin1,'g');
    N_lin_1=max(xAin1)
    hold on;
    plot(Ae,xAin3,'b');
    N_lin_3=max(xAin3)
    plot(Ae,xAin5,'r');
    N_lin_5=max(xAin5)
    title('Linear model full')
    
    figure;
    plot(Ae,xn);
    hold on;
    % Full model regulation
    clear Ae;
    clear xn;
    clear Ass;
    clear fAi1;
    clear fAi3;
    clear fAi5;
    clear fxAin1;
    clear fxAin3;
    clear fxAin5;
    
    global Ae;
    global xn;
    global Npr;
    
    [Y,Ass] = max(Axnn);
    max_f=Axnn(Ass-50)
    
    Ae=[-flip(Axnn(iAstartF:Ass-50))+2*Axnn(iAstartF),  Axnn(iAstartF:Ass-50)];
    xn=[-flip(n3n(iAstartF:Ass-50))+2*n3n(iAstartF), n3n(iAstartF:Ass-50)];
    Npr=length(Ae);
    
    plot(Ae,xn);
    figure;
    % Calculate coefficients A,B,C:
    %sum(Ae(i)-A-B*x(i)-C*x(i)^2)^2->min
    fAn1=fsolve(@MNK_nonlinear1,[0 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    fAn3=fsolve(@MNK_nonlinear3,[0 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    fAn5=fsolve(@MNK_nonlinear5,[0 1 1 1 1 1],optimset('Display','off', 'TolFun', 1.0e-10,'MaxFunEvals',4000,'MaxIter',4000));
    
    for  t=1:Npr
        fAi1(t)=fAn1(1)+fAn1(2)*xn(t);
        fAi3(t)=fAn3(1)+fAn3(2)*xn(t)+fAn3(3)*xn(t)^2+fAn3(4)*xn(t)^3;
        fAi5(t)=fAn5(1)+fAn5(2)*xn(t)+fAn5(3)*xn(t)^2+fAn5(4)*xn(t)^3+fAn5(5)*xn(t)^4+fAn5(6)*xn(t)^5;
        
        if(abs(Ae(t))>0.0001)
            fxAin1(t)=abs((fAi1(t)-Ae(t))/max(Ae)*100);
            fxAin3(t)=abs((fAi3(t)-Ae(t))/max(Ae)*100);
            fxAin5(t)=abs((fAi5(t)-Ae(t))/max(Ae)*100);
        else
            fxAin1(t)=0;
            fxAin3(t)=0;
            fxAin5(t)=0;
        end
    end
    
    figure;
    plot(Ae,fxAin1,'g');
    N_full_1=max(fxAin1)
    hold on;
    plot(Ae,fxAin3,'b');
    N_full_3=max(fxAin3)
    plot(Ae,fxAin5,'r');
    N_full_5=max(fxAin5)
    title('Full model max')
end
%%
function f = MNK_nonlinear1( A )
    global Ae;
    global xn;
    global Npr;

    f(1)=0;
    f(2)=0;

    for i=1:Npr
        f(1)=f(1)+2*(Ae(i)-A(1)-A(2)*xn(i))*(-1);
        f(2)=f(2)+2*(Ae(i)-A(1)-A(2)*xn(i))*(-xn(i));
    end
end
%%
function f = MNK_nonlinear3( A )
    global Ae;
    global xn;
    global Npr;

    f(1)=0;
    f(2)=0;
    f(3)=0;
    f(4)=0;
    for i=1:Npr
        f(1)=f(1)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3)*(-1);
        f(2)=f(2)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3)*(-xn(i));
        f(3)=f(3)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3)*(-xn(i)^2);
        f(4)=f(4)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3)*(-xn(i)^3);
    end
end
%%
function f = MNK_nonlinear5( A )
    global Ae;
    global xn;
    global Npr;

    f(1)=0;
    f(2)=0;
    f(3)=0;
    f(4)=0;
    f(5)=0;
    f(6)=0;
    for i=1:Npr
        f(1)=f(1)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3-A(5)*xn(i)^4-A(6)*xn(i)^5)*(-1);
        f(2)=f(2)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3-A(5)*xn(i)^4-A(6)*xn(i)^5)*(-xn(i));
        f(3)=f(3)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3-A(5)*xn(i)^4-A(6)*xn(i)^5)*(-xn(i)^2);
        f(4)=f(4)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3-A(5)*xn(i)^4-A(6)*xn(i)^5)*(-xn(i)^3);
        f(5)=f(5)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3-A(5)*xn(i)^4-A(6)*xn(i)^5)*(-xn(i)^4);
        f(6)=f(6)+2*(Ae(i)-A(1)-A(2)*xn(i)-A(3)*xn(i)^2-A(4)*xn(i)^3-A(5)*xn(i)^4-A(6)*xn(i)^5)*(-xn(i)^5);
    end
end
%%
function f  = NL_sys_lin_full2( x )
    global c;
    global Fkp;
    global xeps;
    global I;
    global Rx;
    global r;
    global Epsi;
    global T1;
    global T2;
    global y;
    global U;
    global A;
    global W;

    t2=abs(real(x(1)));
    t3=abs(real(x(2)));

    V1=-abs(real(x(3)));
    A1=abs(real(x(4)));

    tA=abs(real(x(5)));
    tB=abs(real(x(6)));

    yd=y;

    q=4*U/(pi*A)*sqrt(1-(xeps^2)/(A^2));
    qp=-4*U*xeps/(pi*A^2);

    ax=((T1^2)*T2);
    bx=(T1^2+Epsi*T2);
    cx=(Epsi+Fkp*qp/(c*I*(Rx+r)*W)+T2);
    dx=(Fkp*q/(c*I*(Rx+r))+1);
    rx = roots([ax bx cx dx]);
    if(isreal(rx(1)))
        x1=rx(1);
        Ax=real(rx(2));
        Bx=abs(imag(rx(2)));
    elseif(isreal(rx(2)))
        x1=rx(2);
        Ax=real(rx(1));
        Bx=abs(imag(rx(1)));
    elseif(isreal(rx(3)))
        x1=rx(3);
        Ax=real(rx(1));
        Bx=abs(imag(rx(1)));
    end
    %------------------------- Parameters C1 C2 C3 ---------------------
    % Tm=[exp(x1*t1) ...
    %     exp(real(x2)*t1)*cos(imag(x2)*t1) ...
    %     exp(real(x2)*t1)*sin(imag(x2)*t1);...
    %     
    %     x1*exp(x1*t1) ...
    %     (real(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1)-imag(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)) ...
    %     (real(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)+imag(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1));...
    %     
    %     x1^2*exp(x1*t1) ...
    %     (real(x2)^2*exp(real(x2)*t1)*cos(imag(x2)*t1)-real(x2)*imag(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)-...
    %     imag(x2)*real(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)-imag(x2)^2*exp(real(x2)*t1)*cos(imag(x2)*t1)) ...
    %     (real(x2)^2*exp(real(x2)*t1)*sin(imag(x2)*t1)+real(x2)*imag(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1)+...
    %     imag(x2)*real(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1)-imag(x2)^2*exp(real(x2)*t1)*sin(imag(x2)*t1))];

    Tm=[1 1 0;...    
        x1 Ax Bx;...    
        x1^2 (Ax^2-Bx^2) (2*Ax*Bx)];
    Tm=Tm^-1;
    C=Tm*[(-xeps+yd/c/(Fkp*q/(c*I*(Rx+r))+1)) V1 A1]';
    C1=C(1);
    C2=C(2);
    C3=C(3);

    f(1)=C1*exp(x1*t2)+exp(Ax*t2)*(C2*cos(Bx*t2)+C3*sin(Bx*t2))-xeps-yd/c/(Fkp*q/(c*I*(Rx+r))+1);
    f(2)=C1*exp(x1*t3)+exp(Ax*t3)*(C2*cos(Bx*t3)+C3*sin(Bx*t3))+xeps-yd/c/(Fkp*q/(c*I*(Rx+r))+1);

    f(3)=(x1*C1*exp(x1*t3)+...
        C2*(Ax*exp(Ax*t3)*cos(Bx*t3)-Bx*exp(Ax*t3)*sin(Bx*t3))+...
        C3*(Ax*exp(Ax*t3)*sin(Bx*t3)+Bx*exp(Ax*t3)*cos(Bx*t3))    -V1);

    f(4)=(x1^2*C1*exp(x1*t3)+...
        C2*(...
        Ax^2*exp(Ax*t3)*cos(Bx*t3)-Ax*Bx*exp(Ax*t3)*sin(Bx*t3)-...
        Ax*Bx*exp(Ax*t3)*sin(Bx*t3)-Bx^2*exp(Ax*t3)*cos(Bx*t3))+...
        C3*(...
        Ax^2*exp(Ax*t3)*sin(Bx*t3)+Ax*Bx*exp(Ax*t3)*cos(Bx*t3)+...
        Bx*Ax*exp(Ax*t3)*cos(Bx*t3)-Bx^2*exp(Ax*t3)*sin(Bx*t3))   -A1);

    f(5)=(C1*exp(x1*tB)+exp(Ax*tB)*(C2*cos(Bx*tB)+C3*sin(Bx*tB)))-...
         (C1*exp(x1*tA)+exp(Ax*tA)*(C2*cos(Bx*tA)+C3*sin(Bx*tA)))-A*2;

    f(6)=abs(x1*C1*exp(x1*tA)+...
        C2*(Ax*exp(Ax*tA)*cos(Bx*tA)-Bx*exp(Ax*tA)*sin(Bx*tA))+...
        C3*(Ax*exp(Ax*tA)*sin(Bx*tA)+Bx*exp(Ax*tA)*cos(Bx*tA)))+...
        abs(x1*C1*exp(x1*tB)+...
        C2*(Ax*exp(Ax*tB)*cos(Bx*tB)-Bx*exp(Ax*tB)*sin(Bx*tB))+...
        C3*(Ax*exp(Ax*tB)*sin(Bx*tB)+Bx*exp(Ax*tB)*cos(Bx*tB)));
end
%%
function f  = NL_sys_lin_full( x )
    global c;
    global Fkp;
    global xeps;
    global I;
    global Rx;
    global r;
    global Eps;
    global T1;
    global T2;
    global y;
    global U;
    global A;
    global W;
    
    q=4*U/(pi*A)*sqrt(1-(xeps^2)/(A^2));
    qp=-4*U*xeps/(pi*A^2);

%     ax=(T1^2+Eps*T2)/((T1^2)*T2);
%     bx=(Eps+Fkp*qp/(c*I*(Rx+r)*W)+T2)/((T1^2)*T2);
%     cx=(Fkp*q/(c*I*(Rx+r))+1)/((T1^2)*T2);
%   
%     Q=(ax^2-3*bx)/9;
%     R=(2*ax^3-9*ax*bx+27*cx)/54;
%     
%     S=Q^3-R^2;
    
%   if(S<0)
%         fi=1/3*acosh(abs(R)/sqrt(abs(Q)^3));
%         x1=(-2*sign(R)*sqrt(abs(Q))*cosh(fi)-ax/3);
%         x2=sign(R)*sqrt(abs(Q))*cosh(fi)-ax/3+1i*sqrt(3)*sqrt(abs(Q))*sinh(fi);
%         x3=sign(R)*sqrt(abs(Q))*cosh(fi)-ax/3-1i*sqrt(3)*sqrt(abs(Q))*sinh(fi);
%   end

%     z1=x1^3+ax*x1^2+bx*x1+cx
%     z2=x2^3+ax*x2^2+bx*x2+cx
%     z3=x3^3+ax*x3^2+bx*x3+cx
    ax=((T1^2)*T2);
    bx=(T1^2+Eps*T2);
    cx=(Eps+Fkp*qp/(c*I*(Rx+r)*W)+T2);
    dx=(Fkp*q/(c*I*(Rx+r))+1);
    rx = roots([ax bx cx dx]);
    x1=rx(1);
    x2=rx(2);
    x3=rx(3);
    
  %   z1=ax*x1^3+bx*x1^2+cx*x1+dx
  %   z2=ax*x2^3+bx*x2^2+cx*x2+dx
  %   z3=ax*x3^3+bx*x3^2+cx*x3+dx
    
    t1=0;
    t2=abs(real(x(1)));
    t3=abs(real(x(2)));
    C1=real(x(3));
    C2=real(x(4));
    C3=real(x(5));
    V1=real(x(6));
    A1=real(x(7));
    
    f(1)=C1*exp(x1*t1)+exp(real(x2)*t1)*(C2*cos(imag(x2)*t1)+C3*sin(imag(x2)*t1))+xeps;%-y/1e6/c/(Fkp*q/(c*I*(Rx+r))+1);
    f(2)=C1*exp(x1*t2)+exp(real(x2)*t2)*(C2*cos(imag(x2)*t2)+C3*sin(imag(x2)*t2))-xeps;%-y/1e6/c/(Fkp*q/(c*I*(Rx+r))+1);
    f(3)=C1*exp(x1*t3)+exp(real(x2)*t3)*(C2*cos(imag(x2)*t3)+C3*sin(imag(x2)*t3))+xeps;%-y/1e6/c/(Fkp*q/(c*I*(Rx+r))+1);
    
    f(4)=x1*C1*exp(x1*t1)+...
        C2*(real(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1)-imag(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1))+...
        C3*(real(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)+imag(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1))-V1;
    f(5)=x1*C1*exp(x1*t3)+...
        C2*(real(x2)*exp(real(x2)*t3)*cos(imag(x2)*t3)-imag(x2)*exp(real(x2)*t3)*sin(imag(x2)*t3))+...
        C3*(real(x2)*exp(real(x2)*t3)*sin(imag(x2)*t3)+imag(x2)*exp(real(x2)*t3)*cos(imag(x2)*t3))-V1;
    
    f(6)=x1^2*C1*exp(x1*t1)+...
        C2*(...
        real(x2)^2*exp(real(x2)*t1)*cos(imag(x2)*t1)-real(x2)*imag(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)-...
        imag(x2)*real(x2)*exp(real(x2)*t1)*sin(imag(x2)*t1)-imag(x2)^2*exp(real(x2)*t1)*cos(imag(x2)*t1))+...
        C3*(...
        real(x2)^2*exp(real(x2)*t1)*sin(imag(x2)*t1)+real(x2)*imag(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1)+...
        imag(x2)*real(x2)*exp(real(x2)*t1)*cos(imag(x2)*t1)-imag(x2)^2*exp(real(x2)*t1)*sin(imag(x2)*t1))-A1;
    
    f(7)=x1^2*C1*exp(x1*t3)+...
        C2*(...
        real(x2)^2*exp(real(x2)*t3)*cos(imag(x2)*t3)-real(x2)*imag(x2)*exp(real(x2)*t3)*sin(imag(x2)*t3)-...
        imag(x2)*real(x2)*exp(real(x2)*t3)*sin(imag(x2)*t3)-imag(x2)^2*exp(real(x2)*t3)*cos(imag(x2)*t3))+...
        C3*(...
        real(x2)^2*exp(real(x2)*t3)*sin(imag(x2)*t3)+real(x2)*imag(x2)*exp(real(x2)*t3)*cos(imag(x2)*t3)+...
        imag(x2)*real(x2)*exp(real(x2)*t3)*cos(imag(x2)*t3)-imag(x2)^2*exp(real(x2)*t3)*sin(imag(x2)*t3))-A1;
end
%%
function f  = NL_sys_lin_mich( x )
    %A=x(1)
    %w=x(2)
    
    global c;
    global Fkp;
    global xeps;
    global I;
    global Rx;
    global r;
    global Eps;
    global T1;
    global T2;
    global y;
    global U;
    
    A=abs(real(x(1)))*1e-6;
    w=abs(real(x(2)));
    
    q=4*U/(pi*A)*sqrt(1-(xeps^2)/(A^2));
    qp=-4*U*xeps/(pi*A^2);
    %Wn=q+qp*1i;  
    M=Fkp/(c*I*(Rx+r));
    N=((T1^2)*((w*1i)^2)+Eps*(w*1i)+1)*(T2*(w*1i)+1)-y/c*(T2*(w*1i)+1);

    f(1)=abs(real(N)+real(M)*q-imag(M)*qp*1i);
    f(2)=abs(imag(N)+real(M)*qp+imag(M)*q);
end
%%
function f  = NL_sys_nl_full( x )
    global c;
    global Fkp;
    global xeps;
    global I;
    global Rx;
    global r;
    global Epsi;
    global T1;
    global T2;
    global y;
    global U;
    
    t1=0;
    t2=abs(real(x(1)));
    t3=abs(real(x(2)));
    
    C1a=real(x(3));
    C2a=real(x(4));
    C3a=real(x(5));
    
    C1b=real(x(6));
    C2b=real(x(7));
    C3b=real(x(8));
    
    V1=real(x(9));
    V2=real(x(10));
    
    A1=real(x(11));
    A2=real(x(12));
    
    ax=T1^2;
    bx=Epsi;
    cx=1;
    rx = roots([ax bx cx]);    
    Bx=abs(imag(rx(1)));
    Ax=real(rx(1));
    x3=-1/T2;
    
    f(1)=C1a*exp(Ax*t1)*cos(Bx*t1)+C2a*exp(Ax*t1)*sin(Bx*t1)+C3a*exp(x3*t1)-Fkp*U/(c*I*(Rx+r))+xeps+y/c;
    f(2)=C1a*exp(Ax*t2)*cos(Bx*t2)+C2a*exp(Ax*t2)*sin(Bx*t2)+C3a*exp(x3*t2)-Fkp*U/(c*I*(Rx+r))-xeps+y/c;    
    f(3)=C1b*exp(Ax*t2)*cos(Bx*t2)+C2b*exp(Ax*t2)*sin(Bx*t2)+C3b*exp(x3*t2)+Fkp*U/(c*I*(Rx+r))-xeps+y/c;
    f(4)=C1b*exp(Ax*t3)*cos(Bx*t3)+C2b*exp(Ax*t3)*sin(Bx*t3)+C3b*exp(x3*t3)+Fkp*U/(c*I*(Rx+r))+xeps+y/c;
    
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
     
    f(9)=C1a*(...
        Ax*(Ax*exp(Ax*t1)*cos(Bx*t1)-Bx*exp(Ax*t1)*sin(Bx*t1))...
       -Bx*(Ax*exp(Ax*t1)*sin(Bx*t1)+Bx*exp(Ax*t1)*cos(Bx*t1)))...
        +C2a*(...
        Ax*(Ax*exp(Ax*t1)*sin(Bx*t1)+Bx*exp(Ax*t1)*cos(Bx*t1))...
       +Bx*(Ax*exp(Ax*t1)*cos(Bx*t1)-Bx*exp(Ax*t1)*sin(Bx*t1)))...
        +x3^2*C3a*exp(x3*t1)-A1;
    f(10)=C1a*(...
        Ax*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2))...
       -Bx*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2)))...
        +C2a*(...
        Ax*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))...
       +Bx*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2)))...
        +x3^2*C3a*exp(x3*t2)-A2;
    f(11)=C1b*(...
        Ax*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2))...
       -Bx*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2)))...
        +C2b*(...
        Ax*(Ax*exp(Ax*t2)*sin(Bx*t2)+Bx*exp(Ax*t2)*cos(Bx*t2))...
       +Bx*(Ax*exp(Ax*t2)*cos(Bx*t2)-Bx*exp(Ax*t2)*sin(Bx*t2)))...
        +x3^2*C3b*exp(x3*t2)-A2;
    f(12)=C1b*(...
        Ax*(Ax*exp(Ax*t3)*cos(Bx*t3)-Bx*exp(Ax*t3)*sin(Bx*t3))...
       -Bx*(Ax*exp(Ax*t3)*sin(Bx*t3)+Bx*exp(Ax*t3)*cos(Bx*t3)))...
        +C2b*(...
        Ax*(Ax*exp(Ax*t3)*sin(Bx*t3)+Bx*exp(Ax*t3)*cos(Bx*t3))...
       +Bx*(Ax*exp(Ax*t3)*cos(Bx*t3)-Bx*exp(Ax*t3)*sin(Bx*t3)))...
        +x3^2*C3b*exp(x3*t3)-A1;
end





