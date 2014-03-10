function [cs,index] = sortFiles(c,mode)
    if nargin < 2
        mode = 'ascend';
    end

    modes = strcmpi(mode,{'ascend','descend'});
    is_descend = modes(2);
    if ~any(modes)
        error('sort_nat:sortDirection',...
            'sorting direction must be ''ascend'' or ''descend''.')
    end

    c2 = regexprep(c,'\d+','0');

    s1 = char(c2);
    z = s1 == '0';

    [digruns,first,last] = regexp(c,'\d+','match','start','end');

    num_str = length(c);
    max_len = size(s1,2);
    num_val = NaN(num_str,max_len);
    num_dig = NaN(num_str,max_len);
    for i = 1:num_str
        num_val(i,z(i,:)) = sscanf(sprintf('%s ',digruns{i}{:}),'%f');
        num_dig(i,z(i,:)) = last{i} - first{i} + 1;
    end

    activecols = reshape(find(~all(isnan(num_val))),1,[]);
    n = length(activecols);

    numcols = activecols + (1:2:2*n);

    ndigcols = numcols + 1;

    charcols = true(1,max_len + 2*n);
    charcols(numcols) = false;
    charcols(ndigcols) = false;

    comp = zeros(num_str,max_len + 2*n);
    comp(:,charcols) = double(s1);
    comp(:,numcols) = num_val(:,activecols);
    comp(:,ndigcols) = num_dig(:,activecols);

    [unused,index] = sortrows(comp);
    if is_descend
        index = index(end:-1:1);
    end
    index = reshape(index,size(c));
    cs = c(index);