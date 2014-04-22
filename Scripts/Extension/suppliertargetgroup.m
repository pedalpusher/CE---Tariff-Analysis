function output = suppliertargetgroup (data)

suppliers=fieldnames(data);
s=struct();

for a=1:1:length(suppliers)
    tariffs{a}=fieldnames(data.(suppliers{a}));
    for b=1:1:length(tariffs{a})
        regions=fieldnames(data.(suppliers{a}).(tariffs{a}{b}).MDD);
        for c=1:1:length(regions)
            archs=fieldnames(data.(suppliers{a}).(tariffs{a}{b}).MDD.(regions{c}).E1TAB);
            for d=1:1:length(archs)
                s.(suppliers{a}).SP.(archs{d}){b}=data.(suppliers{a}).(tariffs{a}{b}).MDD.(regions{c}).E1TAB.(archs{d});
            end
        end
    end
end

for a=1:1:length(suppliers)
    for b=1:1:length(archs)
        s.(suppliers{a}).SPAV(b)=mean(cell2mat(s.(suppliers{a}).SP.(archs{b})));
    end
end

output=cell((length(archs)+1),(length(suppliers)+1));
for a=1:1:length(suppliers)
    output{1,a+1}=suppliers{a};
    for b=1:1:length(archs)
        output{b+1,1}=archs{b};
        output{b+1,a+1}=s.(suppliers{a}).SPAV(b);
    end
end

xlswrite('suppliertargetgroup',output,'Results','A3:G20');

output2=cell(length(suppliers),4);
output2{1,1}='Supplier';
output2{1,2}='Tariffs';
for a=1:1:length(suppliers)
    output2{a+1,1}=suppliers{a};
    for b=1:1:length(tariffs{a})
        if ~isempty(tariffs{a}(b))
            output2{a+1,(b+1)}=tariffs{a}(b);
        end
    end
end

xlswrite('suppliertargetgroup',output2,'Tariff Information')