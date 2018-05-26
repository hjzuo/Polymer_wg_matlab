% This example computes all of the field components of a
% silicon-on-insulator nanowire waveguide.

ncore=1.542;
nclad=1.523;

n1 = nclad;          %  lower cladding
n2 = ncore;          %  core
n3 = nclad;          % upper cladding

h1 = 8000;           % lower cladding (nm)
h2 = 2300;           % silicon core (nm)
h3 = 5000;           % upper cladding (nm)

dx = 20;           % grid size (x)
dy = dx;            % grid size (y)

lambda = 850;      % wavelength (nm)
nmodes = 2;         % number of modes to compute

w = 2300;            % waveguide full-width (nm)
side = 5500;         % space on side of waveguide (nm)

fprintf (1,'generating index mesh...\n');

[x,y,xc,yc,nx,ny,eps,edges] = ...
    waveguidemeshfull([n1,n2,n3],[h1,h2,h3],h2,w/2,side,dx,dy);

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[200,200,200,0],[1.5,1.5,1.5,1]);

[Hx_all,Hy_all,neff_all] = wgmodes (lambda, n2, nmodes, dx, dy, eps, '000A');

fprintf(1,'neff = %7.5f\n',neff_all);

i = 1;
Hx=Hx_all(:,:,i);Hy=Hy_all(:,:,i);neff=neff_all(i);
[Hz,Ex,Ey,Ez] = postprocess (lambda, neff, Hx, Hy, dx, dy, eps, '000A');

ii = i;
colormap(jet(256));
hn = abs(interp2(y,x,Hy,h1+h2/2,0));
en = abs(interp2(yc,xc,Ex,h1+h2/2,min(dx)/2));


subplot(231);
imagemode(x,y,Hx/hn);
title(sprintf('Hx (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(232);
imagemode(x,y,Hy/hn);
title(sprintf('Hy (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(233);
imagemode(x,y,Hz/hn);
title(sprintf('Hz (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(234);
imagemode(x,y,Ex/en);
title(sprintf('Ex (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(235);
imagemode(x,y,Ey/en);
title(sprintf('Ey (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(236);
imagemode(x,y,Ez/en);
title(sprintf('Ez (mode %d)',ii));
for v = edges, line(v{:}); end

