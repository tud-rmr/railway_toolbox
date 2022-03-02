% Test heading calculation functions
%
%   Other m-files required: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 23-Nov-2020; Last revision: 23-Nov-2020

%% Generate Data

hs1_groundTruth = 0:1:2*360;
h2_groundTruth = mod(hs1_groundTruth,360);
delta_x = cosd(hs1_groundTruth);
delta_y = sind(hs1_groundTruth);
h3_groundTruth = atan2d(delta_y,delta_x);

%% Calculations

hs1_calculated = calcSmoothHeadingD(delta_y,delta_x);
hs2 = smoothenHeadingD(h2_groundTruth);
hs3 = smoothenHeadingD(h3_groundTruth);
h4 = simplifyHeadingD(hs1_groundTruth,'180');
h5 = simplifyHeadingD(hs1_groundTruth,'360');
h6 = simplifyHeadingD(h2_groundTruth,'180');
h7 = simplifyHeadingD(h2_groundTruth,'360');
h8 = simplifyHeadingD(h3_groundTruth,'180');
h9 = simplifyHeadingD(h3_groundTruth,'360');

%% Plot: Test calcSmoothHeadingD

if(1)
    figure_name = ['Test calcSmoothHeadingD'];
    close(findobj('Type','figure','Name',figure_name));
    h_fig = figure('Name',figure_name); hold on; grid on;

    clear h_plot    
    h_plot = gobjects(0);         

    h_plot(end+1) = plot(hs1_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h2_groundTruth,'k-','LineWidth',1.5,'DisplayName','Standard (360 mode)'); 
    h_plot(end+1) = plot(h3_groundTruth,'k-.','LineWidth',1.5,'DisplayName','Standard (180 mode)'); 
    h_plot(end+1) = plot(hs1_calculated,'b-','LineWidth',1.5,'DisplayName','Calculated');    

    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
end % if

%% Plot: Test smoothenHeadingD

if(1)
    figure_name = ['Test smoothenHeadingD'];
    close(findobj('Type','figure','Name',figure_name));
    h_fig = figure('Name',figure_name);

    clear h_plot    
    h_plot = gobjects(0);
    ax1 = subplot(2,1,1); hold on; grid on;

    h_plot(end+1) = plot(h2_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(hs2,'b-','LineWidth',1.5,'DisplayName','Calculated');   
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    clear h_plot    
    h_plot = gobjects(0);
    ax2 = subplot(2,1,2); hold on; grid on;
    h_plot(end+1) = plot(h3_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(hs3,'b-','LineWidth',1.5,'DisplayName','Calculated');  
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    linkaxes([ax1,ax2])
end % if

%% Plot: Test simplifyHeadingD

if(1)
    figure_name = ['Test simplifyHeadingD'];
    close(findobj('Type','figure','Name',figure_name));
    h_fig = figure('Name',figure_name);

    clear h_plot    
    h_plot = gobjects(0);
    ax1 = subplot(6,1,1); hold on; grid on;

    h_plot(end+1) = plot(hs1_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h4,'b-','LineWidth',1.5,'DisplayName','Calculated');   
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    clear h_plot    
    h_plot = gobjects(0);
    ax2 = subplot(6,1,2); hold on; grid on;
    h_plot(end+1) = plot(hs1_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h5,'b-','LineWidth',1.5,'DisplayName','Calculated');  
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    clear h_plot    
    h_plot = gobjects(0);
    ax3 = subplot(6,1,3); hold on; grid on;
    h_plot(end+1) = plot(h2_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h6,'b-','LineWidth',1.5,'DisplayName','Calculated');  
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    clear h_plot    
    h_plot = gobjects(0);
    ax4 = subplot(6,1,4); hold on; grid on;
    h_plot(end+1) = plot(h2_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h7,'b-','LineWidth',1.5,'DisplayName','Calculated');  
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    clear h_plot    
    h_plot = gobjects(0);
    ax5 = subplot(6,1,5); hold on; grid on;
    h_plot(end+1) = plot(h3_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h8,'b-','LineWidth',1.5,'DisplayName','Calculated');  
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    clear h_plot    
    h_plot = gobjects(0);
    ax6 = subplot(6,1,6); hold on; grid on;
    h_plot(end+1) = plot(h3_groundTruth,'r-','LineWidth',5,'DisplayName','Input');    
    h_plot(end+1) = plot(h9,'b-','LineWidth',1.5,'DisplayName','Calculated');  
    legend(h_plot);
    xlabel('k [Index]')
    ylabel('heading [deg]')
    
    linkaxes([ax1,ax2,ax3,ax4,ax5,ax6])
end % if
