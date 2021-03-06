function cheapest = cheapest(data)

%% Get region names, archetype names
cname=fieldnames(data);
for a=1:1:length(cname)
    tname=fieldnames(data.(cname{a}));
    for b=1:1:length(tname);
        rname=fieldnames(data.(cname{a}).(tname{b}).MDD);
        for c=1:1:length(rname)
            arch=fieldnames(data.(cname{a}).(tname{b}).MDD.(rname{c}).E1TAB);
        end
    end
end

%% Find cheapest supplier in each region/archetype

cheapest=cell(size(rname,1),size(arch,1));
for a=1:1:length(rname)
    for b=1:1:length(arch)
        for c=1:1:length(cname)
            tname=fieldnames(data.(cname{c}));
            if ~isempty(data.(cname{c}).(tname{1}).MDD.(rname{a}).E1TAB.(arch{b}))
                val1(c)=data.(cname{c}).(tname{1}).MDD.(rname{a}).E1TAB.(arch{b});
            end
        end
        index=find(min(val1)==val1);
        cheapest(1,2:17)=arch;
        cheapest(2:15,1)=rname;
        cheapest{a+1,b+1}=cname(index);
        clear val1
    end
end

xlswrite('cheapest',cheapest)

%% Find the cheapest tariff in each region/archetype for each supplier

cheapest=cell(size(rname,1),size(arch,1));
result=cell(size(rname,1),size(arch,1));
for a=1:1:length(rname)
    for b=1:1:length(arch)
        for c=1:1:length(cname)
            tname=fieldnames(data.(cname{c}));
            tnames{c}=fieldnames(data.(cname{c}));
            for d=1:1:length(tname)
                if ~isempty(data.(cname{c}).(tname{d}).MDD.(rname{a}).E1TAB.(arch{b}))
                    val1(c,d)=data.(cname{c}).(tname{1}).MDD.(rname{a}).E1TAB.(arch{b});%List available tariff TABs
                end
            end
        end
        %Find coordinates of cheapest tariff TAB
        [supplierID,tariffID]=(find(val1==min(val1(val1>0))));
        cheapest(1,2:(length(arch)+1))=arch;
        cheapest(2:(length(rname)+1),1)=rname;
        result{a,b}=strcat ( (cname(supplierID(1))),' - ',(tnames{supplierID(1)}{tariffID(1)}) );
        cheapest{a+1,b+1}=result{a,b};
        clear val1
        clear supplierID
        clear tariffID
    end
end

