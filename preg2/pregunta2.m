% EJERCICIO 2: Aplicar el método de Euler para encontrar el alcance

clear all; clc; close all;

% Constantes y condiciones iniciales
g = 9.81;           % aceleración gravitacional (m/s²)
v0 = 5;             % velocidad inicial (m/s)
alpha0_deg = 60;    % ángulo inicial en grados
alpha0 = alpha0_deg * pi/180;  % ángulo inicial en radianes

fprintf('=== EJERCICIO 2: MÉTODO DE EULER ===\n');
fprintf('Condiciones iniciales:\n');
fprintf('v₀ = %.1f m/s\n', v0);
fprintf('α₀ = %.0f°\n', alpha0_deg);
fprintf('\n');

% Componentes iniciales de velocidad
v0x = v0 * cos(alpha0);
v0y = v0 * sin(alpha0);

fprintf('Componentes iniciales de velocidad:\n');
fprintf('v₀ₓ = %.3f m/s\n', v0x);
fprintf('v₀ᵧ = %.3f m/s\n', v0y);
fprintf('\n');

% Tamaño de paso inicial
h = 0.01;  % paso de tiempo en segundos

fprintf('Aplicando método de Euler con h = %.3f s\n', h);
fprintf('Ecuaciones diferenciales:\n');
fprintf('dx/dt = vₓ\n');
fprintf('dy/dt = vᵧ\n');
fprintf('dvₓ/dt = 0\n');
fprintf('dvᵧ/dt = -g\n');
fprintf('\n');

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

fprintf('Iteraciones del método de Euler:\n');
fprintf('%-8s %-10s %-10s %-10s %-10s %-10s\n', 'Iter', 't (s)', 'x (m)', 'y (m)', 'vₓ (m/s)', 'vᵧ (m/s)');
fprintf('%-8s %-10s %-10s %-10s %-10s %-10s\n', '----', '------', '------', '------', '--------', '--------');

% Mostrar condiciones iniciales
fprintf('%-8d %-10.3f %-10.3f %-10.3f %-10.3f %-10.3f\n', iteracion, t, x, y, vx, vy);

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

    % Mostrar cada 10 iteraciones para no saturar la salida
    if mod(iteracion-1, 10) == 0 || iteracion <= 5
        fprintf('%-8d %-10.3f %-10.3f %-10.3f %-10.3f %-10.3f\n', iteracion, t, x, y, vx, vy);
    end

    % Detectar cuando cruza y = 0
    if iteracion > 1 && y_anterior > 0 && y < 0
        % Interpolación lineal para encontrar el punto exacto donde y = 0
        factor = -y_anterior / (y - y_anterior);
        t_impacto = t_anterior + factor * (t - t_anterior);
        x_impacto = x_anterior + factor * (x - x_anterior);

        fprintf('%-8s %-10s %-10s %-10s %-10s %-10s\n', '...', '...', '...', '...', '...', '...');
        fprintf('%-8s %-10.3f %-10.3f %-10.3f %-10s %-10s\n', 'Impacto', t_impacto, x_impacto, 0.0, '---', '---');

        break;
    end

    % Seguridad: evitar bucle infinito
    if iteracion > 10000
        fprintf('Máximo de iteraciones alcanzado\n');
        break;
    end
end

% Resultados
fprintf('\n=== RESULTADOS DEL MÉTODO DE EULER ===\n');
fprintf('Número total de iteraciones: %d\n', iteracion);
fprintf('Tiempo de vuelo: %.3f s\n', t_impacto);
fprintf('Alcance: %.6f m\n', x_impacto);

% Altura máxima (encontrar el máximo en la trayectoria)
[h_max_euler, idx_max] = max(y_vec);
t_h_max = t_vec(idx_max);
x_h_max = x_vec(idx_max);
fprintf('Altura máxima: %.3f m\n', h_max_euler);
fprintf('Tiempo para altura máxima: %.3f s\n', t_h_max);
fprintf('Posición horizontal de altura máxima: %.3f m\n', x_h_max);

% Gráficas
figure(1);

% Subplot 1: Trayectoria
subplot(2,2,1);
plot(x_vec, y_vec, 'r-', 'LineWidth', 2);
hold on;
plot(0, 0, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
plot(x_impacto, 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plot(x_h_max, h_max_euler, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'm');
xlabel('Distancia horizontal x (m)');
ylabel('Altura y (m)');
title('Trayectoria - Método de Euler');
legend('Trayectoria', 'Inicio', sprintf('Alcance = %.3f m', x_impacto), ...
       sprintf('H máx = %.3f m', h_max_euler), 'Location', 'northeast');
grid on;
axis equal;

% Subplot 2: Posición vs tiempo
subplot(2,2,2);
plot(t_vec, x_vec, 'b-', 'LineWidth', 2);
hold on;
plot(t_vec, y_vec, 'r-', 'LineWidth', 2);
xlabel('Tiempo t (s)');
ylabel('Posición (m)');
title('Posición vs Tiempo');
legend('x(t)', 'y(t)', 'Location', 'best');
grid on;

% Subplot 3: Velocidad vs tiempo
subplot(2,2,3);
plot(t_vec, vx_vec, 'b-', 'LineWidth', 2);
hold on;
plot(t_vec, vy_vec, 'r-', 'LineWidth', 2);
xlabel('Tiempo t (s)');
ylabel('Velocidad (m/s)');
title('Velocidad vs Tiempo');
legend('vₓ(t)', 'vᵧ(t)', 'Location', 'best');
grid on;

% Subplot 4: Información del método
subplot(2,2,4);
axis off;
info_text = {
    'MÉTODO DE EULER';
    '';
    sprintf('Paso h = %.3f s', h);
    sprintf('Iteraciones: %d', iteracion);
    '';
    'RESULTADOS:';
    sprintf('Alcance = %.3f m', x_impacto);
    sprintf('Tiempo = %.3f s', t_impacto);
    sprintf('H máx = %.3f m', h_max_euler);
    '';
    'ECUACIONES USADAS:';
    'xₙ₊₁ = xₙ + vₓ·h';
    'yₙ₊₁ = yₙ + vᵧ·h';
    'vₓₙ₊₁ = vₓₙ';
    'vᵧₙ₊₁ = vᵧₙ - g·h'
};
text(0.1, 0.9, info_text, 'FontSize', 10, 'VerticalAlignment', 'top', ...
     'FontFamily', 'monospace', 'BackgroundColor', [0.95 0.95 0.95]);

sgtitle(sprintf('Análisis con Método de Euler (v₀=%.1f m/s, α₀=%.0f°)', v0, alpha0_deg));

fprintf('\n=== RESULTADO DEL EJERCICIO 2 ===\n');
fprintf('El alcance calculado con método de Euler es: %.3f m\n', x_impacto);
fprintf('====================================\n');
