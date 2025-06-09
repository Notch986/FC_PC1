clear; clf; hold off;

% Condiciones iniciales
x0 = -2.0;        % Posición inicial (m)
v0 = 0.5;         % Velocidad inicial (m/s)
a = 2;            % Aceleración constante (m/s^2)
t0 = 0;           % Tiempo inicial (s)
tfin = 10;        % Tiempo final (s)
h = 0.1;          % Paso de tiempo
n = 0;            % Contador

% Inicialización
t = t0;
x = x0;
v = v0;

pt(1) = t;
px(1) = x;
pv(1) = v;

% Método de Euler
for t = t0:h:tfin
    n = n + 1;
    x = x + h * v;  % Euler para posición
    v = v + h * a;  % Euler para velocidad
    pt(n+1) = t + h;
    px(n+1) = x;
    pv(n+1) = v;
end

% Gráfica de la posición usando Euler
plot(pt, px, 'm', 'LineWidth', 2);
grid on;
xlabel('Tiempo (s)');
ylabel('Posición x (m)');
title('Método de Euler con aceleración constante');
