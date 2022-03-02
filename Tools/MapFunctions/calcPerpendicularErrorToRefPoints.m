function [d_perpendicular,p_ref_pp,p_ref_pp_indices] = calcPerpendicularErrorToRefPoints(p_ref,p_test)
% [d_perpendicular,p_ref_pp,p_ref_pp_indices] = calcPerpendicularErrorToRefPoints(p_ref,p_test)
% 
%   Calculate perpendicular distance/error to reference_points
%
%   In:
%       p_ref   reference points (2 x n)-array
%       p_test  test points (2 x n)-array
% 
%   Out:
%       d_perpendicular     perpendicular from reference-point track to test-point track
%       p_ref_pp            perpendicular points on reference track with reference to the test-points
%       p_ref_pp_indices    indices relating the test-points to perpendicular points to 'p_ref_pp'
%
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 25-April-2021; Last revision: 26-April-2021
%

%% Settings

% Search field
d_x = 1000; % in m
d_y = 1000; % in m

%% Init

% warning('calcDistanceToPointTrack: This function has some limitation! Check the results carefully!');

% Remove none unique reference points
p_ref_diff = diff(p_ref,1,2);
p_ref_diff_norm = sqrt(sum(p_ref_diff.^2,1));
zero_norm_selector = (p_ref_diff_norm==0);
p_ref = p_ref(:,~zero_norm_selector);

%% Calculations

d_perpendicular = NaN(1,size(p_test,2));
p_ref_pp = NaN(2,size(p_test,2));
p_ref_pp_indices = false(1,size(p_test,2));
for i = 1:size(p_test,2)
    p_test_i = p_test(:,i);
    
    if any(isnan(p_test_i))
        continue
    end % if
    
    % Pre-select points near test-point  
    x_ref_data_selector = (p_ref(1,:) > p_test_i(1)-d_x) & (p_ref(1,:) < p_test_i(1)+d_x);
    y_ref_data_selector = (p_ref(2,:) > p_test_i(2)-d_y) & (p_ref(2,:) < p_test_i(2)+d_y);
    ref_data_selector = x_ref_data_selector & y_ref_data_selector;
    ref_data_indices = find(ref_data_selector);
    
    if length(ref_data_indices) < 2
        warning('calcDistanceToPointTrack: No data point found near test-point!');
        continue
    end % if
    
    % Find and select nearest points ______________________________________
   
    % Find
    deltas = sqrt(sum((p_ref(:,ref_data_selector)-p_test_i).^2,1));
    [~,min_delta_idx] = min(deltas);
    
    if i == 24
        test = 1;
    end % if
    
    double_perpendicular_dist = NaN(sum(ref_data_selector),1);
    %for j = 1:sum(ref_data_selector)
    for j = [max(min_delta_idx-1,1),min_delta_idx,min(min_delta_idx+1,size(ref_data_indices,2))]
	%for j = [max(min_delta_idx-2,1):1:min(min_delta_idx+2,size(ref_data_indices,2))]
        ref_data_index_j = ref_data_indices(j);
        
        p_ref_j = p_ref(:,ref_data_index_j);
        
        if (ref_data_index_j == 1) ||(ref_data_index_j >= size(p_ref,2))
            continue
        end % if        
        t_ref_j = p_ref(:,ref_data_index_j+1) - p_ref(:,ref_data_index_j);
        
%         if ref_data_index_j < size(p_ref,2)
%             t_ref_j = p_ref(:,ref_data_index_j+1) - p_ref(:,ref_data_index_j);
%         else
%             t_ref_j = p_ref(:,ref_data_index_j) - p_ref(:,ref_data_index_j-1);
%         end % if       
        
        double_perpendicular_dist(j) = dot(p_test_i-p_ref_j,t_ref_j)/norm(t_ref_j);
    end % j 
    
%     plot(p_ref(1,ref_data_index_j-2:ref_data_index_j),p_ref(2,ref_data_index_j-2:ref_data_index_j),'r.-'); hold on
%     plot(p_test_i(1,:),p_test_i(2,:),'kx')
       
    neg_double_perpendicular_dist_indices = find(double_perpendicular_dist<=0);
    pos_double_perpendicular_dist_indices = find(double_perpendicular_dist>0);
    
    if isempty(neg_double_perpendicular_dist_indices) || isempty(pos_double_perpendicular_dist_indices)
        continue
    end 
    
    % Select 
    [min_pos,min_pos_index_tmp] = min(double_perpendicular_dist(double_perpendicular_dist>0));
    min_pos_index = pos_double_perpendicular_dist_indices(min_pos_index_tmp);
    [max_neg,max_neg_index_tmp] = max(double_perpendicular_dist(double_perpendicular_dist<=0));
    max_neg_index = neg_double_perpendicular_dist_indices(max_neg_index_tmp);
    
    nearest_ref_points_indices = ref_data_indices([max_neg_index,min_pos_index]);
%     [~,idx_order] = sort([abs(max_neg),abs(min_pos)],'asc');
%     nearest_ref_points_indices = nearest_ref_points_indices(idx_order);     
    
    % Get perpendicular distance between ref-map and test-points __________
    
    p_ref_i = p_ref(:,nearest_ref_points_indices(1));
    t_ref_i = p_ref(:,nearest_ref_points_indices(2)) - p_ref(:,nearest_ref_points_indices(1));
    
    % Formula: See Binomi Formelsammlung
    lambda = dot((p_test_i-p_ref_i),t_ref_i) / sum(t_ref_i.^2); 
    p_ref_pp(:,i) = p_ref_i+lambda*t_ref_i;
    t_side = cross([t_ref_i;0],[p_test_i-p_ref_i;0]);
    d_perpendicular(i) = sign(t_side(3))*norm(p_test_i-p_ref_pp(:,i)); 
    p_ref_pp_indices(i) = true;
end % for i

%% Output

d_perpendicular = d_perpendicular(~isnan(d_perpendicular));
p_ref_pp = p_ref_pp(:,~isnan(p_ref_pp(1,:)));
p_ref_pp_indices = find(p_ref_pp_indices);

%% Plot to check result

if 0
    figure_name = 'Evaluate Result of ''calcPerpendicularErrorToRefMap''';
    % close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);
    h_d_pp = gobjects(0);
    h_plot(end+1) = plot(p_test(1,:),p_test(2,:),'b.-','LineWidth',1.5,'MarkerSize',10,'DisplayName','Test-Points');

    p_test_temp = p_test(:,p_ref_pp_indices);
    for i = 1:length(p_test_temp)
        h_d_pp(end+1) = plot([p_test_temp(1,i),p_ref_pp(1,i)],[p_test_temp(2,i),p_ref_pp(2,i)],'k.-','LineWidth',1.5,'MarkerSize',10);
    end % for i
    h_plot(end+1) = plot(p_ref(1,:),p_ref(2,:),'r.-','LineWidth',1,'MarkerSize',10,'DisplayName','Ref-Data');
    xlabel('x [m]')
    ylabel('y [m]')

    h_legend = legend(h_plot);
    set(h_legend,'Location','northeast');
    axis equal
end % if

end

