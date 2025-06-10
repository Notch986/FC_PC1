% EJERCICIO 2: Aplicar el método de Euler para encontrar el alcance
clear all; clc; close all;

% Constantes y condiciones iniciales
g = 9.81;           % aceleración gravitacional (m/s²)
v0 = 5;             % velocidad inicial (m/s)
alpha0_deg = 60;    % ángulo inicial en grados
alpha0 = alpha0_deg * pi/180;  % ángulo inicial en radianes

% Componentes iniciales de velocidad
v0x = v0 * cos(alpha0);
v0y = v0 * sin(alpha0);

% Tamaño de paso inicial
h = 0.01;  % paso de tiempo en segundos

% Condiciones iniciales para Euler
t = 0;
x = 0;
y = 0;
vx = v0x;
vy = v0y;

% Vectores para almacenar la trayectoria
t_vec = [t];
x_vec = [x];
y_vec = [y];
vx_vec = [vx];
vy_vec = [vy];

% Contador de iteraciones
iteracion = 0;

% Integración con método de Euler
while y >= 0 || iteracion == 0  % Continuar hasta que y < 0
    % Método de Euler: y_{n+1} = y_n + h * f(t_n, y_n)

    % Actualizar posición usando las velocidades actuales
    x_new = x + vx * h;
    y_new = y + vy * h;

    % Actualizar velocidades usando las aceleraciones
    vx_new = vx + 0 * h;      % ax = 0 (no hay aceleración horizontal)
    vy_new = vy + (-g) * h;   % ay = -g (aceleración gravitacional)

    % Actualizar tiempo
    t_new = t + h;

    % Guardar valores anteriores
    t_anterior = t;
    x_anterior = x;
    y_anterior = y;

    % Actualizar variables
    t = t_new;
    x = x_new;
    y = y_new;
    vx = vx_new;
    vy = vy_new;

    % Almacenar en vectores
    t_vec = [t_vec, t];
    x_vec = [x_vec, x];
    y_vec = [y_vec, y];
    vx_vec = [vx_vec, vx];
    vy_vec = [vy_vec, vy];

    iteracion = iteracion + 1;

    % Detectar cuando cruza y = 0
    if iteracion > 1 && y_anterior > 0 && y < 0
        % Interpolación lineal para encontrar el punto exacto donde y = 0
        factor = -y_anterior / (y - y_anterior);
        t_impacto = t_anterior + factor * (t - t_anterior);
        x_impacto = x_anterior + factor * (x - x_anterior);
        break;
    end

    % Seguridad: evitar bucle infinito
    if iteracion > 10000
        break;
    end
end

% Altura máxima (encontrar el máximo en la trayectoria)
[h_max_euler, idx_max] = max(y_vec);
t_h_max = t_vec(idx_max);
x_h_max = x_vec(idx_max);

% Cálculo teórico para comparación
alcance_teorico = (v0^2 * sin(2*alpha0)) / g;
error_absoluto = abs(x_impacto - alcance_teorico);
error_relativo = error_absoluto / alcance_teorico * 100;

% GRÁFICAS CON INFORMACIÓN INTEGRADA
figure(1);

% Subplot 1: Trayectoria con información detallada
subplot(2,2,1);
plot(x_vec, y_vec, 'r-', 'LineWidth', 2);
hold on;
plot(0, 0, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
plot(x_impacto, 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(x_h_max, h_max_euler, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'm');

% Añadir información directamente en el gráfico
text(0, -0.15, 'Inicio', 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'green');
text(x_impacto, -0.15, sprintf('Alcance\n%.3f m', x_impacto), ...
     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'red');
text(x_h_max, h_max_euler + 0.1, sprintf('H_máx\n%.3f m', h_max_euler), ...
     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'magenta');

xlabel('Distancia horizontal x (m)');
ylabel('Altura y (m)');
title('TRAYECTORIA - MÉTODO DE EULER');
grid on;
axis equal;

% Información mínima en el gráfico
text(0.02, 0.98, sprintf('v₀=%.1fm/s, α₀=%.0f°, h=%.3fs', v0, alpha0_deg, h), ...
     'Units', 'normalized', 'FontSize', 10, 'BackgroundColor', 'white', ...
     'EdgeColor', 'black', 'VerticalAlignment', 'top', 'FontWeight', 'bold');

% Subplot 2: Posición vs tiempo con resultados
subplot(2,2,2);
plot(t_vec, x_vec, 'b-', 'LineWidth', 2);
hold on;
plot(t_vec, y_vec, 'r-', 'LineWidth', 2);
xlabel('Tiempo t (s)');
ylabel('Posición (m)');
title('POSICIÓN vs TIEMPO');
legend('x(t)', 'y(t)', 'Location', 'best');
grid on;

% Resultados principales solamente
text(0.02, 0.98, sprintf('Alcance: %.3f m\nIteraciones: %d', x_impacto, iteracion), ...
     'Units', 'normalized', 'FontSize', 10, 'BackgroundColor', 'yellow', ...
     'EdgeColor', 'black', 'VerticalAlignment', 'top', 'FontWeight', 'bold');

% Subplot 3: Velocidad vs tiempo
subplot(2,2,3);
plot(t_vec, vx_vec, 'b-', 'LineWidth', 2);
hold on;
plot(t_vec, vy_vec, 'r-', 'LineWidth', 2);
xlabel('Tiempo t (s)');
ylabel('Velocidad (m/s)');
title('VELOCIDAD vs TIEMPO');
legend('vₓ(t)', 'vᵧ(t)', 'Location', 'best');
grid on;

% Solo ecuación principal
text(0.02, 0.98, sprintf('Euler: y_{n+1} = y_n + v_y·h'), ...
     'Units', 'normalized', 'FontSize', 10, 'BackgroundColor', 'lightblue', ...
     'EdgeColor', 'black', 'VerticalAlignment', 'top', 'FontWeight', 'bold');

% Subplot 4: Solo la respuesta final
subplot(2,2,4);
axis off;

% Respuesta principal centrada
text(0.5, 0.5, sprintf('ALCANCE = %.3f m', x_impacto), ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
     'FontSize', 24, 'FontWeight', 'bold', ...
     'Color', 'white', 'BackgroundColor', 'red', 'EdgeColor', 'black');

% Título general
sgtitle('EJERCICIO 2: ALCANCE POR MÉTODO DE EULER', 'FontSize', 16, 'FontWeight', 'bold');
