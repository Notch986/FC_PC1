% EJERCICIO 3: Comparación de resultados y variación del tamaño de paso
clear all; clc; close all;

% Constantes y condiciones iniciales
g = 9.81;           % aceleración gravitacional (m/s²)
v0 = 5;             % velocidad inicial (m/s)
alpha0_deg = 60;    % ángulo inicial en grados
alpha0 = alpha0_deg * pi/180;  % ángulo inicial en radianes

% Componentes iniciales de velocidad
v0x = v0 * cos(alpha0);
v0y = v0 * sin(alpha0);

% 1. RESULTADO ANALÍTICO (referencia exacta)
alcance_analitico = (v0^2 * sin(2*alpha0)) / g;
tiempo_analitico = 2 * v0y / g;
altura_max_analitica = (v0y^2) / (2*g);

% 2. RESULTADO GRÁFICO (del ejercicio 1)
x_max = alcance_analitico * 1.2;
x = linspace(0, x_max, 1000);
y = x .* tan(alpha0) - (g * x.^2) ./ (2 * v0^2 * cos(alpha0)^2);
indices_positivos = find(y >= 0);
ultimo_positivo = indices_positivos(end);
if ultimo_positivo < length(y)
    x1 = x(ultimo_positivo);
    x2 = x(ultimo_positivo + 1);
    y1 = y(ultimo_positivo);
    y2 = y(ultimo_positivo + 1);
    alcance_grafico = x1 - y1 * (x2 - x1) / (y2 - y1);
else
    alcance_grafico = x(ultimo_positivo);
end

% 3. MÉTODO DE EULER CON DIFERENTES TAMAÑOS DE PASO
pasos = [0.1, 0.05, 0.02, 0.01, 0.005, 0.002, 0.001];
n_pasos = length(pasos);

% Función para aplicar método de Euler
function [alcance, tiempo_vuelo, altura_max, iteraciones] = euler_proyectil(v0, alpha0, g, h)
    v0x = v0 * cos(alpha0);
    v0y = v0 * sin(alpha0);
    t = 0; x = 0; y = 0; vx = v0x; vy = v0y;
    y_vec = [y];
    iteraciones = 0;

    while y >= 0 || iteraciones == 0
        x_anterior = x;
        y_anterior = y;
        t_anterior = t;

        x = x + vx * h;
        y = y + vy * h;
        vx = vx + 0 * h;
        vy = vy - g * h;
        t = t + h;

        y_vec = [y_vec, y];
        iteraciones = iteraciones + 1;

        if iteraciones > 1 && y_anterior > 0 && y < 0
            factor = -y_anterior / (y - y_anterior);
            tiempo_vuelo = t_anterior + factor * (t - t_anterior);
            alcance = x_anterior + factor * (x - x_anterior);
            break;
        end

        if iteraciones > 50000
            tiempo_vuelo = t;
            alcance = x;
            break;
        end
    end
    altura_max = max(y_vec(y_vec >= 0));
end

% Ejecutar Euler para cada tamaño de paso
alcances_euler = zeros(n_pasos, 1);
tiempos_euler = zeros(n_pasos, 1);
alturas_max_euler = zeros(n_pasos, 1);
num_iteraciones = zeros(n_pasos, 1);

for i = 1:n_pasos
    [alcances_euler(i), tiempos_euler(i), alturas_max_euler(i), num_iteraciones(i)] = ...
        euler_proyectil(v0, alpha0, g, pasos(i));
end

% Calcular errores
errores_alcance_abs = abs(alcances_euler - alcance_analitico);
errores_alcance_rel = errores_alcance_abs / alcance_analitico * 100;

% Encontrar paso recomendado (error < 0.1%)
idx_01pct = find(errores_alcance_rel < 0.1, 1);
if isempty(idx_01pct), idx_01pct = length(pasos); end
paso_recomendado = pasos(idx_01pct);

% GRÁFICAS CON RESULTADOS INTEGRADOS
figure(1);

