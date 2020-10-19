%making nice figures

img = 'CT_20444767425_1.2.840.1275.2208.2.1.4.3583805190.10452.1582508687.36683.dcm';
im = double(mat2gray(dicomread(img)));




seg=load('C:\Users\Ricky Hu\Desktop\repo\liver_mets\seg.mat');
seg = seg.seg;

figure(1);
colormap('gray');
low = 0.3;
high = 0.6;
im2 = imadjust(im,[low high],[]);
imagesc(im2);

%overlaying liver
green = cat(3, zeros(size(im)), ones(size(im)), zeros(size(im)));
hold on
h = imagesc(green);
hold off
set(h, 'AlphaData', seg/9);

skew = skewness(im);
figure(2)

patchSizeY = 20;
patchSizeX = 20;
[rows cols] = size(im);

% creating patches first so this doesn't have to be repeated
patchStartX = zeros(rows, cols);
patchEndX = zeros(rows, cols);
patchStartY = zeros(rows,cols);
patchEndY = zeros(rows,cols);

skewPatches = zeros(rows,cols);

for i = 1:rows
    for j = 1:cols
        patchStartX(i,j) = j - floor(patchSizeX/2);
        patchEndX(i,j) = j + floor(patchSizeX/2);
        patchStartY(i,j) = i - floor(patchSizeY/2);
        patchEndY (i,j)= i + floor(patchSizeY/2);      

        if (i < floor(patchSizeY/2) + 1)
            patchStartY(i,j) = 1;
        elseif (i > (rows - ceil(patchSizeY/2)) - 1)
            patchEndY(i,j) = rows;
        end

        if (j < floor(patchSizeX/2) + 1)
            patchStartX(i,j) = 1;
        elseif(j > (cols - ceil(patchSizeX/2) -1))
            patchEndX(i,j) = cols;
        end
    end
end

% computing stats for each patch
for i = 1:rows
    for j = 1:cols
        patch = im(patchStartY(i,j):patchEndY(i,j), patchStartX(i,j):patchEndX(i,j));
        skewPatches(i,j) = skewness(reshape(patch.',1,[]));
        sprintf('%d, %d',i, j);
    end
end

skewPatches(isnan(skewPatches)) = 0 ;
figure(2)

colormap('gray');
skewFig = mat2gray(skewPatches.*seg);
low = 0.2;
high = 0.9;
skewFig = imadjust(skewFig,[low high],[]);
imagesc(skewFig);
