% berlin  based on some psduoed code

% % 
% put this in script for initializing lattice
% matr = zeros(Lx,Ly);
% matr = perlin(matr);
% amp = 0.55 *
% % adjust for degree of clustering, shifts probability tho,
% % hard to tell by how much tho 
% lattice = amp*matr+rand(Lx,Ly)>p;lattice(1,:) = 0;
function matr = perlin(L)

    matr = zeros(L,L);

    [n, m] = size(matr); %best if zerod i think
    i = 0;
    w = 60;%sqrt(n*m); % weights yo

    while (w > 3)
        i = i + 1;
        d = interp2(randn(n, m), i-1, 'linear');
        matr = matr + i * d(1:n, 1:m);
        w = w - ceil(w/2 - 1);
    end
    
end
