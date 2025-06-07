% EJERCICIO 1: Determinar el alcance mediante gráfica
% Ecuación de trayectoria: y = x*tan(α₀) - (g*x²)/(2*v₀²*cos²(α₀))

clear all; clc; close all;

% Constantes y condiciones iniciales
g = 9.81;           % aceleración gravitacional (m/s²)
v0 = 5;             % velocidad inicial (m/s)
alpha0_deg = 60;    % ángulo inicial en grados
alpha0 = alpha0_deg * pi/180;  % ángulo inicial en radianes

fprintf('=== EJERCICIO 1: ALCANCE POR MÉTODO GRÁFICO ===\n');
fprintf('Condiciones iniciales:\n');
fprintf('v₀ = %.1f m/s\n', v0);
fprintf('α₀ = %.0f°\n', alpha0_deg);
fprintf('\n');

% Componentes iniciales de velocidad
v0x = v0 * cos(alpha0);
v0y = v0 * sin(alpha0);

% Cálculo analítico del alcance para referencia
alcance_teorico = (v0^2 * sin(2*alpha0)) / g;
fprintf('Alcance teórico (fórmula R = v₀²sin(2α)/g): %.6f m\n', alcance_teorico);

% Generar puntos para la trayectoria usando la ecuación dada
x_max = alcance_teorico * 1.2;  % Extender un poco más para visualizar mejor
x = linspace(0, x_max, 1000);

% Ecuación de la trayectoria
y = x .* tan(alpha0) - (g * x.^2) ./ (2 * v0^2 * cos(alpha0)^2);

% Encontrar el alcance gráficamente (donde y = 0)
% Buscar el punto donde y cambia de signo (cruza el eje x)
indices_positivos = find(y >= 0);
if ~isempty(indices_positivos)
    ultimo_positivo = indices_positivos(end);
    if ultimo_positivo < length(y)
        % Interpolación lineal para mayor precisión
        x1 = x(ultimo_positivo);
        x2 = x(ultimo_positivo + 1);
        y1 = y(ultimo_positivo);
        y2 = y(ultimo_positivo + 1);
        
        % Encontrar donde y = 0
        alcance_grafico = x1 - y1 * (x2 - x1) / (y2 - y1);
    else
        alcance_grafico = x(ultimo_positivo);
    end
else
    alcance_grafico = 0;
end

fprintf('Alcance determinado gráficamente: %.6f m\n', alcance_grafico);
fprintf('Error absoluto: %.6f m\n', abs(alcance_grafico - alcance_teorico));
fprintf('Error relativo: %.4f%%\n', abs(alcance_grafico - alcance_teorico)/alcance_teorico*100);

% Altura máxima
h_max = max(y(y >= 0));
x_h_max = x(find(y == h_max, 1));
fprintf('\nAltura máxima: %.3f m\n', h_max);
fprintf('Posición de altura máxima: %.3f m\n', x_h_max);

% Gráfica de la trayectoria
figure(1);
plot(x, y, 'b-', 'LineWidth', 2);
hold on;

% Marcar puntos importantes
plot(0, 0, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');  % Punto inicial
plot(alcance_grafico, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');  % Alcance
plot(x_h_max, h_max, 'mo', 'MarkerSize', 8, 'MarkerFaceColor', 'm');  % Altura máxima

% Líneas de referencia
plot([0, alcance_grafico], [0, 0], 'k--', 'LineWidth', 1);
plot([x_h_max, x_h_max], [0, h_max], 'k--', 'LineWidth', 1);

% Configuración de la gráfica
xlabel('Distancia horizontal x (m)');
ylabel('Altura y (m)');
title(sprintf('Trayectoria del Proyectil (v₀=%.1f m/s, α₀=%.0f°)', v0, alpha0_deg));
legend('Trayectoria', 'Lanzamiento', sprintf('Alcance = %.3f m', alcance_grafico), ...
       sprintf('Altura máx = %.3f m', h_max), 'Location', 'northeast');
grid on;
axis equal;
xlim([0, max(x)]);
ylim([min(y), max(y)*1.1]);

% Añadir texto con información
text(alcance_grafico/2, h_max/2, ...
     sprintf('Ecuación:\ny = x·tan(%.0f°) - \\frac{gx²}{2v₀²cos²(%.0f°)}', alpha0_deg, alpha0_deg), ...
     'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black');

fprintf('\n=== RESULTADO DEL EJERCICIO 1 ===\n');
fprintf('El alcance determinado gráficamente es: %.3f m\n', alcance_grafico);
fprintf('====================================\n');