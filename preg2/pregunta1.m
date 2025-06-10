% EJERCICIO 1: Determinar el alcance mediante gráfica
% Ecuación de trayectoria: y = x*tan(α₀) - (g*x²)/(2*v₀²*cos²(α₀))
clear all; clc; close all;

% Constantes y condiciones iniciales
g = 9.81;           % aceleración gravitacional (m/s²)
v0 = 5;             % velocidad inicial (m/s)
alpha0_deg = 60;    % ángulo inicial en grados
alpha0 = alpha0_deg * pi/180;  % ángulo inicial en radianes

% Componentes iniciales de velocidad
v0x = v0 * cos(alpha0);
v0y = v0 * sin(alpha0);

% Cálculo analítico del alcance para referencia
alcance_teorico = (v0^2 * sin(2*alpha0)) / g;

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

% Altura máxima
h_max = max(y(y >= 0));
x_h_max = x(find(y == h_max, 1));

% Error de cálculo
error_absoluto = abs(alcance_grafico - alcance_teorico);
error_relativo = abs(alcance_grafico - alcance_teorico)/alcance_teorico*100;

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
title('EJERCICIO 1: ALCANCE POR MÉTODO GRÁFICO');
grid on;
axis equal;
xlim([0, max(x)]);
ylim([min(y), max(y)*1.1]);

% INFORMACIÓN COMPLETA EN EL GRÁFICO
% Cuadro de texto con condiciones iniciales
text_condiciones = sprintf(['CONDICIONES INICIALES:\n' ...
    'v₀ = %.1f m/s\n' ...
    'α₀ = %.0f°\n\n' ...
    'ECUACIÓN UTILIZADA:\n' ...
    'y = x·tan(α₀) - gx²/(2v₀²cos²(α₀))'], v0, alpha0_deg);

text(0.02, 0.98, text_condiciones, 'Units', 'normalized', ...
     'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
     'VerticalAlignment', 'top', 'FontWeight', 'bold');

% Cuadro de texto con resultados principales
text_resultados = sprintf(['RESULTADOS:\n' ...
    'Alcance teórico: %.6f m\n' ...
    'Alcance gráfico: %.6f m\n' ...
    'Error absoluto: %.6f m\n' ...
    'Error relativo: %.4f%%\n\n' ...
    'Altura máxima: %.3f m\n' ...
    'Posición h_máx: %.3f m'], ...
    alcance_teorico, alcance_grafico, error_absoluto, error_relativo, h_max, x_h_max);

text(0.98, 0.98, text_resultados, 'Units', 'normalized', ...
     'FontSize', 10, 'BackgroundColor', 'yellow', 'EdgeColor', 'black', ...
     'VerticalAlignment', 'top', 'HorizontalAlignment', 'right', 'FontWeight', 'bold');

% Cuadro de texto con la respuesta final destacada
text_respuesta = sprintf(['RESPUESTA FINAL:\n' ...
    'El alcance determinado\n' ...
    'gráficamente es:\n' ...
    '%.3f m'], alcance_grafico);

text(0.5, 0.15, text_respuesta, 'Units', 'normalized', ...
     'FontSize', 14, 'BackgroundColor', 'red', 'EdgeColor', 'black', ...
     'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
     'FontWeight', 'bold', 'Color', 'white');

% Etiquetas de puntos importantes
text(0, -0.1, 'Inicio', 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'green');
text(alcance_grafico, -0.1, sprintf('Alcance\n%.3f m', alcance_grafico), ...
     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'red');
text(x_h_max, h_max + 0.1, sprintf('h_máx = %.3f m', h_max), ...
     'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'Color', 'magenta');

% Leyenda personalizada
legend('Trayectoria del proyectil', 'Punto de lanzamiento', 'Punto de impacto', ...
       'Altura máxima', 'Línea de alcance', 'Línea de altura máxima', ...
       'Location', 'northeast', 'FontSize', 9);
