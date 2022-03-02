function updated_railway_map = limitRailwayMap(z_start,z_end,railway_map)
% updated_railway_map = limitRailwayMap(z_start,z_end,railway_map)
% 

%% Settings

% options = optimoptions('lsqnonlin');
% options.Display = 'off';
% options.FiniteDifferenceStepSize = 1e-3;
% options.ScaleProblem = 'jacobian';    
% % options.FunctionTolerance = 1e-9;
% % options.StepTolerance = 1e-9;    
% % options.MaxFunctionEvaluations = 50; 
% % options.PlotFcn = 'myOptimPlotFcn'; % optimplotfval,optimplotstepsize,optimplotresnorm,myOptimPlotFcn
% options.Algorithm = 'levenberg-marquardt';

% opts = optimoptions(@fmincon,'Display','off');
% opts.FiniteDifferenceStepSize = 1e-3;

%% Initialization

updated_railway_map = railway_map;

% % Treat transition straights like normal straights
% transition_straights_selector = (updated_railway_map.track_maps.track_element == 11);
% updated_railway_map.track_maps.track_element(transition_straights_selector) = 1;

% Set some static numbers and codes
straight_code = 1;
arc_code = 3;

tm_id_idx = 1;
tm_element_idx = 2;
tm_r0_idx = 3;
tm_rend_idx = 4;
tm_length_idx = 5;
tm_vmax_idx = 6;

sp_id_idx = 1;
sp_x0_idx = 2;
sp_y0_idx = 3;
sp_phi0_idx = 4;

%% Calculations 

% Find optimal start and end point ________________________________________

if ~isempty(z_start)
    switch updated_railway_map.track_maps(1,:).track_element

        case {1}       

            fprintf('Looking for optimal start-point of railway-map...');
            
            track_id = updated_railway_map.track_maps(1,:).ID;
            track_map = tableTrackMap2matTrackMap(updated_railway_map.track_maps(1,:));
            track_start_point = tableTrackStartPoints2matTrackStartPoints(updated_railway_map.track_start_points(1,:));
            [~,~,~,~,l_straight_ppd] = calcErrorToStraightGeometry(z_start,0,[track_id 1],track_map,track_start_point);
            
            L_start_opt = l_straight_ppd{1}(1);
            L_start_opt = min(L_start_opt,updated_railway_map.track_maps(1,:).length-0.01); % ensure not to switch to next track
            
            fprintf('done!\n');
            
        case {3}
            
            fprintf('Looking for optimal start-point of railway-map...');
                        
            p_0 = [updated_railway_map.track_start_points(1,:).x_0;updated_railway_map.track_start_points(1,:).y_0];
            phi_0 = updated_railway_map.track_start_points(1,:).phi_0;
            radius = updated_railway_map.track_maps(1,:).r_start * -1; % convert from railway convention to mathematical convention
            if radius >= 0        
                p_center = p_0 + abs(radius)*[-sind(phi_0);cosd(phi_0)]; 
            else
                p_center = p_0 + abs(radius)*[sind(phi_0);-cosd(phi_0)];              
            end % if
            p_0_new = p_center + abs(radius)*(z_start-p_center)/norm((z_start-p_center));
            a_temp = p_0_new-p_0;
            delta_phi = 2*sin( (norm(a_temp)/2)/abs(radius) );
            delta_L = delta_phi*abs(radius);
            
            [~,~,~,p_test_1,~,~,~,~,~,~] = calcTrackRouteProperties(delta_L,updated_railway_map.track_maps(1,:).ID,updated_railway_map.track_maps(1,:).ID,0,updated_railway_map);
            [~,~,~,p_test_2,~,~,~,~,~,~] = calcTrackRouteProperties(-delta_L,updated_railway_map.track_maps(1,:).ID,updated_railway_map.track_maps(1,:).ID,0,updated_railway_map);
            
            if norm(p_test_1-p_0_new) < norm(p_test_2-p_0_new)
                L_start_opt = delta_L;
            else
                L_start_opt = -delta_L;
            end % if
            
            
            % l_test = 0:1:updated_railway_map.track_maps(1,:).length;
            % [~,~,~,abs_map_start_point,~,~,~,~,~,~] = calcTrackRouteProperties(l_test,updated_railway_map.track_maps(1,:).ID,updated_railway_map.track_maps(1,:).ID,0,updated_railway_map);
            % plot(p_center(1,:),p_center(2,:),'go'); hold on
            % plot(abs_map_start_point(1,:),abs_map_start_point(2,:),'b-');
            % plot(z_start(1,:),z_start(2,:),'bx');
            % plot(p_0(1,:),p_0(2,:),'k.','MarkerSize',10); 
            % plot(p_0_new(1,:),p_0_new(2,:),'r.','MarkerSize',10);
            % plot(p_test_1(1,:),p_test_1(2,:),'y.','MarkerSize',10); 
            % plot(p_test_2(1,:),p_test_2(2,:),'m.','MarkerSize',10); 
            % axis equal

            fprintf('done!\n');

