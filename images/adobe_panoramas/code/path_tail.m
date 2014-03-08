function tail = path_tail(dir)
% tail = path_tail(dir)
%   return trailing element of a filesystem path

% look for directory separator and pull out tail of path
dir_sep = regexp(dir, '[/\\]');
if isempty(dir_sep)
    tail = dir;
else
    tail = dir((max(dir_sep)+1):end);
end
