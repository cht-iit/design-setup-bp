close all;
clear;
clc;

% we save result here
root=getenv('ROBOT_CODE')+"/design-setup-bp";
if ~exist(root,'dir')
   warning('Could not find %s',root);
   return;
end
folder=root+"/data-analysis/robustness/";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   PARAMETERS                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nominal pose we selected
NOMINAL_POSE=[-0.35 0.0 -0.05 0.0 0.0 1.0 3.14];

% thresholds for errors
ERR_POS_THRESH=1; %cm
ERR_ORI_THRESH=15; %deg
JOINTS_THRESH=5; %deg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 JOINT LIMITS                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% yarp rpc /icubSim/left_arm/rpc:i
% get llim 0
leftarm_ranges=[-95.0, 0.0, -37.0, 15.0, -60.0, -80.0, -20.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0; ...
    10.0, 160.0, 80.0, 106.0, 60.0, 25.0, 25.0, ...
    60.0, 90.0, 90.0, 180.0, 90.0, 180.0, 90.0, 180.0, 270.0];
leftarm_joints=["shoulder_pitch"; "shoulder_roll";"shoulder_yaw";"elbow";
    "wrist_prosup";"wrist_pitch";"wrist_yaw";"hand_fingers";"thumb_oppose";
    "thumb_proximal";"thumb_distal";"index_proximal";"index_distal";
    "middle_proximal";"middle_distal";"pinky"];

torso_ranges=[-50.0, -30.0, -20.0; ... 
    50.0, 30.0, 70.0];
torso_joints=["torso_yaw";"torso_roll";"torso_pitch"];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% compute errors
files=dir(folder);
dirflags=[files.isdir];
subfolders=files(dirflags);
deltax=[];
deltay=[];
deltaz=[];
for k=1:length(subfolders)
  subfolder_name=subfolders(k).name;
  if (contains(subfolder_name,'target'))
      fprintf('Analyzing %s\n',subfolders(k).name);
           
      pose_filename=folder+"/"+subfolder_name+"/pose/data.log";
      if (isfile(pose_filename))
          pose=importdata(pose_filename);
      else
          warning('Could not open %s',pose_filename);
          warning('Skipping');
          continue;
      end
                 
      leftarm_filename=folder+"/"+subfolder_name+"/left_arm/data.log";
      if (isfile(leftarm_filename))
          left_arm=importdata(leftarm_filename);
      else
          warning('Could not open %s',leftarm_filename);
          warning('Skipping');
          continue;
      end
            
      torso_filename=folder+"/"+subfolder_name+"/torso/data.log";
      if (isfile(torso_filename))
          torso=importdata(torso_filename);
      else
          warning('Could not open %s',torso_filename);
          warning('Skipping');
          continue;
      end
      
      target_filename=folder+"/"+subfolder_name+"/target.log";
      if (isfile(target_filename))
          target=importdata(target_filename);
      else
          warning('Could not open %s',target_filename);
          warning('Skipping');
          continue;
      end
      
      [errx,erro,low_leftarm,high_leftarm,low_torso,high_torso]=...
          computeErrors(pose(:,3:end),target,left_arm(:,3:end),...
          torso(:,3:end),leftarm_ranges,torso_ranges);
      
      deltax=[target(1)-NOMINAL_POSE(1); deltax];
      deltay=[target(2)-NOMINAL_POSE(2); deltay];
      deltaz=[target(3)-NOMINAL_POSE(3); deltaz];
      
      % save result
      fid=fopen(folder+"/"+subfolder_name+"/result.log",'w');      
      time=pose(:,2)-pose(1,2);            
      fprintf(fid,'%s %3f\n','tstart',time(1));
      fprintf(fid,'%s %3f\n','tend',time(end));
      fprintf(fid,'%s %3f\n','errx',mean(errx));
      fprintf(fid,'%s %3f\n','erro',mean(erro));
      for i=1:size(leftarm_joints,1)
          fprintf(fid,'%s %3f %3f\n',leftarm_joints(i),mean(low_leftarm(:,i)),...
              mean(high_leftarm(:,i)));
      end
      
      for i=1:size(torso_joints,1)
          fprintf(fid,'%s %3f %3f\n',torso_joints(i),mean(low_torso(:,i)),...
              mean(high_torso(:,i)));
      end      
      fclose(fid);
  end
end

%% assess robustness
[err_pos,err_ori,nabove_pos,nabove_ori,shoulder_pitch,...
    shoulder_roll,shoulder_yaw,elbow,wrist_prosup,wrist_yaw,wrist_pitch,...
    torso_yaw,torso_roll,torso_pitch]=...
    assessRobustness(folder,ERR_POS_THRESH,ERR_ORI_THRESH);
fprintf('Err pos: mean = %.2f, std = %.2f\n',mean(err_pos),std(err_pos));
fprintf('Err ori: mean = %.2f, std = %.2f\n',mean(err_ori),std(err_ori));
fprintf('Samples above error thresh in position %.2f: %.2f\n',ERR_POS_THRESH,nabove_pos*100);
fprintf('Samples above error thresh in orientation %.2f: %.2f\n',ERR_ORI_THRESH,nabove_ori*100);

