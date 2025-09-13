addpath('P:/git/fmm')

%%
clear;clc;

lam0 = 500e-9;

n1 = 1.0;
n2 = 3.0+0.5i;
d = 200e-9;
n3 = 1.0;


c = fmm;
c.setopt('mode','conical')
c.set('lam0',lam0,'ax',100e-9)
c.set('n1',n1,'n2',n3)
c.add('layer','n',n2,'d',d)
% c.add('rect','n',n2,'d',d,'x',0,'xspan',inf,'nh',1.0,'yspan',inf)

N = 1000;
z = linspace(-1e-6,1e-6,N);
x = zeros(1,N);
y = zeros(1,N);

c.field('plane','custom','x',x,'y',y,'z',z)



figure
plot(z,abs(c.out.Ex))



%%
clear;clc;

lam0 = 500e-9;

n1 = 1.0;
n2 = 3.0+0.5i;
d = 200e-9;
n3 = 0.1+5i;


c = fmm;
c.setopt('mode','conical')
c.set('lam0',lam0)
c.set('n1',n1,'n2',n3)
c.add('layer','n',n2,'d',d)

N = 1000;
z = linspace(-1e-6,1e-6,N);
x = zeros(1,N);
y = zeros(1,N);

c.field('plane','custom','x',x,'y',y,'z',z)



figure
plot(z,abs(c.out.Ex))
