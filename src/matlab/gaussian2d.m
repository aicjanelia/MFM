function z = gaussian2d(par,xy)
z = par(1)*exp(-(((xy(:,1)-par(2))/par(3)).^2 + ((xy(:,2)-par(4))/par(5)).^2));