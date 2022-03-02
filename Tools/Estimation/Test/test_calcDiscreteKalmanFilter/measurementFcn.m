function [z_hat,H] = measurementFcn(x,z,u,sample_time)

H = [1 0];
z_hat = H*x;

end