%         case {2,4,5}
%             
%             x_start_0 = 0;
%             obj_fcn_wrapper_start_point = @(x) objectiveFunction_startPoint(x,z_start,updated_railway_map);
% 
%             lower_bounds = -inf;
%             upper_bounds = updated_railway_map.track_maps(1,:).length-0.01;
% 
% %             L_start_opt = lsqnonlin(obj_fcn_wrapper_start_point,x_start_0,[],[],options);
%             L_start_opt = fmincon(obj_fcn_wrapper_start_point,x_start_0,[],[],[],[],lower_bounds,upper_bounds,[],opts);
        
        otherwise

            % Do nothing
            fprintf('No optimal start-point calculated! Map starts with transitional arc!\n');
            return  

    end % switch
    
    % Set new optimal start point _____________________________________________
    new_length = (updated_railway_map.track_maps(1,:).length - L_start_opt);
    if new_length < 0
        % error('limitRailwayMap: Optimal start-point beyond first track-element!');
        warning('limitRailwayMap: Start-point not changed, because it is beyond first track-element!');
    else
        updated_railway_map.track_maps(1,:).length = new_length;

        [~,~,~,abs_map_start_point,t,~,~,~,~,~] = calcTrackRouteProperties(L_start_opt,updated_railway_map.track_maps(1,:).ID,updated_railway_map.track_maps(1,:).ID,0,updated_railway_map);
        updated_railway_map.track_start_points(1,:).x_0 = abs_map_start_point(1,1);
        updated_railway_map.track_start_points(1,:).y_0 = abs_map_start_point(2,1);
        updated_railway_map.track_start_points(1,:).phi_0 = atan2d(t(2,1),t(1,1));
    end % if
end % if

if ~isempty(z_end)
    switch updated_railway_map.track_maps(end,:).track_element

        case {1}
            
            fprintf('Looking for optimal end-point of railway-map...');
            
            track_ids = updated_railway_map.track_maps(end,:).ID;
            
            % Look for preceeding straights            
            if size(updated_railway_map.track_maps,1) > 1
                i = 1;
                num_tracks = size(updated_railway_map.track_maps,1);
                while (updated_railway_map.track_maps(max(num_tracks-i,1),:).track_element == 1) && num_tracks > i
                    track_ids = [track_ids;updated_railway_map.track_maps(max(num_tracks-i,1),:).ID];
                    i = i+1;
                end % while
            end % if
            track_ids = sort(track_ids,'asc');
            
            % Prepare data
            track_maps_selector = ismember(updated_railway_map.track_maps.ID,track_ids); 
            track_maps = tableTrackMap2matTrackMap(updated_railway_map.track_maps(track_maps_selector,:));
            track_start_points_selector = ismember(updated_railway_map.track_start_points.ID,track_ids); 
            track_start_points = tableTrackStartPoints2matTrackStartPoints(updated_railway_map.track_start_points(track_start_points_selector,:));
            z_selector = [track_ids, ones(size(track_ids,1),1)];
            
            % Calc error to last measurement
            [~,~,~,~,l_straight_ppd] = calcErrorToStraightGeometry(z_end,0,z_selector,track_maps,track_start_points);
            
            % Find new end length and determine last track-element
            end_length_i = updated_railway_map.track_maps(track_maps_selector,:).length;
            track_length_i = cellfun(@(cell) cell(1),l_straight_ppd);
            
            [~,temp_idx] = min(abs(end_length_i-track_length_i));
            L_end_opt = track_length_i(temp_idx);
            last_track_id = track_ids(temp_idx);
            excess_track_selector = ismember(updated_railway_map.track_maps.ID,track_ids(temp_idx+1:end));
                        
            fprintf('done!\n');
            
        case {3}
            
            fprintf('Looking for optimal end-point of railway-map...');
            
            l_end = updated_railway_map.track_maps(end,:).length;
            [~,~,~,p_end,t_end,~,~,~,~,~] = calcTrackRouteProperties(l_end,updated_railway_map.track_maps(end,:).ID,updated_railway_map.track_maps(end,:).ID,0,updated_railway_map);
            phi_end = atan2d(t_end(2,1),t_end(1,1));
            radius = updated_railway_map.track_maps(end,:).r_end * -1; % convert from railway convention to mathematical convention
            if radius >= 0        
                p_center = p_end + abs(radius)*[-sind(phi_end);cosd(phi_end)]; 
            else
                p_center = p_end + abs(radius)*[sind(phi_end);-cosd(phi_end)];              
            end % if
            p_end_new = p_center + abs(radius)*(z_end-p_center)/norm((z_end-p_center));
            a_temp = p_end_new-p_end;
            delta_phi = 2*sin( (norm(a_temp)/2)/abs(radius) );
            delta_L = delta_phi*abs(radius);
            
            [~,~,~,p_test_1,~,~,~,~,~,~] = calcTrackRouteProperties(l_end+delta_L,updated_railway_map.track_maps(end,:).ID,updated_railway_map.track_maps(end,:).ID,0,updated_railway_map);
            [~,~,~,p_test_2,~,~,~,~,~,~] = calcTrackRouteProperties(l_end-delta_L,updated_railway_map.track_maps(end,:).ID,updated_railway_map.track_maps(end,:).ID,0,updated_railway_map);
            
            if norm(p_test_1-p_end_new) < norm(p_test_2-p_end_new)
                L_end_opt = l_end+delta_L;
            else
                L_end_opt = l_end-delta_L;
            end % if            
            
            % l_test = 0:1:updated_railway_map.track_maps(end,:).length;
            % [~,~,~,abs_map_start_point,~,~,~,~,~,~] = calcTrackRouteProperties(l_test,updated_railway_map.track_maps(end,:).ID,updated_railway_map.track_maps(end,:).ID,0,updated_railway_map);
            % plot(p_center(1,:),p_center(2,:),'go'); hold on
            % plot(abs_map_start_point(1,:),abs_map_start_point(2,:),'b-');
            % plot(z_end(1,:),z_end(2,:),'bx');
            % plot(p_end(1,:),p_end(2,:),'k.','MarkerSize',10); 
            % plot(p_end_new(1,:),p_end_new(2,:),'r.','MarkerSize',10);
            % plot(p_test_1(1,:),p_test_1(2,:),'y.','MarkerSize',10); 
            % plot(p_test_2(1,:),p_test_2(2,:),'m.','MarkerSize',10); 
            % axis equal   
           
            excess_track_selector = [];
            
            fprintf('done!\n');

