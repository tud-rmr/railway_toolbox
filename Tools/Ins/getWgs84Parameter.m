function [f,e,Rn,Re,w_ie_i] = getWgs84Parameter(p_llh)
% [f,e,Rn,Re] = getWgs84Parameter(p_llh)
% 
%   Get WGS84 Parameters
%
%   In:
%       p_llh   postion vector in latitude, longitude and height [rad,rad,m]
%
%   Out:
%       f       flattening of the ellipsoid
%       e       major eccentrictiy of the ellipsoid
%       Rn      meridian radius of curvature (north-south) in m
%       Re      transverse radius of curvature (west-east) in m
%       w_ie    earth turn-rate in rad/s
% 
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: 
%       - D. Titterton and J. Westen, "Strapdown Inertial Navigation Technology", p. 52, IET, 2004
%       - J. Wendel, "Integrierte Navigationssysteme", p. 31, 2007

%   Author: Hanno Winter
%   Date: 11-May-2020; Last revision: 11-May-2020

%% Init

a = 6378137; % major axis of the ellipsoid in m
b = 6356752.3142; % semi-major axis of the ellipsoid in m
w_ie_i = 7.292115e-5; % earth turn rate in rad/s

%% Calculations

L = p_llh(1);

f = (a-b)/a;
e = sqrt(f*(2-f));
Rn = a*(1-e^2)/((1-e^2*sin(L)^2)^(3/2));
Re = a/((1-e^2*sin(L)^2)^(1/2));

end % function

