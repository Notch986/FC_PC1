clear; clf; hold off;

% Condiciones iniciales
x0 = -2.0;        % Posición inicial (m)
v0 = 0.5;         % Velocidad inicial (m/s)
a = 2;            % Aceleración constante (m/s^2)
t0 = 0;           % Tiempo inicial
tfin = 10;        % Tiempo final
h = 0.1;          % Paso de tiempo
n = 0;            % Contador

% estado iniciales
t = t0;
x = x0;
v = v0;

% Inicialización de vectores
pt(1) = t;
px(1) = x;
pv(1) = v;
pa(1) = a;

% Bucle de simulación
for t = t0:h:tfin
    n = n + 1;
    v = v + h*a;           
    x = x + h*v;           
    pt(n+1) = t;
    px(n+1) = x;
    pv(n+1) = v;
    pa(n+1) = a;
end

% Gráfico de desplazamiento vs tiempo
plot(pt, px, 'r', 'LineWidth', 2);
grid on;
xlabel('Tiempo (s)');
ylabel('Posición x (m)');
title('Gráfico de desplazamiento vs tiempo');
