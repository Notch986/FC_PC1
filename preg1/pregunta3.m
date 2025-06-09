clear; clf; hold off;

x0 = -2.0;        % Posición inicial (m)
v0 = 0.5;         % Velocidad inicial (m/s)
a = 2;            % Aceleración constante (m/s^2)
t0 = 0;
tf = 10;

% Valores de h a comparar
valores_h = [0.5, 0.1, 0.01, 0.001];
colores = ['r', 'g', 'b', 'y'];

% Solución exacta para tomar como referencia
t_exacto = linspace(t0, tf, 1000);
x_exacto = x0 + v0 * t_exacto + 0.5 * a * t_exacto.^2;
plot(t_exacto, x_exacto, 'k-', 'LineWidth', 2);
hold on;

legend_labels = {'Exacta'};

% método de Euler para cada h
for i = 1:length(valores_h)
    h = valores_h(i);
    t = t0;
    x = x0;
    v = v0;
    pt = t;
    px = x;

    while t <= tf
        x = x + h * v;
        v = v + h * a;
        t = t + h;
        pt(end+1) = t;
        px(end+1) = x;
    end

    plot(pt, px, [colores(i) '--'], 'LineWidth', 1.5);
    legend_labels{end+1} = ['Euler h = ' num2str(h)];
end

grid on;
xlabel('Tiempo (s)');
ylabel('Posición x (m)');
title('Comparación de los resultados encontrados variando h');
legend(legend_labels, 'Location', 'northwest');
