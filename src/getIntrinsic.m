%removing noise 
function [intrinsic, bestTheta] = getIntrinsic(I, chromaticityType, entropyBias, showChromaticity, showEntropy, use_theta)

%if the size is not valid
if (size(I,3) ~= 3)
   error('Image is not RGB!'); 
end

I = im2double(I);
myfilter = fspecial('gaussian',[3 3], 0.5);
I = imfilter(I, myfilter, 'replicate');


I(I==0) = 1;

R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);
    

if (chromaticityType == 1)
    
   
    [X, Y] = chromaticity1(R, G, B);
else
    [X, Y] = chromaticity2(R, G, B);
end
chromaticityVec = [X; Y];
if showChromaticity
    
end


bestTheta = 1;
bestEntropy = inf;
bestProj = [];


idx = 1;
[~, num] = size(chromaticityVec);
l_start = 1; l_end = 180; l_step = 5;
if((use_theta >= 0) &&  (use_theta < 181))
    l_start = use_theta;
    l_end = use_theta;
    l_step = 1;
    showEntropy = false;
end;


entropy = zeros(1, floor((l_end-l_start) / l_step) + 1);
for theta = l_start:l_step:l_end
    x = cos(theta * pi / 180);
    y = sin(theta * pi / 180);
    u = [x; y];
    proj = zeros(1,num);
    for i = 1:num
       proj(i) = dot(chromaticityVec(:,i), u);
    end
    entropy(idx) = getEntropy(proj, entropyBias);
    if(entropy(idx) < bestEntropy)
       bestTheta = theta;
       bestEntropy = entropy(idx);
       bestProj = proj;
    end
    idx = idx + 1;
end
if showEntropy
   
end

minBestProj = abs(min(bestProj));
bestProj = bestProj + minBestProj;
maxBestProj = max(bestProj);

intrinsic = reconstructChromaticity(I, maxBestProj, bestProj);
intrinsic = uint8(intrinsic);

end
