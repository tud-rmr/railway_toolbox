function [lat,lon]=utm2ll_stripped(x,y,f,datum)
% Stripped version of Francois Beauducel 'utm2ll' function
%
% Reference:  
%   François Beauducel (2021). LL2UTM and UTM2LL 
%   (https://www.mathworks.com/matlabcentral/fileexchange/45699-ll2utm-and-utm2ll), 
%   MATLAB Central File Exchange. Retrieved March 26, 2021.  
% 

lat = 0;
lon = 0;

if all([numel(x),numel(y)] > 1) && any(size(x) ~= size(y))
	error('X and Y must be the same size or scalars.')
end

if ~isnumeric(f) || any(f ~= round(f)) || (~isscalar(f) && any(size(f) ~= size(x)))
	error('ZONE must be integer value, scalar or same size as X and/or Y.')
end

A1 = 6378137.0;
F1 = 298.257223563;

% constants
D0 = 180/pi;	% conversion rad to deg
maxiter = 100;	% maximum iteration for latitude computation
eps = 1e-11;	% minimum residue for latitude computation

K0 = 0.9996;					% UTM scale factor
X0 = 500000;					% UTM false East (m)
Y0 = 1e7*(f < 0);				% UTM false North (m)
P0 = 0;						% UTM origin latitude (rad)
L0 = (6*abs(f) - 183)/D0;			% UTM origin longitude (rad)
E1 = sqrt((A1^2 - (A1*(1 - 1/F1))^2)/A1^2);	% ellpsoid excentricity
N = K0*A1;

% computing parameters for Mercator Transverse projection
C = coef(E1,0);
YS = Y0 - N*(C(1)*P0 + C(2)*sin(2*P0) + C(3)*sin(4*P0) + C(4)*sin(6*P0) + C(5)*sin(8*P0));

C = coef(E1,1);
zt = complex((y - YS)/N/C(1),(x - X0)/N/C(1));
z = zt - C(2)*sin(2*zt) - C(3)*sin(4*zt) - C(4)*sin(6*zt) - C(5)*sin(8*zt);
L = real(z);
LS = imag(z);

l = L0 + atan(sinh(LS)./cos(L));
p = asin(sin(L)./cosh(LS));

L = log(tan(pi/4 + p/2));

% calculates latitude from the isometric latitude
p = 2*atan(exp(L)) - pi/2;
p0 = 0;
n = 0;
while n==0 || ( all(abs(p - p0) > eps) && (n < maxiter) )
    p0(1) = p(1);
	es = E1*sin(p0);
	p = 2*atan(((1 + es)./(1 - es)).^(E1/2).*exp(L)) - pi/2;
	n = n + 1;
end

lat = p*D0;
lon = l*D0;

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

