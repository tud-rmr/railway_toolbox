
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
speed_limit = simout_ref_data.Data(:,17)';

%% Track Positions

if(1)
    % Calculations ________________________________________________________   
    
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
        h_plot(end+1) = plot(abs_position(1,1),abs_position(2,1),'>','LineWidth',3,'MarkerSize',10,'MarkerFaceColor','r','DisplayName','Train startpoint');
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

%% Track Geometry

if(1)
    % Calculations ________________________________________________________
        
    % Figure ______________________________________________________________
    figure_name = 'Track Properties';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name,'units','normalized','outerposition',[0 0 1 1]); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);    
    ax1 = subplot(4,1,1); hold on; grid on; 
    h_plot(end+1) = plot(d_train,atan2d(orientation(2,:),orientation(1,:)),'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('track orientation [deg]')

    clear h_plot
    h_plot = gobjects(0);    
    ax2 = subplot(4,1,2); hold on; grid on; 
    h_plot(end+1) = plot(d_train,curvature,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('curvature [1/m]')

    clear h_plot
    h_plot = gobjects(0);    
    ax3 = subplot(4,1,3); hold on; grid on; 
    h_plot(end+1) = plot(d_train,radius,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('radius [m]')

    clear h_plot
    h_plot = gobjects(0);    
    ax4 = subplot(4,1,4); hold on; grid on; 
    h_plot(end+1) = plot(d_train,speed_limit*3.6,'k.-','LineWidth',1.5,'MarkerSize',10);
    xlabel('d_{train} [m]')
    ylabel('speed limit [km/h]')

    % h_legend = legend(h_plot(:));
    % set(h_legend,'Location','southeast')
    linkaxes([ax1,ax2,ax3,ax4],'x');
end % if

%% Motion

if(1)
    % Calculations ________________________________________________________
        
    % Figure ______________________________________________________________
    figure_name = 'Motion';
    close(findobj('Type','figure','Name',figure_name));
    figure('Name',figure_name,'units','normalized','outerposition',[0 0 1 1]); hold on; grid on;

    clear h_plot
    h_plot = gobjects(0);
    h_kf_err_plot = gobjects(0);
    ax1 = subplot(5,1,1); hold on; grid on; 
    h_plot(end+1) = plot(time,d_train*1e-3,'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');
    xlabel('time [s]')
    ylabel('d_{train} [km]')
    h_legend = legend(h_plot(:));
    set(h_legend,'Location','southeast')

    clear h_plot
    h_plot = gobjects(0);    
    ax2 = subplot(5,1,2); hold on; grid on; 
    h_plot(end+1) = plot(time,speed_limit*3.6,'b-','LineWidth',0.5,'MarkerSize',10,'DisplayName','speed limit');
    h_plot(end+1) = plot(time,v_train*3.6,'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');
    xlabel('time [s]')
    ylabel('v_{train} [km/h]')
    h_legend = legend(h_plot(:));
    set(h_legend,'Location','southeast')

    clear h_plot
    h_plot = gobjects(0);    
    ax3 = subplot(5,1,3); hold on; grid on; 
    h_plot(end+1) = plot([time(1) time(end)],[max_train_acc(2) max_train_acc(2)],'b-','LineWidth',0.5,'MarkerSize',10,'DisplayName','a+ limit');
    h_plot(end+1) = plot([time(1) time(end)],[max_train_acc(1) max_train_acc(1)],'b-','LineWidth',0.5,'MarkerSize',10,'DisplayName','a- limit');
    h_plot(end+1) = plot(time,a_train(1,:),'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');
    xlabel('time [s]')
    ylabel('a_{train} [m/s^2]')
    h_legend = legend(h_plot(:));
    set(h_legend,'Location','southeast')
    
    clear h_plot
    h_plot = gobjects(0);    
    ax4 = subplot(5,1,4); hold on; grid on; 
    h_plot(end+1) = plot(time,atan2d(orientation(2,:),orientation(1,:)),'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');
    xlabel('time [s]')
    ylabel('\theta [deg]')
    h_legend = legend(h_plot(:));
    set(h_legend,'Location','southeast')
    
    clear h_plot
    h_plot = gobjects(0);    
    ax5 = subplot(5,1,5); hold on; grid on; 
    h_plot(end+1) = plot(time,w_train(3,:),'r-','LineWidth',1.5,'MarkerSize',10,'DisplayName','reference');    
    xlabel('time [s]')
    ylabel('\omega [rad/s]')
    h_legend = legend(h_plot(:));
    set(h_legend,'Location','southeast')

    linkaxes([ax1,ax2,ax3,ax4,ax5],'x');
end % if
