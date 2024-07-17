function vrml_msc(dataId, NumBus, NumCam)

%VRML_MSC - Opens the virtual world, the buses move through a path, the
%cameras follow the buses and in the end it closes the virtual world
%
% Inputs: none
%
% Outputs: none
%
% Other m-files required: vrml_world_init, ptz_ini, bus_ini,
% vrml_world_set, ptz_view_xyzr, ptz_set_pan_tilt_zoom, vrml_world_end
% Subfunctions: none
% MAT-files required: none
%
% Author: Tiago Castanheira
% Project: Multitasking of Smart Cameras
% Instituto Superior Técnico
% March 2013; Last revision: 3-May-2013

%------------- BEGIN CODE ---------------

cd0= cd;
p= which('vrml_msc.m'); p= strrep(p, 'vrml_msc.m', '');
cd(p)

global world_fig

global Time PrevTime
global waitList

PrevTime= 0;

if nargin < 1
    dataId= 1;
    NumBus= 2;
    NumCam= 2;
end

vrml_world_init(dataId)

[BusArray, CamArray]= vrml_world_info(NumBus, NumCam);

%% Initialization of local variables


A= zeros(NumBus,1);
rd= zeros(NumBus,1);

len_path= zeros(1, NumBus);

t= zeros(1,NumBus);
t_ekf= zeros(1,NumBus);
xyt_real= zeros(3,NumBus);
xyt_bgs= zeros(3,NumBus);
xyt_pred= cell(1,NumBus);
xyt_upd= cell(1,NumBus);

ptz_speed= [inf inf inf];

for bus=1:NumBus
    len_path(bus)= length(BusArray(bus).Path);
    t(bus)= BusArray(bus).time; %starting time
    xyt_pred{bus}= zeros(5,len_path(bus));
    xyt_upd{bus}= zeros(5,len_path(bus));
end

framearray=cell(2,NumCam);

waitList= [-1*ones(NumBus,1), zeros(NumBus,1)];

max_len= max(len_path);
max_t= max(t);
P= cell(NumBus,max_t);

figure(1); clf; hold on

for i=1:NumBus
    vrml_world_set(1, 'bus', bus, [1e6 1e6 0]);
    vrml_world_set(2, 'bus', bus, [1e6 1e6 0]);
end

videoarray = cell(NumCam+1, max_len+max_t);

%% MSC start

