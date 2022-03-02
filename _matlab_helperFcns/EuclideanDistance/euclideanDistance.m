function d = euclideanDistance(x,y)
% function d = euclideanDistance(x,y)
%
% Returns distances between each pair of x(i) and y(i)

if ~isvector(x) || ~isvector(y)
    error('''x'' and ''y'' are supposed to be vectors!');
end % if

if size(x) ~= size(y)
    error('''x'' and ''y'' have to be of the same form!');
end % if

d = zeros(size(x(2:end)));
for i = 2:length(x)
    d(i-1) = norm([diff(x(i-1:i)) diff(y(i-1:i))]);
end % end for i

% d = arrayfun(@(x_i,y_i) norm([x_i y_i]),diff(x),diff(y));

end % end function euclideanDistance

