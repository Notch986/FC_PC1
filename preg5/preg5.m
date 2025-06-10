% P a r m e t r o s b s i c o s
A = 1; B = 1; C = 1;
a = 3; b = 2; c = 5;
delta_x = 0;
delta_y = pi /2;
delta_z = pi /4;

% Tiempo
t = linspace (0 , 2*pi , 1000) ;

% Ecuaciones p a r a m t r i c a s
x = A * sin (a*t + delta_x );
y = B * sin (b*t + delta_y );
z = C * sin (c*t + delta_z );

% G r f i c a
figure ;
plot3 (x , y , z , 'LineWidth ', 2) ;
grid on ;
xlabel ('X');
ylabel ('Y');
zlabel ('Z');
title ('Figura de Lissajous en 3D');
axis equal ;
view (45 , 30) ;
