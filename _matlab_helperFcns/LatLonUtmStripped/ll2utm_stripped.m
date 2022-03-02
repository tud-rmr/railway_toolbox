function [x,y,f]=ll2utm_stripped(lat,lon,zone)
% Stripped version of Francois Beauducel 'll2utm' function
%
% Reference:  
%   François Beauducel (2021). LL2UTM and UTM2LL 
%   (https://www.mathworks.com/matlabcentral/fileexchange/45699-ll2utm-and-utm2ll), 
%   MATLAB Central File Exchange. Retrieved March 26, 2021.  
% 

if nargin < 3
    zone = [];
end % if

% constants
D0 = 180/pi;	% conversion rad to deg
K0 = 0.9996;	% UTM scale factor
X0 = 500000;	% UTM false East (m)

A1 = 6378137.0;
F1 = 298.257223563;

% defaults
datum = 'wgs84';
x = 0;
y = 0;
f = 0;

if all([numel(lat),numel(lon)] > 1) && any(size(lat) ~= size(lon))
	error('LAT and LON must be the same size or scalars.')
end

p1 = lat/D0; % Phi = Latitude (rad)
l1 = lon/D0; % Lambda = Longitude (rad)

% UTM zone automatic setting
if isempty(zone)
	F0 = round((l1*D0 + 183)/6);
else
	F0 = zone;
end

B1 = A1*(1 - 1/F1);
E1 = sqrt((A1*A1 - B1*B1)/(A1*A1));
P0 = 0/D0;
L0 = (6*F0 - 183)/D0;	% UTM origin longitude (rad)
Y0 = 1e7*(p1 < 0);		% UTM false northern (m)
N = K0*A1;

C = coef(E1,0);
B = C(1)*P0 + C(2)*sin(2*P0) + C(3)*sin(4*P0) + C(4)*sin(6*P0) + C(5)*sin(8*P0);
YS = Y0 - N*B;

C = coef(E1,2);
L = log(tan(pi/4 + p1/2).*(((1 - E1*sin(p1))./(1 + E1*sin(p1))).^(E1/2)));
z = complex(atan(sinh(L)./cos(l1 - L0)),log(tan(pi/4 + asin(sin(l1 - L0)./cosh(L))/2)));
Z = N.*C(1).*z + N.*(C(2)*sin(2*z) + C(3)*sin(4*z) + C(4)*sin(6*z) + C(5)*sin(8*z));
xs = imag(Z) + X0;
ys = real(Z) + YS;

f_temp = F0.*sign(lat);
fu = unique(f_temp);
if isscalar(fu)
    f = fu;
end

x = xs;
y = ys;

end % function

function c = coef(e,m)
%COEF Projection coefficients
%	COEF(E,M) returns a vector of 5 coefficients from:
%		E = first ellipsoid excentricity
%		M = 0 for transverse mercator
%		M = 1 for transverse mercator reverse coefficients
%		M = 2 for merdian arc

if nargin < 2
	m = 0;
end

switch m
	case 0
	c0 = [-175/16384, 0,   -5/256, 0,  -3/64, 0, -1/4, 0, 1;
           -105/4096, 0, -45/1024, 0,  -3/32, 0, -3/8, 0, 0;
           525/16384, 0,  45/1024, 0, 15/256, 0,    0, 0, 0;
          -175/12288, 0, -35/3072, 0,      0, 0,    0, 0, 0;
          315/131072, 0,        0, 0,      0, 0,    0, 0, 0];
	  
	case 1
	c0 = [-175/16384, 0,   -5/256, 0,  -3/64, 0, -1/4, 0, 1;
             1/61440, 0,   7/2048, 0,   1/48, 0,  1/8, 0, 0;
          559/368640, 0,   3/1280, 0,  1/768, 0,    0, 0, 0;
          283/430080, 0, 17/30720, 0,      0, 0,    0, 0, 0;
       4397/41287680, 0,        0, 0,      0, 0,    0, 0, 0];

	case 2
	c0 = [-175/16384, 0,   -5/256, 0,  -3/64, 0, -1/4, 0, 1;
         -901/184320, 0,  -9/1024, 0,  -1/96, 0,  1/8, 0, 0;
         -311/737280, 0,  17/5120, 0, 13/768, 0,    0, 0, 0;
          899/430080, 0, 61/15360, 0,      0, 0,    0, 0, 0;
      49561/41287680, 0,        0, 0,      0, 0,    0, 0, 0];
   
end
c = zeros(size(c0,1),1);

for i = 1:size(c0,1)
    c(i) = polyval(c0(i,:),e);
end

end % function