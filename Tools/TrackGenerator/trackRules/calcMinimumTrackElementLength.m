function l_min = calcMinimumTrackElementLength(trackElementType,v,R)
% l_min = calcMinimumTrackElementLength(trackElementType,v,R)
%
% In:
%   v in km/h
%   R in m
%
% Out:
%   l_min in m
%

v = abs(v);
R = abs(R);

ueberhoehungsfehlbetrag = @(v,R) 11.8*v^2/R; % see: L. Fendrich and W. Fengler, Handbuch Eisenbahninfrastrukur, S. 611
uebergangsbogenlaenge = @(v,delta_u) 8*v*delta_u/1000; % see: L. Fendrich and W. Fengler, Handbuch Eisenbahninfrastrukur, S. 617     

if any(ismember(trackElementType,[1,3]))
    l_min = 0.4*v; % see: L. Fendrich and W. Fengler, Handbuch Eisenbahninfrastrukur, S. 617   
elseif any(ismember(trackElementType,[2,4]))    
    l_min = uebergangsbogenlaenge(v,ueberhoehungsfehlbetrag(v,R));
elseif trackElementType == 5
    l_min_1 = uebergangsbogenlaenge(v,2*ueberhoehungsfehlbetrag(v,R));
    l_min_2 = 0.2*v; % see: L. Fendrich and W. Fengler, Handbuch Eisenbahninfrastrukur, S. 626

    l_min = max(l_min_1,l_min_2);
end % if
l_min = ceil(l_min);

end % function

