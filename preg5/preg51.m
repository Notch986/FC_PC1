% F u n c i n para generar figuras de Lissajous 3D
function [x , y , z] = lissajous_3d (t , Ax , Ay , Az , wx , wy , wz , phix , phiy , phiz )
x = Ax * sin ( wx * t + phix );
y = Ay * sin ( wy * t + phiy );
z = Az * sin ( wz * t + phiz );
end

% C o n f i g u r a c i o n e s diferentes
configuraciones = {
% [Ax , Ay , Az , wx , wy , wz , phix , phiy , phiz ]
[1 , 1, 1 , 1 , 2 , 3 , 0, pi /2 , pi /4] , % C o n f i g u r a c i n 1
[1 , 1, 1 , 3 , 2 , 5 , 0, pi /2 , pi /4] , % C o n f i g u r a c i n 2
[1 , 1, 1 , 2 , 3 , 1 , 0, 0, pi /2] , % C o n f i g u r a c i n 3
[1 , 1, 1 , 5 , 4 , 3 , pi /4 , pi /2 , 0] % C o n f i g u r a c i n 4
};

% P a r m e t r o temporal
t = linspace (0 , 4*pi , 2000) ;

% Generar m l t i p l e s figuras
figure ('Position ', [100 , 100 , 1200 , 800]) ;

for i = 1: length ( configuraciones )
config = configuraciones {i };
[x , y , z] = lissajous_3d (t , config (1) , config (2) , config (3) , ...
config (4) , config (5) , config (6) , ...
config (7) , config (8) , config (9) ) ;

subplot (2 , 2, i);
plot3 (x , y , z , 'LineWidth ', 1.5) ;
grid on ;
xlabel ('X'); ylabel ('Y'); zlabel ('Z') ;
title ( sprintf (' C o n f i g u r a c i n %d: = [ %g, %g, %g]', i , ...
config (4) , config (5) , config (6) )) ;
axis equal ;
view (45 , 30) ;
end

sgtitle ('Figuras de Lissajous 3D con diferentes configuraciones ');
