
%% Track Positions

if(1)
    % Calculations ________________________________________________________   
    time = simout_ref_data.Time;
    track_ids = simout_ref_data.Data(:,1)';
    rel_position = simout_ref_data.Data(:,2)';
    abs_position = simout_ref_data.Data(:,[3,4])';
    d_train = simout_ref_data.Data(:,5)';
    v_train = simout_ref_data.Data(:,6)';
    a_train = simout_ref_data.Data(:,[7 8 9])';
    w_train = simout_ref_data.Data(:,[10 11 12])';
    orientation = simout_ref_data.Data(:,[13 14])';
    curvature = simout_ref_data.Data(:,15)';
    radius = simout_ref_data.Data(:,16)';
    
    % Track (absolute position) ___________________________________________
    if(1)        
        % Figure    
        figure_name = 'Track (absolute)';
        close(findobj('Type','figure','Name',figure_name));
        figure('Name',figure_name,'units','normalized','outerposition',[0 0 1 1]); hold on; grid on;

        clear h_plot
        h_plot = gobjects(0);
        h_kf_err_plot = gobjects(0);
        for i = unique(track_ids)
            h_plot(end+1) = plot(abs_position(1,track_ids==i),abs_position(2,track_ids==i),'-','LineWidth',1.5,'MarkerSize',20,'DisplayName',sprintf('reference (track: %i)',i));
        end % for i    
        h_plot(end+1) = plot(abs_position(1,1),abs_position(2,1),'s','LineWidth',3,'MarkerSize',10,'MarkerFaceColor','r','DisplayName','Train (end) startpoint');
        xlabel('x [m]')
        ylabel('y [m]')

        h_legend = legend([h_plot(:)]);
        set(h_legend,'Location','Best');
        axis equal
    end % if

    % Track (relative position) ___________________________________________
    if(1)
        figure_name = 'Track (relative)';
        close(findobj('Type','figure','Name',figure_name));
        figure('Name',figure_name,'units','normalized','outerposition',[0 0 1 1]); hold on; grid on;

        clear h_plot
        h_plot = gobjects(0);
        h_kf_err_plot = gobjects(0);
        for i = unique(track_ids)
            if any(track_ids==i)
                h_plot(end+1) = plot(d_train(track_ids==i),rel_position(track_ids==i),'.-','LineWidth',1.5,'MarkerSize',10,'DisplayName',sprintf('reference (track: %i)',i));
            else
                continue;
            end
        end % for i    
        xlabel('d_{train} [m]')
        ylabel('relative position to trackmap [m]')

        %ylim([min(abs_position(2,:)) max(abs_position(2,:))])
        h_legend = legend([h_plot(:)]);
        set(h_legend,'Location','Best');
    end % if
end % if
