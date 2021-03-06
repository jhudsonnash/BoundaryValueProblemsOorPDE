clear all
clf

% Integrate the 2nd order ODE BVP by using the SHOOTFIRST method:

% We write SHOOTFIRST in this case such that each psi(1) and psi(2) have
% one unknown boundary. The reason why either psi(1) or psi(2) does not
% have *both* boundary conditions from the start is because one of the
% original boundary conditions of the 2nd-order original equation is a
% derivative condition (ie, a gradient bound). This is DIFFERENT from the
% setup used in "finitedifference.m."

global Da
Da = 12.0; p1(2) = 1; p2(1) = 0;
           p1(1) = 0.5; % 1st guess of initial condition
           p1_2(1) = .25; % 2nd guess of initial condition
[y,psi]=secshoot(@psidif,p1(2),p2(1),[0 1],.001,p1(1),p1_2(1));
hold on
psi
plot(y,psi(:,1),'-r');
Da = 1.0;
[y,psi]=secshoot(@psidif,p1(2),p2(1),[0 1],.001,p1(1),p1_2(1));
plot(y,psi(:,2),'-b');


function dpdt = psidif(y,p)
global Da
dpdt(1) = p(2);
dpdt(2) = Da*p(1);
dpdt = dpdt';
end

function [t,y] = secshoot(dydt,y1_end,y2_start,trange,TOL,idk1guess,idk2guess) % idk = y1_start !!!
[t,y]=ode45(dydt,trange,[idk1guess y2_start]);
err0 = y1_end - y(end); err = TOL+5; idk0 = idk1guess; idk = idk2guess;
while abs(err) > TOL
   [t,y]=ode45(dydt,trange,[idk y2_start]);
   err=y1_end-y(end);
   idkold=idk;
   idk = idk-err/(err-err0)*(idk-idk0);
   %[idkold, idk0, idk]
   %[err0,err]
   [y1_end,y(end),t(end)]
   err0=err;
   idk0=idkold;
   plot(t,y(:,1),'o');
end
end