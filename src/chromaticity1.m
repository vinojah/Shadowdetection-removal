%change the 3*3 matrix into 2*2 matrix
%Change the size of the image for preprocessing in GUI!!!
function [X,Y] = chromaticity1(R, G, B)
    GR = G ./ R; %X
    BR = B ./ R; %Y
    s = size(R,1) * size(R,2);
    X = reshape(GR, 1, s);
    Y = reshape(BR, 1, s);
    X = double(X); Y = double(Y);
    X = arrayfun(@(x) log(x), X);
    Y = arrayfun(@(x) log(x), Y);
end