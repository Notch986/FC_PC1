clear, clf, hold off; n=0;
% Constantes del Sistema
h=0.001; k=-0.05; tfin=60; b=2; radio = 1;
centros = [
    b, 0;
    -b/2,  sqrt(3)*b/2;
    -b/2, -sqrt(3)*b/2
];
for vy=-0.3:k:-0.5
    % Condiciones iniciales
    vx=-1.4; y=0; x=0; n=0;
    px = []; py = [];
    px(1)=x; py(1)=y;
    for t=0:h:tfin
        n=n+1;
        x=x+vx*h;
        y=y+vy*h;
        vx=vx+ax(x,y,b)*h;
        vy=vy+ay(x,y,b)*h;
        dist1 = sqrt((x - centros(1,1))^2 + (y - centros(1,2))^2);
        dist2 = sqrt((x - centros(2,1))^2 + (y - centros(2,2))^2);
        dist3 = sqrt((x - centros(3,1))^2 + (y - centros(3,2))^2);
        if dist1 <= radio || dist2 <= radio || dist3 <= radio
            break;
        end
        px(n+1)=x;
        py(n+1)=y;
    end
    plot(px,py);
    hold on;
end
for i = 1:size(centros,1)
    viscircles(centros(i,:), radio);
end
axis equal;