% Subplot 1: Convergencia del alcance
subplot(2,3,1);
loglog(pasos, errores_alcance_rel, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
% Línea de referencia de convergencia orden 1
error_ref = errores_alcance_rel(end) * (pasos/pasos(end)).^1;
loglog(pasos, error_ref, 'r--', 'LineWidth', 2);
xlabel('Paso h (s)');
ylabel('Error relativo (%)');
title('CONVERGENCIA DEL ALCANCE');
legend('Euler', 'Orden 1', 'Location', 'northwest');
grid on;

% Añadir información de convergencia
text(0.02, 0.98, sprintf('Convergencia: Orden 1\nPaso recomendado: h ≤ %.3f s', paso_recomendado), ...
     'Units', 'normalized', 'FontSize', 9, 'BackgroundColor', 'white', ...
     'EdgeColor', 'black', 'VerticalAlignment', 'top');

% Subplot 2: Comparación de alcances
subplot(2,3,2);
semilogx(pasos, alcances_euler, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
semilogx(pasos, alcance_analitico * ones(size(pasos)), 'r--', 'LineWidth', 3);
semilogx(pasos, alcance_grafico * ones(size(pasos)), 'g--', 'LineWidth', 2);
xlabel('Paso h (s)');
ylabel('Alcance (m)');
title('CONVERGENCIA AL VALOR EXACTO');
legend('Euler', 'Analítico', 'Gráfico', 'Location', 'best');
grid on;

% Subplot 3: Costo computacional
subplot(2,3,3);
loglog(pasos, num_iteraciones, 'mo-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Paso h (s)');
ylabel('Número de iteraciones');
title('COSTO COMPUTACIONAL');
grid on;

% Añadir eficiencia
text(0.02, 0.98, sprintf('h = %.3f s\n%d iteraciones\nError = %.3f%%', ...
     paso_recomendado, num_iteraciones(idx_01pct), errores_alcance_rel(idx_01pct)), ...
     'Units', 'normalized', 'FontSize', 9, 'BackgroundColor', 'yellow', ...
     'EdgeColor', 'black', 'VerticalAlignment', 'top');

% Subplot 4: Tabla de comparación
subplot(2,3,4);
axis off;
% Crear tabla de resultados principales
tabla_text = sprintf(['COMPARACIÓN DE MÉTODOS:\n\n' ...
    'Analítico:   %.6f m\n' ...
    'Gráfico:     %.6f m\n' ...
    'Euler h=0.1: %.6f m\n' ...
    'Euler h=0.01:%.6f m\n' ...
    'Euler h=0.001:%.6f m\n\n' ...
    'ERRORES RELATIVOS:\n' ...
    'Gráfico:     %.4f%%\n' ...
    'Euler h=0.1: %.4f%%\n' ...
    'Euler h=0.01:%.4f%%\n' ...
    'Euler h=0.001:%.4f%%'], ...
    alcance_analitico, alcance_grafico, alcances_euler(1), alcances_euler(4), alcances_euler(7), ...
    abs(alcance_grafico-alcance_analitico)/alcance_analitico*100, ...
    errores_alcance_rel(1), errores_alcance_rel(4), errores_alcance_rel(7));

text(0.05, 0.95, tabla_text, 'FontSize', 10, 'VerticalAlignment', 'top', ...
     'FontFamily', 'monospace', 'BackgroundColor', [0.95 0.95 0.95], ...
     'EdgeColor', 'black');

% Subplot 5: Recomendaciones
subplot(2,3,5);
axis off;
% Encontrar diferentes niveles de precisión
idx_1pct = find(errores_alcance_rel < 1.0, 1);
idx_01pct = find(errores_alcance_rel < 0.1, 1);
idx_001pct = find(errores_alcance_rel < 0.01, 1);

recom_text = sprintf(['RECOMENDACIONES:\n\n' ...
    'Para error < 1.0%%:\n' ...
    'h ≤ %.3f s\n\n' ...
    'Para error < 0.1%%:\n' ...
    'h ≤ %.3f s\n\n' ...
    'Para error < 0.01%%:\n' ...
    'h ≤ %.3f s\n\n' ...
    'ÓPTIMO:\n' ...
    'h = %.3f s\n' ...
    '(Balance precisión/eficiencia)'], ...
    pasos(idx_1pct), pasos(idx_01pct), pasos(idx_001pct), paso_recomendado);

text(0.05, 0.95, recom_text, 'FontSize', 11, 'VerticalAlignment', 'top', ...
     'FontWeight', 'bold', 'BackgroundColor', 'lightgreen', 'EdgeColor', 'black');

% Subplot 6: RESPUESTA FINAL
subplot(2,3,6);
axis off;

% Resultado confiable destacado
text(0.5, 0.8, 'RESULTADO CONFIABLE:', 'HorizontalAlignment', 'center', ...
     'FontSize', 14, 'FontWeight', 'bold');

text(0.5, 0.6, sprintf('h = %.3f s', paso_recomendado), ...
     'HorizontalAlignment', 'center', 'FontSize', 16, 'FontWeight', 'bold', ...
     'Color', 'blue', 'BackgroundColor', 'yellow', 'EdgeColor', 'black');

text(0.5, 0.4, sprintf('ALCANCE = %.4f m', alcances_euler(idx_01pct)), ...
     'HorizontalAlignment', 'center', 'FontSize', 18, 'FontWeight', 'bold', ...
     'Color', 'white', 'BackgroundColor', 'red', 'EdgeColor', 'black');

text(0.5, 0.2, sprintf('Error: %.4f%%', errores_alcance_rel(idx_01pct)), ...
     'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');

text(0.5, 0.05, 'El método de Euler converge\nlinealmente al resultado exacto', ...
     'HorizontalAlignment', 'center', 'FontSize', 10, 'FontStyle', 'italic');

sgtitle('EJERCICIO 3: COMPARACIÓN DE MÉTODOS Y ANÁLISIS DE CONVERGENCIA', ...
         'FontSize', 14, 'FontWeight', 'bold');
