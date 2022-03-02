function waitbarStatus(t_i,t_end,step_size)
% waitbarStatus(t_i,t_end,step_size)
%
%   In:
%       t_i           Current step
%       t_end         Number of steps needed to finish the current task
%       step_size     Step size in percent after which the current status 
%                     should be reported. Lates after 'step_size' seconds 
%                     the status will be reported anyway.
%
%   Other m-files required: none
%   Subfunctions: none
%   MAT-files required: none
%
%   See also: none

%   Author: Hanno Winter
%   Date: 23-Nov-2020; Last revision: 23-Nov-2020


persistent last_call_time progress_mem_var

% Init ____________________________________________________________________

progress = t_i/t_end*100;

current_call_time = clock;

if isempty(progress_mem_var) || (progress_mem_var > progress)
    progress_mem_var = 0;
end % if

if isempty(last_call_time)
    last_call_time = current_call_time;
end % if

progress_since_last_call = (progress - progress_mem_var);

time_since_last_call = (current_call_time - last_call_time);
time_since_last_call = time_since_last_call(4)*3600 + time_since_last_call(5)*60 + time_since_last_call(6);

% Waitbar _________________________________________________________________

if progress == 0 || progress == 100 || progress_since_last_call > step_size  || time_since_last_call > step_size
    progress_mem_var = progress;
    last_call_time = current_call_time;
    fprintf('Status: %6.2f%%\n',progress);
end % if    

end % function