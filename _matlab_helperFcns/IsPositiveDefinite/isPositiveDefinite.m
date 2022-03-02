function q = isPositiveDefinite(A,tolerance)
% q = isPositiveDefinite(A,tolerance)

test_sym = A - (A+A.')/2;
test_det = det(A);
if any(any(abs(test_sym) > tolerance)) || (test_det < -tolerance)
    q = false;
else
    q = true;
end % if

end