for Time=1:max_len+max_t
    
    fprintf('Time: %ds\n', Time);
    
    %% Buses' movement
    for bus=1:NumBus
        if Time<=len_path(bus)+t(bus)-1 && Time>=t(bus)
            xyt_real(:,bus)= [BusArray(bus).Path(1,Time-t(bus)+1); BusArray(bus).Path(2,Time-t(bus)+1); BusArray(bus).Path(3,Time-t(bus)+1)];
            vrml_world_set(1, 'bus', bus, xyt_real(:,bus)');
            if BusArray(bus).Path(2,Time-t(bus)+1)>- 350 %Coordenada y da câmara 1
                BusArray(bus).inside(1)= 1;
                xyt_act= xyt_real(:,bus);
                xyt_act(3)= xyt_act(3)+pi/2;
                fprintf('Real(bus %d): x= %.1fdm; y= %.1fdm; theta= %.1fdeg\n', bus, xyt_act(1), xyt_act(2), xyt_act(3)*180/pi);
            else
                BusArray(bus).inside= [0, 0];
            end
        end
    end
    
    %% EKF prediction
    for bus=1:NumBus
        if BusArray(bus).inside(1) == 1 && BusArray(bus).inside(2) == 1
            [xyt_pred{bus}(:,Time-t_ekf(bus)+1), P{bus,Time-t_ekf(bus)+1}]= ekf_bus(bus, [], P{bus,Time-t_ekf(bus)}, 2);
            xyt_act=xyt_pred{bus}(:,Time-t_ekf(bus)+1);
            
            %plot ellipse
            subplot(2,2,bus)
            draw_bus(xyt_act(1:3), xyt_act(5), 1)
            [A(bus), rd(bus)]= plot_ellipse(P{bus,Time-t_ekf(bus)+1}(1:2,1:2),xyt_act(1:2,1),'r');
            
            fprintf('EKF pred(bus %d): x= %.1fdm; y= %.1fdm; theta= %.1fdeg\n', bus, xyt_act(1), xyt_act(2), xyt_act(3)*180/pi);
        end
    end
    
    %% Multitasking
    %Fill ptz_dist (distances of each camera to each bus in pan, tilt and
    %zoom angles)
    
    ptz_dist= inf*ones(NumBus,3*NumCam);
    for bus=1:NumBus
        if BusArray(bus).inside(1)== 1
            for cam=1:NumCam
                xyz= [xyt_pred{bus}(1,Time-t_ekf(bus)+1), xyt_pred{bus}(2,Time-t_ekf(bus)+1), 0];
                [ptz_dist(bus,cam*3-2), ptz_dist(bus,cam*3-1), ptz_dist(bus,cam*3)]= ptz_view_xyzr(CamArray(cam), xyz, rd(bus));
                ptz_dist(bus,cam*3-2)= abs(ptz_dist(bus,cam*3-2)-CamArray(cam).pan); %pan
                ptz_dist(bus,cam*3-1)= abs(ptz_dist(bus,cam*3-1)-CamArray(cam).tilt); %tilt
                ptz_dist(bus,cam*3)= abs(ptz_dist(bus,cam*3)-CamArray(cam).zoom); %zoom
            end
        end
    end
    
    %trackBus= followmanager(BusArray, NumBus, NumCam);
    trackBus= multitasking(NumBus, NumCam, ptz_dist, A);
    
    %% Cameras' movement   
    for cam=1:NumCam
        if trackBus(cam)~=-1
            CamArray(cam).bus= trackBus(cam);
            bus=CamArray(cam).bus;
            if bus > 0
                if BusArray(bus).inside(1) == 1 && BusArray(bus).inside(2) == 1
                    %Move camera
                    xyz= [xyt_pred{bus}(1,Time-t_ekf(bus)+1), xyt_pred{bus}(2,Time-t_ekf(bus)+1), 0];
                    [pan, tilt, zoom]= ptz_view_xyzr(CamArray(cam), xyz, rd(bus));
                    
                    %Test pan speed
                    d_pan= pan- CamArray(cam).pan;
                    if d_pan > ptz_speed(1) || d_pan < -1*ptz_speed(1)
                        pan= CamArray(cam).pan+ sign(d_pan)*ptz_speed(1);
                        CamArray(cam).bus= 0;
                    end
                    %Test tilt speed
                    d_tilt= tilt- CamArray(cam).tilt;
                    if d_tilt > ptz_speed(2) || d_tilt < -1*ptz_speed(2)
                        tilt= CamArray(cam).tilt+ sign(d_tilt)*ptz_speed(2);
                        CamArray(cam).bus= 0;
                    end
                    %Test zoom speed
                    d_zoom= zoom- CamArray(cam).zoom;
                    if d_zoom > ptz_speed(3) || d_zoom < -1*ptz_speed(3)
                        zoom= CamArray(cam).zoom+ sign(d_zoom)*ptz_speed(3);
                        CamArray(cam).bus= 0;
                    end
                    CamArray(cam)= ptz_set_pan_tilt_zoom(CamArray(cam), pan, tilt, zoom);
                    
                    %Set viewpoint
                    camstring= CamArray(cam).camstring;
                    set(world_fig{1}, 'Viewpoint', camstring);
                    set(world_fig{2}, 'Viewpoint', camstring);
                    
                    %Take picture
                    set(world_fig{1}, 'NavPanel', 'none'); % hide the navigation panel
                    set(world_fig{2}, 'NavPanel', 'none'); % hide the navigation panel
                    vrdrawnow
                    framearray{1, cam}= capture(world_fig{1});
                    framearray{2, cam}= capture(world_fig{2});
                    
                    %Video recorder
                    videoframe = {framearray{1, cam}, cam};
                    videoarray{bus,Time} = videoframe;
                    
                end
            end
        else
            CamArray(cam).bus= 0;
        end
    end
    
    %Top camera
    camstring = 'Aerial View';
    set(world_fig{1}, 'Viewpoint', camstring);
    set(world_fig{1}, 'NavPanel', 'none');
    vrdrawnow
    topframe= {capture(world_fig{1}), 5};
    videoarray{5,Time} = topframe;
    
    %% Estimation of buses' position
    
    for cam=1:NumCam
        bus= CamArray(cam).bus;
        if bus > 0
            if BusArray(bus).inside == 1
                
                %Set viewpoint
                camstring= CamArray(cam).camstring;
                set(world_fig{1}, 'Viewpoint', camstring);
                set(world_fig{2}, 'Viewpoint', camstring);
                
                %xyt_bgs(:,bus)= xyt_real(:,bus);
                xyt_bgs(:,bus)= backgndsub(CamArray(cam), framearray(:, cam), xyt_pred{bus}(1:3,Time-t_ekf(bus)+1));
                
                fprintf('BGSub(bus %d): x= %.1fdm; y= %.1fdm; theta= %.1fdeg\n', bus, xyt_bgs(1, bus), xyt_bgs(2, bus), xyt_bgs(3, bus)*180/pi);
                
                vrml_world_set(2, 'bus', bus, [1e6 1e6 0]);
            else
                xyt_bgs(:,bus)=inf*ones(3,1); %don't update
                fprintf('BGSub(bus %d): Not observed, camera not there yet\n', bus);
            end
        end
    end

%         for cam=1:NumCam
%             bus= CamArray(cam).bus;
%             if bus > 0
%                 if BusArray(bus).inside == 1
%                     xyt_bgs= xyt_real;
%                     xyt_bgs(3,:)= xyt_bgs(3,:)+pi/2;
%                 else
%                     xyt_bgs(:,bus)=inf*ones(3,1); %don't update
%                     fprintf('BGSub(bus %d): Not observed, camera not there yet\n', bus);
%                 end
%             end
%         end

    %% EKF update
    for bus=1:NumBus
        if BusArray(bus).inside(1) == 1 && BusArray(bus).inside(2) == 1 && sum(xyt_bgs(:,bus) == inf) ~= 3
            %use EKF
            if find(trackBus == bus) > 0
                [xyt_upd{bus}(:,Time-t_ekf(bus)+1), P{bus,Time-t_ekf(bus)+1}]= ekf_bus(bus, xyt_bgs(:,bus), P{bus,Time-t_ekf(bus)+1}, 0);
            end
            xyt_act= xyt_upd{bus}(:,Time-t_ekf(bus)+1);
            fprintf('EKF upd(bus %d): x= %.1fdm; y= %.1fdm; theta= %.1fdeg\n', bus, xyt_act(1), xyt_act(2), xyt_act(3)*180/pi);
        end
    end
    
    %% EKF initialization
    for bus=1:NumBus
        if BusArray(bus).inside(1) == 1 && BusArray(bus).inside(2) == 0
            %initialise EKF
            BusArray(bus).inside(2)= 1;
            t_ekf(bus)= Time;
            xyt_ini= xyt_real(:,bus);
            xyt_ini(3)= xyt_ini(3)+pi/2;
            [xyt_upd{bus}(:,1), P{bus,1}]= ekf_bus(bus, xyt_ini, [], 1);
            subplot(2,2,bus)
            draw_bus(xyt_upd{bus}(1:3,Time-t_ekf(bus)+1), xyt_upd{bus}(5,Time-t_ekf(bus)+1), 1)
            xyt_act= xyt_upd{bus}(:,Time-t_ekf(bus)+1);
            fprintf('EKF ini(bus %d): x= %.1fdm; y= %.1fdm; theta= %.1fdeg\n', bus, xyt_act(1), xyt_act(2), xyt_act(3)*180/pi);
        end
    end

   axis equal

   PrevTime = Time;

   fprintf('\n');
   
   %if aborttst, break; end

end

vrml_world_end
cd(cd0);


% myavi_vrml(framearray,'truck_bckgndsub_mov')
save('videoframe.mat','videoarray')






return