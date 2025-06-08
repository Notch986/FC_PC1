clear, clf, hold off;
n=0;
h=1;
k=750;
tfin=500000;
theta = linspace(0, 2*pi, 100);
r = 6.371e6;

x = r*cos(theta);
y = r*sin(theta);

plot(x, y, 'b');
axis equal;
grid on;
hold on;

for vy=3000.0:k:6000.0
    vx=7000.0; y=r; x=0; n=0;
    px(1)=x; py(1)=y;
    for t=0:h:tfin
        n=n+1;
        x=x+vx*h;
        y=y+vy*h;
        vx=vx+ax(x,y)*h;
        vy=vy+ay(x,y)*h;
        px(n+1)=x;
        py(n+1)=y;
        R=x^2+y^2;
        if sqrt(R)<r;
            break;
        end
    end
    plot(px,py); hold on
end
hold off