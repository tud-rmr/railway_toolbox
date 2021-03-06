clear all
close all
clc

load gnss_processed_test_data
load imu_processed_test_data

%%

gnss_time = seconds(gnss_processed_data.Time) - ... 
            seconds(gnss_processed_data.Time(1));
imu_time = seconds(imu_processed_data.Time) - ... 
           seconds(gnss_processed_data.Time(1));

gnss_data = gnss_processed_data{:,{'Latitude_deg','Longitude_deg'}};
gnss_data = timeseries(fillmissing(gnss_data,'previous'),gnss_time);
gnss_valid_data = timeseries( ... 
                              ~isnan(gnss_processed_data.Latitude_deg) & ...
                              ~isnan(gnss_processed_data.Longitude_deg), ...
                              gnss_time ...
                            );

imu_data = imu_processed_data{:,{'AccX_mss','AccY_mss','AccZ_mss'}};
imu_data = timeseries(fillmissing(imu_data,'previous'),imu_time);
imu_valid_data = timeseries( ... 
                             ones(size(imu_time)), ... 
                             imu_time ...
                           );
