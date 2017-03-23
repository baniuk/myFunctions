function out = unique_cell(in)

for a=1:length(in)-1
    for b=a+1:length(in)
        if isequal(in{a},in{b})
            in{b}=[];
        end
    end
end

licz = 1;
for a=1:length(in)
    if ~isempty(in{a})
        out{licz} = in{a};
        licz = licz + 1;
    end
end