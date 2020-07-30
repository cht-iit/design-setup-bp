clear;
clc;

% we save result here
root=getenv('ROBOT_CODE')+"/design-setup-bp";
if ~exist(root,'dir')
   warning('Could not find %s',root);
   return;
end
folder=root+"/data-analysis/nominal-pose/";

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   PARAMETERS                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %number of repetition of each pose
NREP=3;

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
tot_errx=[];
tot_erro=[];
shoulder_pitch=[];
shoulder_roll=[];
shoulder_yaw=[];
elbow=[];
wrist_prosup=[];
wrist_yaw=[];
wrist_pitch=[];
torso_yaw=[];
torso_roll=[];
torso_pitch=[];
for k=1:length(subfolders)
  subfolder_name=subfolders(k).name;
  if (contains(subfolder_name,'target'))
      fprintf('Analyzing %s\n',subfolders(k).name);
           
      target_filename=folder+"/"+subfolder_name+"/target.log";
      if (isfile(target_filename))
          target=importdata(target_filename);
      else
          warning('Could not open %s',target_filename);
          warning('Skipping');
          continue;
      end
      
      mean_errx=zeros(3,1);
      mean_erro=zeros(3,1);
      mean_low_leftarm=zeros(3,16);
      mean_high_leftarm=zeros(3,16);
      mean_low_torso=zeros(3,3);
      mean_high_torso=zeros(3,3);
      for j=0:NREP-1
          pose_filename=folder+"/"+subfolder_name+"/pose_"+num2str(j)+"/data.log";
          if (isfile(pose_filename))
              pose=importdata(pose_filename);
          else
              warning('Could not open %s',pose_filename);
              warning('Skipping');
              continue;
          end
          
          leftarm_filename=folder+"/"+subfolder_name+"/left_arm_"+num2str(j)+"/data.log";
          if (isfile(leftarm_filename))
              left_arm=importdata(leftarm_filename);
          else
              warning('Could not open %s',leftarm_filename);
              warning('Skipping');
              continue;
          end
          
          torso_filename=folder+"/"+subfolder_name+"/torso_"+num2str(j)+"/data.log";
          if (isfile(torso_filename))
              torso=importdata(torso_filename);
          else
              warning('Could not open %s',torso_filename);
              warning('Skipping');
              continue;
          end
          
          [errx,erro,low_leftarm,high_leftarm,low_torso,high_torso]=...
              computeErrors(pose(:,3:end),target,left_arm(:,3:end),...
              torso(:,3:end),leftarm_ranges,torso_ranges);
          
          if (subfolders(k).name=="target_8")
              tot_errx=[errx; tot_errx];
              tot_erro=[erro; tot_erro];
              shoulder_pitch=[low_leftarm(:,1) high_leftarm(:,2); shoulder_pitch];
              shoulder_roll=[low_leftarm(:,3) high_leftarm(:,4); shoulder_roll];
              shoulder_yaw=[low_leftarm(:,5) high_leftarm(:,6); shoulder_yaw];
              elbow=[low_leftarm(:,7) high_leftarm(:,8); elbow];
              wrist_prosup=[low_leftarm(:,9) high_leftarm(:,9); wrist_prosup];
              wrist_pitch=[low_leftarm(:,10) high_leftarm(:,10); wrist_pitch];
              wrist_yaw=[low_leftarm(:,11) high_leftarm(:,11); wrist_yaw];
              torso_yaw=[low_torso(:,1) high_torso(:,1); torso_yaw];
              torso_roll=[low_torso(:,2) high_torso(:,2); torso_roll];
              torso_pitch=[low_torso(:,3) high_torso(:,3); torso_pitch];
          end
          
          mean_errx(j+1)=mean(errx);
          mean_erro(j+1)=mean(erro);          
          mean_low_leftarm(j+1,:)=mean(low_leftarm);
          mean_high_leftarm(j+1,:)=mean(high_leftarm);
          mean_low_torso(j+1,:)=mean(low_torso);
          mean_high_torso(j+1,:)=mean(high_torso);
      end
      % save result
      fid=fopen(folder+"/"+subfolder_name+"/result.log",'w');
      time=pose(:,2)-pose(1,2);
      fprintf(fid,'%s %3f\n','tstart',time(1));
      fprintf(fid,'%s %3f\n','tend',time(end));
      fprintf(fid,'%s %3f\n','errx',mean(mean_errx));
      fprintf(fid,'%s %3f\n','erro',mean(mean_erro));
      for i=1:size(leftarm_joints,1)
          fprintf(fid,'%s %3f %3f\n',leftarm_joints(i),mean(mean_low_leftarm(:,i)),...
              mean(mean_high_leftarm(:,i)));
      end
      
      for i=1:size(torso_joints,1)
          fprintf(fid,'%s %3f %3f\n',torso_joints(i),mean(mean_low_torso(:,i)),...
              mean(mean_high_torso(:,i)));
      end
      
      fclose(fid);
  end
end

%% visualization
% err pos
figure(1);
histogram(tot_errx.*100,'BinWidth',0.01,'FaceColor','b'); hold on;
plot(ERR_POS_THRESH.*ones(141,1),0:140,'m--','LineWidth',3); hold off;
xlabel('Error position [cm]');
ylabel('Frequency [#]');

% err ori
figure(2);
histogram(asind(tot_erro),'BinWidth',0.1,'FaceColor','b'); hold on;
plot(ERR_ORI_THRESH.*ones(201,1),0:200,'m--','LineWidth',3); hold off;
xlabel('Error ori [deg]');
ylabel('Frequency [#]');

% joint configuration
figure(3); set(gcf,'position',[680         604        1191         365]);
subplot(2,5,1);
histogram(shoulder_pitch(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(shoulder_pitch(:,2),'BinWidth',5,'FaceColor','r'); 
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Shoulder pitch [deg]');
ylabel('Frequency [#]');
ylim([0 100]);
subplot(2,5,2);
histogram(shoulder_roll(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(shoulder_roll(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Shoulder roll [deg]');
ylim([0 100]);
subplot(2,5,3);
histogram(shoulder_yaw(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(shoulder_yaw(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Shoulder yaw [deg]');
ylim([0 100]);
subplot(2,5,4);
histogram(elbow(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(elbow(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Elbow [deg]');
ylim([0 100]);
subplot(2,5,5);
histogram(wrist_prosup(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(wrist_prosup(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Wrist prosup [deg]');
ylim([0 100]);
subplot(2,5,6);
histogram(wrist_pitch(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(wrist_pitch(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Wrist pitch [deg]');
ylabel('Frequency [#]');
ylim([0 100]);
subplot(2,5,7);
histogram(wrist_yaw(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(wrist_yaw(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Wrist yaw [deg]');
ylim([0 100]);
subplot(2,5,8);
histogram(torso_yaw(:,1),'BinWidth',5,'FaceColor','k'); hold on;
histogram(torso_yaw(:,2),'BinWidth',5,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Torso yaw [deg]');
ylim([0 100]);
subplot(2,5,9);
histogram(torso_roll(:,1),'BinWidth',1,'FaceColor','k'); hold on;
histogram(torso_roll(:,2),'BinWidth',1,'FaceColor','r');
plot(JOINTS_THRESH.*ones(101,1),0:100,'m--','LineWidth',3); hold off;
xlabel('Torso roll [deg]');
ylim([0 100]);