%% visualization
% err pos
figure(1);
histogram(err_pos,'BinWidth',0.05,'FaceColor','b'); hold on;
plot(ERR_POS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Error position [cm]');
ylabel('Frequency [#]');
xlim([0.0 2.0]);
ylim([0 15]);

% err ori
figure(2);
histogram(err_ori,'BinWidth',1,'FaceColor','b'); hold on;
plot(ERR_ORI_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Error orientation [deg]');
ylabel('Frequency [#]');
xlim([0.0 50.0]);
ylim([0 15]);

% joint configuration
figure(3); set(gcf,'position',[680         604        1191         365]);
subplot(2,5,1);
histogram(shoulder_pitch(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(shoulder_pitch(:,2),'BinWidth',5,'FaceColor','r'); 
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Shoulder pitch [deg]');
ylabel('Frequency [#]');
ylim([0 40]);
subplot(2,5,2);
histogram(shoulder_roll(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(shoulder_roll(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Shoulder roll [deg]');
ylim([0 40]);
subplot(2,5,3);
histogram(shoulder_yaw(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(shoulder_yaw(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Shoulder yaw [deg]');
ylim([0 40]);
subplot(2,5,4);
histogram(elbow(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(elbow(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Elbow [deg]');
ylim([0 40]);
subplot(2,5,5);
histogram(wrist_prosup(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(wrist_prosup(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Wrist prosup [deg]');
ylim([0 40]);
subplot(2,5,6);
histogram(wrist_pitch(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(wrist_pitch(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Wrist pitch [deg]');
ylabel('Frequency [#]');
ylim([0 40]);
subplot(2,5,7);
histogram(wrist_yaw(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(wrist_yaw(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Wrist yaw [deg]');
ylim([0 40]);
subplot(2,5,8);
histogram(torso_yaw(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(torso_yaw(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Torso yaw [deg]');
ylim([0 40]);
subplot(2,5,9);
histogram(torso_roll(:,1),'BinWidth',1,'FaceColor','k'); hold on;
histogram(torso_roll(:,2),'BinWidth',1,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Torso roll [deg]');
ylim([0 40]);
subplot(2,5,10);
histogram(torso_pitch(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(torso_pitch(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Torso pitch [deg]');
ylim([0 40]);

% err pos with x/y ranges
icub_hand=root+"/assets/icub-hand-gazebo.png";
[img, map, alphachannel] = imread(icub_hand);
width=0.6;
heigth=1.0;
figure(4); set(gcf,'position',[675   238   937   731]);
scatter(deltay.*100,deltax.*100,20,err_pos,'filled');
set(gca, 'CLim', [min(err_pos) 2]);
cbar(1) = colorbar;
set(cbar(1),'YLim',[min(err_pos) 2]);
set(gca,'ydir','reverse');
ax1=gca;
ax2=axes('Position',get(gca,'Position'), 'Color','none');
set(gca,'YTickLabel',[]);
hold on;
image([-width width],[heigth -heigth],img,'AlphaData', alphachannel);
grid on;
hold off;
xlabel('Y range [cm]');
ylabel('X range [cm]');
xlim([-3 3]);
ylim([-5 5]);

% err ori with x/y ranges
figure(5); set(gcf,'position',[675   238   937   731]);
scatter(deltay.*100,deltax.*100,20,err_ori,'filled');
set(gca, 'CLim', [min(err_ori) 20]);
cbar(1) = colorbar;
set(cbar(1),'YLim',[min(err_ori) 20]);
set(gca,'ydir','reverse');
ax1=gca;
ax2=axes('Position',get(gca,'Position'), 'Color','none');
set(gca,'YTickLabel',[]);
hold on;
image([-width width],[heigth -heigth],img,'AlphaData', alphachannel);
grid on;
hold off;
xlabel('Y range [cm]');
ylabel('X range [cm]');
xlim([-3 3]);
ylim([-5 5]);

% err elbow with x/y ranges
figure(6); set(gcf,'position',[675   238   937   731]);
scatter(deltay.*100,deltax.*100,20,elbow(:,1),'filled');
set(gca, 'CLim', [min(elbow(:,1)) 15]);
cbar(1) = colorbar;
set(cbar(1),'YLim',[min(elbow(:,1)) 15]);
oldcmap = colormap;
colormap( flipud(oldcmap) );
set(gca,'ydir','reverse');
ax1=gca;
ax2=axes('Position',get(gca,'Position'), 'Color','none');
set(gca,'YTickLabel',[]);
hold on;
image([-width width],[heigth -heigth],img,'AlphaData', alphachannel);
grid on;
hold off;
xlabel('Y range [cm]');
ylabel('X range [cm]');
xlim([-3 3]);
ylim([-5 5]);