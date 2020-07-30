function [errx,erro,low_leftarm,high_leftarm,low_torso,high_torso]=...
    computeErrors(reached,desired,left_arm,torso,leftarm_ranges,torso_ranges)
% COMPUTEERRRORS computes errors in position and orientation and joints 
% distances from their bounds. 
% 
% INPUTS:
% reached: [Nx7] matrix containing reached poses in the form [x1 y1 z1 ax1 ay1 az1 theta1; 
%                                                          ...xN yN zN axN ayN azN thetaN];
% desired: [1x7] vector containing desired poses in the form [x y z ax ay az theta];
% left_arm: [Nx16] matrix containing left arm joint positions
% torso: [Nx3] matrix containing torso joint positions
% leftarm_ranges: [2x16] matrix containing bounds for left arm joints
% torso_ranges: [2x3] matrix containing bounds for torso joints
%
% OUTPUTS:
% errx: [Nx1] vector containing the error in position
% erro: [Nx1] vector containing the error in orientation
% low_leftarm: [Nx16] matrix containing distances of leftarm joints to
%              their lower bounds
% high_leftarm: [Nx16] matrix containing distances of leftarm joints to
%              their higher bounds
% low_torso: [Nx16] matrix containing distances of torso joints to
%              their lower bounds
% high_torso: [Nx16] matrix containing distances of torso joints to
%              their higher bounds
% 
% Author: Valentina Vasco <valentina.vasco@iit.it>


x=reached(:,1:3);
o=reached(:,4:end);
xd=desired(1:3).*ones(size(x,1),3);
od=desired(4:7).*ones(size(o,1),4);

errx=vecnorm(x-xd,2,2);
erro=zeros(size(o,1),1);
for i=1:size(o,1)
    Rd=axang2rotm(od(i,:));
    R=axang2rotm(o(i,:));
    Re=Rd*R';
    oe=rotm2axang(Re);
    erro(i)=sin(oe(4));
end

low_leftarm=abs(left_arm-leftarm_ranges(1,:));
high_leftarm=abs(left_arm-leftarm_ranges(2,:));
low_torso=abs(torso-torso_ranges(1,:));
high_torso=abs(torso-torso_ranges(2,:));

end
