% Función para generar figuras de Lissajous 3D
function [x, y, z] = lissajous_3d(t, Ax, Ay, Az, wx, wy, wz, phix, phiy, phiz)
    x = Ax * sin(wx * t + phix);
    y = Ay * sin(wy * t + phiy);
    z = Az * sin(wz * t + phiz);
end

% Configuraciones diferentes
configuraciones = {
    % [Ax, Ay, Az, wx, wy, wz, phix, phiy, phiz]
    [1, 1, 1, 1, 2, 3, 0,      pi/2, pi/4],   % Configuración 1
    [1, 1, 1, 3, 2, 5, 0,      pi/2, pi/4],   % Configuración 2
    [1, 1, 1, 2, 3, 1, 0,      0,    pi/2],   % Configuración 3
    [1, 1, 1, 5, 4, 3, pi/4,   pi/2, 0   ]    % Configuración 4
};

% Parámetro temporal
t = linspace(0, 4*pi, 2000);

% Generar múltiples figuras
figure('Position', [100, 100, 1200, 800]);

for i = 1:length(configuraciones)
    config = configuraciones{i};
    
    [x, y, z] = lissajous_3d(t, config(1), config(2), config(3), ...
                                config(4), config(5), config(6), ...
                                config(7), config(8), config(9));

    subplot(2, 2, i);
    plot3(x, y, z, 'LineWidth', 1.5);
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(sprintf('Configuración %d: [%.0f, %.0f, %.0f]', ...
          i, config(4), config(5), config(6)));
    axis equal;
    view(45, 30);
end

sgtitle('Figuras de Lissajous 3D con diferentes configuraciones');
