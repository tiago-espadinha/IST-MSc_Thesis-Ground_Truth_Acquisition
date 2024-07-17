function vrml_world_init(dataId)

%VRML_WORLD_INIT - Initiatizes two virtual worlds, the first is the main
%world and the second is the background. It also gets all pointers' nodes
%into a variable
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior T�cnico
% March 2013; Last revision: 12-Aug-2013

%------------- BEGIN MAIN FUNCTION ---------------

global world
global wnodes
global world_fig

%test if open
if ~isempty(world)
    vrml_world_end;
end

%open vrworld

if 1
    
    world{1} = vrworld('vr_world.wrl');
    world{2} = vrworld('vr_world_2.wrl');
    
    open(world{1});
    open(world{2});
    
    wnodes_aux{1} = get(world{1},'Nodes');
    wnodes_aux{2} = get(world{2},'Nodes');
    
    world_fig{1} = vrfigure(world{1});
    world_fig{2} = vrfigure(world{2});
    
    set(world_fig{1}, 'NavPanel', 'Opaque');
    set(world_fig{2}, 'NavPanel', 'Opaque');
    
    %load nodes
    
    for j=1:2
        for i=1:length(wnodes_aux{j});
            name=get(wnodes_aux{j}(i),'Name');
            switch name
                case 'camera1'
                    wnodes{j}.camera{1}= wnodes_aux{j}(i);
                case 'camera2'
                    wnodes{j}.camera{2}= wnodes_aux{j}(i);
                case 'camera3'
                    wnodes{j}.camera{3}= wnodes_aux{j}(i);
                case 'camera4'
                    wnodes{j}.camera{4}= wnodes_aux{j}(i);
                case 'cameratop'
                    wnodes{j}.camera{5}= wnodes_aux{j}(i);
                case 'bus1'
                    wnodes{j}.bus{1}= wnodes_aux{j}(i);
                case 'bus2'
                    wnodes{j}.bus{2}= wnodes_aux{j}(i);
                case 'bus3'
                    wnodes{j}.bus{3}= wnodes_aux{j}(i);
                case 'bus4'
                    wnodes{j}.bus{4}= wnodes_aux{j}(i);
            end
        end
    end
    
    disp('World Initiated');
    
end

%------------- END OF MAIN FUNCTION --------------
