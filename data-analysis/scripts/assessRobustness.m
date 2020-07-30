function [err_pos,err_ori,nabove_pos,nabove_ori,shoulder_pitch,...
    shoulder_roll,shoulder_yaw,elbow,wrist_prosup,wrist_yaw,wrist_pitch,...
    torso_yaw,torso_roll,torso_pitch]=assessRobustness(folder,errpos_thresh,errori_thresh)
% ASSESSROBUSTNESS computes errors of all targets around the nominal pose.
% 
% INPUTS:
% folder: folder where all data are stored
% errpos_thresh: threshold on position error (cm)
% errori_thresh: threshold on orientation error (deg)
%
% OUTPUTS:
% err_pos: [NPOSESx1] vector containing the position error for each pose 
% err_ori: [NPOSESx1] vector containing the orientation error for each pose 
% nabove_pos: percentage of poses whose position error is above the threshold
% nabove_ori: percentage of poses whose orientation error is above the threshold
% shoulder_pitch: [NPOSESx2] matrix containing the distance of shoulder pitch 
%                 low and high bound (first and second column respectively)
% shoulder_roll: [NPOSESx2] matrix containing the distance of shoulder roll 
%                 low and high bound (first and second column respectively)
% shoulder_yaw: [NPOSESx2] matrix containing the distance of shoulder yaw 
%                 low and high bound (first and second column respectively)
% elbow: [NPOSESx2] matrix containing the distance of elbow 
%                 low and high bound (first and second column respectively)
% wrist_prosup: [NPOSESx2] matrix containing the distance of wrist prosup 
%                 low and high bound (first and second column respectively)
% wrist_yaw: [NPOSESx2] matrix containing the distance of wrist yaw 
%                 low and high bound (first and second column respectively)
% wrist_pitch: [NPOSESx2] matrix containing the distance of wrist pitch 
%                 low and high bound (first and second column respectively)
% torso_yaw: [NPOSESx2] matrix containing the distance of torso yaw
%                 low and high bound (first and second column respectively) 
% torso_roll: [NPOSESx2] matrix containing the distance of torso roll 
%                 low and high bound (first and second column respectively)
% torso_pitch: [NPOSESx2] matrix containing the distance of torso pitch 
%                 low and high bound (first and second column respectively)

% Author: Valentina Vasco <valentina.vasco@iit.it>

files=dir(folder);

% Get a logical vector that tells which is a directory.
dirflags=[files.isdir];
% Extract only those that are directories.
subfolders=files(dirflags);
err_pos=[];
err_ori=[];
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
      fprintf('Analyzing %s\n', subfolders(k).name);
      fid=fopen(folder+"/"+subfolder_name+"/result.log",'rt');
      
      if (fid<0)
          warning('Could not open %s',folder+"/"+subfolder_name+"/result.log");
          warning('Skipping');
          continue;
      end
      data=textscan(fid,'%s %f %f','Delimiter',' ');
      
      % errors on pose
      err_pos=[data{1,2}(3)*100; err_pos];
      err_ori=[asind(data{1,2}(4)); err_ori];
      
      % errors on joints [low high]
      shoulder_pitch=[data{1,2}(5) data{1,3}(5); shoulder_pitch];
      shoulder_roll=[data{1,2}(6) data{1,3}(6); shoulder_roll];
      shoulder_yaw=[data{1,2}(7) data{1,3}(7); shoulder_yaw];
      elbow=[data{1,2}(8) data{1,3}(8); elbow];
      wrist_prosup=[data{1,2}(9) data{1,3}(9); wrist_prosup];
      wrist_pitch=[data{1,2}(10) data{1,3}(10); wrist_pitch];
      wrist_yaw=[data{1,2}(11) data{1,3}(11); wrist_yaw];
      torso_yaw=[data{1,2}(21) data{1,3}(21); torso_yaw];
      torso_roll=[data{1,2}(22) data{1,3}(22); torso_roll];
      torso_pitch=[data{1,2}(23) data{1,3}(23); torso_pitch];
            
      fclose(fid);
  end
end

% compute percentage above the thresholds
nabove_pos=length(err_pos(err_pos>errpos_thresh))/length(err_pos);
nabove_ori=length(err_ori(err_ori>errori_thresh))/length(err_ori);

end