%% Calculations for plots

% check if calculations have already been done (dirty implementation)
if ~exist('time','var')
    % Data synchronisation ________________________________________________
    [simout_ref_data,simout_sensor_data] = synchronize(simout_ref_data,simout_sensor_data,'intersection');
    [simout_ref_data,simout_kf_x] = synchronize(simout_ref_data,simout_kf_x,'intersection');
    [simout_ref_data,simout_kf_P] = synchronize(simout_ref_data,simout_kf_P,'intersection');
    time = simout_ref_data.Time;

    % Data mapping ________________________________________________________

    % Reference data
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

    % Sensor data
    gnss_position = simout_sensor_data.Data(:,[1 2])';
    imu_a_x = simout_sensor_data.Data(:,3)';
    imu_w_yaw = simout_sensor_data.Data(:,4)';

    % Filter data
    kf_position = simout_kf_x.Data(:,[1 2])';
    kf_d_train = simout_kf_x.Data(:,3)';
    kf_v_train = simout_kf_x.Data(:,4)';
    kf_a_train = simout_kf_x.Data(:,5)';
    kf_theta_train = simout_kf_x.Data(:,6)';
    kf_w_train = simout_kf_x.Data(:,7)';

    kf_position_cov = simout_kf_P.Data(1:2,1:2,:);
    kf_d_train_cov = simout_kf_P.Data(3,3,:);
    kf_v_train_cov = simout_kf_P.Data(4,4,:);
    kf_a_train_cov = simout_kf_P.Data(5,5,:);
    kf_theta_train_cov = simout_kf_P.Data(6,6,:);
    kf_w_train_cov = simout_kf_P.Data(7,7,:);

    % KF estimation errors ________________________________________________
    conf_interval = 0.99; 
    err_ellipse_resolution = 61;    

    % position error
    kf_position_err = zeros(2,err_ellipse_resolution,length(time));
    for i = 1:length(time)
        [~,kf_position_err(:,:,i)] = getErrorEllipse(kf_position_cov(:,:,i),conf_interval,err_ellipse_resolution);
    end % for i

    % traveled distance error
    kf_d_train_err = zeros(1,length(time));
    for i = 1:length(time)
        kf_d_train_err(i) = getErrorEllipse(kf_d_train_cov(:,:,i),conf_interval,[]);
    end % for i

    % speed error
    kf_v_train_err = zeros(1,length(time));
    for i = 1:length(time)
        kf_v_train_err(i) = getErrorEllipse(kf_v_train_cov(:,:,i),conf_interval,[]);
    end % for i

    % acceleration error
    kf_a_train_err = zeros(1,length(time));
    for i = 1:length(time)
        kf_a_train_err(i) = getErrorEllipse(kf_a_train_cov(:,:,i),conf_interval,[]);
    end % for i

    % acceleration error
    kf_theta_train_err = zeros(1,length(time));
    for i = 1:length(time)
        kf_theta_train_err(i) = getErrorEllipse(kf_theta_train_cov(:,:,i),conf_interval,[]);
    end % for i

    % acceleration error
    kf_w_train_err = zeros(1,length(time));
    for i = 1:length(time)
        kf_w_train_err(i) = getErrorEllipse(kf_w_train_cov(:,:,i),conf_interval,[]);
    end % for i
end % if