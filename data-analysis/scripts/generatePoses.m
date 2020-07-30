clear;
clc;

% we save the target list here
root=getenv('ROBOT_CODE')+"/design-setup-bp";
if ~exist(root,'dir')
   warning('Could not find %s',root);
   return;
end
folder=root+"/data-analysis/robustness/";
outfile=folder+"target_list.txt";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   PARAMETERS                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nominal pose we selected
NOMINAL_POSE=[-0.35 0.0 -0.05 0.0 0.0 1.0 3.14];

% parameters for uniform sampling
NPOSES=100;
X_RANGE=[-0.05 0.05]; %m
Y_RANGE=[-0.03 0.03]; %m
Z_RANGE=[-0.01 0.01]; %m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% uniform sampling
x=X_RANGE(1)+(X_RANGE(2)-X_RANGE(1)).*rand(NPOSES,1);
y=Y_RANGE(1)+(Y_RANGE(2)-Y_RANGE(1)).*rand(NPOSES,1);
z=Z_RANGE(1)+(Z_RANGE(2)-Z_RANGE(1)).*rand(NPOSES,1);

% outposes
poses=ones(NPOSES,7).*NOMINAL_POSE;
poses(:,1)=poses(:,1)+x;
poses(:,2)=poses(:,2)+y;
poses(:,3)=poses(:,3)+z;

% write to file
writematrix(poses,outfile,'delimiter',' ');