function [ new_percolation ] = iteratePercolationAutomata( percolation, lattice )
%ITERATEPERCOLATIONAUTOMATA 


[Lx,Ly] = size(percolation);

new_percolation=percolation;
new_percolation(2:Lx,:) = or(new_percolation(2:Lx,:),percolation(1:(Lx-1),:));
new_percolation(1:(Lx-1),:) = or(new_percolation(1:(Lx-1),:),percolation(2:Lx,:));
new_percolation(:,2:Ly) = or(new_percolation(:,2:Ly),percolation(:,1:(Ly-1)));
new_percolation(:,1:(Ly-1)) = or(new_percolation(:,1:(Ly-1)),percolation(:,2:Ly));

new_percolation(2:Lx,2:Ly)=or(new_percolation(2:Lx,2:Ly),percolation(1:(Lx-1),1:(Ly-1)));
new_percolation(1:(Lx-1),1:(Ly-1))=or(new_percolation(1:(Lx-1),1:(Ly-1)),percolation(2:Lx,2:Ly));
new_percolation(2:Lx,1:(Ly-1))=or(new_percolation(2:Lx,1:(Ly-1)),percolation(1:(Lx-1),2:Ly));
new_percolation(1:(Lx-1),2:Ly)=or(new_percolation(1:(Lx-1),2:Ly),percolation(2:Lx,1:(Ly-1)));

new_percolation=and(new_percolation,~lattice);

end

