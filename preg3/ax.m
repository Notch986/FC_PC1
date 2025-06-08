function a=ax(x,y)
  G=6.67430e-11;
  M=5.972e24;
  GM=G*M;
  a=-GM * x./(x.^2 + y.^2).^(3./2);