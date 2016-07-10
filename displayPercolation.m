function [  ] = displayPercolation( percolation, lattice, color, oldpercolation )
%DISPLAYPERCOLATION 

[Lx,Ly] = size(percolation);
S = zeros(Lx,Ly,3);

if oldpercolation==0 %oldpercolation is optional
    S(:,:,1)=lattice*0.5;
    S(:,:,2)=lattice*0.5+((percolation-lattice)>0);
    S(:,:,3)=lattice*0.5;
else
    diff=and(~oldpercolation,percolation);
    S(:,:,mod(0+color,3)+1)=lattice*0.5+((percolation-lattice)>0)*0.7+((diff-lattice)>0)*0.3;
    S(:,:,mod(1+color,3)+1)=lattice*0.5;
    S(:,:,mod(2+color,3)+1)=lattice*0.5;
end

image(S);axis off;


end