%         case {2,4,5}
%                         
%             x_end_0 = updated_railway_map.track_maps(end,:).length;
%             obj_fcn_wrapper_end_point = @(x) objectiveFunction_endPoint(x,z_end,updated_railway_map);   
% 
%             lower_bounds = 0.01;
%             upper_bounds = inf;
% 
% %             L_end_opt = lsqnonlin(obj_fcn_wrapper_end_point,x_end_0,[],[],options);
%             L_end_opt = fmincon(obj_fcn_wrapper_end_point,x_end_0,[],[],[],[],lower_bounds,upper_bounds,[],opts);
        
        otherwise

            % Do nothing
            fprintf('No optimal end-point calculated! Map ends with transitional arc!\n');
            return  

    end % switch

    % Set new optimal end point ___________________________________________

    if L_end_opt > 0
        updated_railway_map.track_maps(end,:).length = L_end_opt;
        
        % Handling of excess tracks
        if ~isempty(excess_track_selector) && any(excess_track_selector)
                % Set length to zero
                num_excess_tracks = sum(excess_track_selector);
                updated_railway_map.track_maps(excess_track_selector,:).length = zeros(num_excess_tracks,1);
                
                % Reset track start-points for excess tracks
                last_start_point_selector = (updated_railway_map.track_start_points{:,sp_id_idx}==last_track_id);
                last_start_point = updated_railway_map.track_start_points(last_start_point_selector,:);
                last_track_p_0 = [last_start_point.x_0;last_start_point.y_0];
                last_track_phi_0 = last_start_point.phi_0;                        
                for i = find(excess_track_selector(:)')
                    last_track_p_end = straightLineTrackElement(L_end_opt,last_track_phi_0,last_track_p_0);
                    updated_railway_map.track_start_points(i,:).x_0 = last_track_p_end(1);
                    updated_railway_map.track_start_points(i,:).y_0 = last_track_p_end(2);
                end % for i
        end % if        
    else
        warning('limitRailwayMap: End-point not changed, because it is before last track-element!');
        %error('limitRailwayMap: Optimal end-point before last track-element!');
    end % if
end % if

% % Reset original track elements 
% updated_railway_map.track_maps.track_element(transition_straights_selector) = 11;

end

function J = objectiveFunction_startPoint(L,z,railway_map)
    [~,~,~,abs_map_pos,~,~,~,~,~,~] = calcTrackRouteProperties(L,railway_map.track_maps(1,:).ID,railway_map.track_maps(1,:).ID,0,railway_map,1);
    
    J = norm(z-abs_map_pos);
end % function

function J = objectiveFunction_endPoint(L,z,railway_map)   
    [~,~,~,abs_map_pos,~,~,~,~,~,~] = calcTrackRouteProperties(L,railway_map.track_maps(end,:).ID,railway_map.track_maps(end,:).ID,0,railway_map,1);
    
    J = norm(z-abs_map_pos);
end % function

