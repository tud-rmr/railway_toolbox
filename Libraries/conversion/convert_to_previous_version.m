load_system('libMdl_TrainFrontDataGenerator')
load_system('test_libMdl_TrainFrontDataGenerator')
load_system('libMdl_TrainEndDataGenerator')
load_system('test_libMdl_TrainEndDataGenerator')
load_system('libMdl_KalmanFilter')
load_system('test_libMdl_KalmanFilter')
load_system('libMdl_Gnss')
load_system('test_libMdl_Gnss')
load_system('libMdl_Imu')
load_system('test_libMdl_Imu')
load_system('test_libMdl_RailwayToolbox');
load_system('libMdl_RailwayToolbox');


convert_to_version = 'R2014a';


Simulink.exportToVersion('libMdl_TrainFrontDataGenerator',['libMdl_TrainFrontDataGenerator','_',convert_to_version,'.slx'],convert_to_version);
Simulink.exportToVersion('test_libMdl_TrainFrontDataGenerator',['test_libMdl_TrainFrontDataGenerator','_',convert_to_version,'.slx'],convert_to_version);

Simulink.exportToVersion('libMdl_TrainEndDataGenerator',['libMdl_TrainEndDataGenerator','_',convert_to_version,'.slx'],convert_to_version);
Simulink.exportToVersion('test_libMdl_TrainEndDataGenerator',['test_libMdl_TrainEndDataGenerator','_',convert_to_version,'.slx'],convert_to_version);

Simulink.exportToVersion('libMdl_KalmanFilter',['libMdl_KalmanFilter','_',convert_to_version,'.slx'],convert_to_version);
Simulink.exportToVersion('test_libMdl_KalmanFilter',['test_libMdl_KalmanFilter','_',convert_to_version,'.slx'],convert_to_version);

Simulink.exportToVersion('libMdl_Gnss',['libMdl_Gnss','_',convert_to_version,'.slx'],convert_to_version);
Simulink.exportToVersion('test_libMdl_Gnss',['test_libMdl_Gnss','_',convert_to_version,'.slx'],convert_to_version);

Simulink.exportToVersion('libMdl_Imu',['libMdl_Imu','_',convert_to_version,'.slx'],convert_to_version);
Simulink.exportToVersion('test_libMdl_Imu',['test_libMdl_Imu','_',convert_to_version,'.slx'],convert_to_version);

Simulink.exportToVersion('test_libMdl_RailwayToolbox',['test_libMdl_RailwayToolbox','_',convert_to_version,'.slx'],convert_to_version);

Simulink.exportToVersion('libMdl_RailwayToolbox',['libMdl_RailwayToolbox','_',convert_to_version,'.slx'],convert_to_version);


close_system('libMdl_TrainFrontDataGenerator')
close_system('test_libMdl_TrainFrontDataGenerator')
close_system('libMdl_TrainEndDataGenerator')
close_system('test_libMdl_TrainEndDataGenerator')
close_system('libMdl_KalmanFilter')
close_system('libMdl_Gnss')
close_system('test_libMdl_Gnss')
close_system('libMdl_Imu')
close_system('test_libMdl_Imu')
close_system('test_libMdl_RailwayToolbox');
close_system('libMdl_RailwayToolbox');
