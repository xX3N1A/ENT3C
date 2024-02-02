function [combinations] = get_pairwise_combs(CELL_TYPEs,BioReps)

if BioReps==1
    NUMMEL_BRs=struct();N=0;
    for CELL_TYPE=CELL_TYPEs
        CELL_TYPE=CELL_TYPE{1};
        [~,BRs] = CELL_INFO(CELL_TYPE);
        eval(sprintf('NUMMEL_BRs.%s=1:%d;',CELL_TYPE,BRs))
    end


    % Get field names and values
    cellTypes = fieldnames(NUMMEL_BRs);
    cellValues = struct2cell(NUMMEL_BRs);

    % Initialize empty cell array to store combinations
    combinations = cell(0, 4);
    % Generate pairwise combinations
    for i = 1:numel(cellTypes)
        if size(cellValues{i},2)>1
            pairs = nchoosek(cellValues{i},2);
            combinations = [combinations; repmat({cellTypes{i}}, size(pairs, 1), 1), num2cell(pairs(:, 1)), ...
                repmat({cellTypes{i}}, size(pairs, 1), 1), num2cell(pairs(:, 2))];
        else
            pairs = 1;
        end

        for j = (i+1):numel(cellTypes)
            [X, Y] = meshgrid(cellValues{i},cellValues{j});
            pairs = [X(:) Y(:)];

            combinations = [combinations; repmat({cellTypes{i}}, size(pairs, 1), 1), num2cell(pairs(:, 1)), ...
                repmat({cellTypes{j}}, size(pairs, 1), 1), num2cell(pairs(:, 2))];
        end
    end

else

    N = numel(CELL_TYPEs);

    % Initialize an empty cell array to store the combinations
    combinations = cell(0, 2);

    % Generate pairwise combinations
    for i = 1:N-1
        for j = i+1:N
            combinations = [combinations; {CELL_TYPEs{i}}, {CELL_TYPEs{j}}];
        end
    end
end