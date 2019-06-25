%% const 
POINTNEIGHBOR = 10;
MAXDISTANCE=0.002;


%% load pipe
ptCloudIn = pcread('data/one-pipe.pcd');
pcshow(ptCloudIn);


%% denoise
ptCloudDenoised = pcdenoise(ptCloudIn);


%% compute normals and assign to the cloud
normals=pcnormals(ptCloudDenoised,POINTNEIGHBOR);
ptCloudDenoised.Normal=normals;


%% compute height direction using PCA
[coeff,score,latent] = pca(ptCloudDenoised.Location);
% get height orientation of the cylinder
heightOrientation=coeff(:,1);


%% fit cylinder using pcafitcylinder
% Set the maximum point-to-cylinder distance (5 mm) for the fitting.
maxDistance = MAXDISTANCE; % 0.005

% Set the region of interest to constrain the search.
% roi = [0.4,0.6;-inf,0.2;0.1,inf];
% roi = [ptCloud.XLimits;ptCloud.YLimits;ptCloud.ZLimits];
% sampleIndices = findPointsInROI(ptCloud,roi);

% Set the orientation constraint.
referenceVector = heightOrientation.';

% NOTE: THIS METHOD NOT ROBUST, DURING THE LOOP, radius may vary 5-10mm
% Detect the cylinder in the point cloud and extract it.
for i = 1:1:6
    [model,inlierIndices,outlierIndices,meanError] = pcfitcylinder(ptCloudDenoised,maxDistance,referenceVector);
    % disp(meanError);
    disp(model.Radius);
    disp(meanError);
    % disp(model.Height);
    % break;
end


%% Plot the cylinder.
hold on
plot(model) 

