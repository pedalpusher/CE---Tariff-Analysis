function output = marketgrid (data,write)

%% Extraction of data from data struct into matlab array
gap=18;% Gap between entries
entry=0;% Initialise integral counter for tariff entries
cname=fieldnames(data);
for a=1:1:length(cname)
    tname=fieldnames(data.(cname{a}));
    for b=1:1:length(tname)
        entry=entry+1;
     
        pays={'MDD','QDD','PreP','PayOn'};
        
        for c=1:1:length(pays)
            rname=fieldnames(data.(cname{a}).(tname{b}).(pays{c}));
            for d=1:1:length(rname)
                archs=fieldnames(data.(cname{a}).(tname{b}).(pays{c}).(rname{d}).E1TMB);
                for e=1:1:length(archs)
                    
                    output{c}{((e)*gap)+1,2}=archs(e);
                    output{c}{((e)*gap)+1,3}=pays(c);
                    output{c}{((e)*gap)+(2),1}='Archetype';
                    output{c}{((e)*gap)+(2+d),1}=rname(d);
                    
                    companyname{a}=data.(cname{a}).(tname{b}).CompanyName;
                    tariffname=data.(cname{a}).(tname{b}).TariffName;
                    name=strcat(companyname{a},' -',' ',tariffname);
                    output{c}{((e)*gap)+2,entry+1}=name;
                    
                    output{c}{((e)*gap)+(2+d),entry+1}=data.(cname{a}).(tname{b}).(pays{c}).(rname{d}).E1TMB.(archs{e});
                    
                end
            end
        end
    end
end

%% Find each of Big Six's cheapest tariffs, calculate the average, create new output array and format results into it

cheapoutput=cell(1,4);

for a=1:1:length(output)
    cheapoutput{a}=cell(size(output{1}));
    for b=1:1:length(archs)
        
        %Create temporary storage struct
        cheap=struct();
        for c=1:1:length(companyname)
            cheap.(cname{c}).tariffs=[];
            cheap.(cname{c}).av=[];
        end
        
        % Fill temporary storage struct
        for c=2:1:size(output{a},2)
            loc=(gap*b)+2;
            name=output{a}{loc,(c+1)-1}(1:strfind(output{a}{loc,(c+1)-1},'-')-2 );
            for d=1:1:length(companyname)
                if strcmp((companyname{d}),name)
                    entry=length(cheap.(cname{d}).tariffs)+1;
                    cheap.(cname{d}).tariffs{1,entry}=output{a}((loc+1:loc+length(rname)),(c+1)-1);
                    cheap.(cname{d}).av{1,entry}=mean(cell2mat(cheap.(cname{d}).tariffs{entry}));
                end
            end
        end
        
        % Format results into array
        for c=1:1:length(cname)
            [~,w]=min(cell2mat(cheap.(cname{c}).av));
            
            cheapoutput{a}{((b*gap)),(1)}=(archs{b});
            cheapoutput{a}{((b*gap)),(2)}=(pays{a});
            cheapoutput{a}{((b*gap+1)),(c+1)}=(companyname{c});
            cheapoutput{a}(((b*gap)+2):((b*gap)+2+(length(rname)-1)),(1))=rname;
            cheapoutput{a}(((b*gap)+2):((b*gap)+2+(length(rname)-1)),(c+1))=cheap.(cname{c}).tariffs{w};
            
        end
    end
end

%% Initialisation of POI Libs
% Add Java POI Libs to matlab javapath
javaaddpath('C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Scripts\Imported\poi_library\poi-3.8-20120326.jar');
javaaddpath('C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Scripts\Imported\poi_library\poi-ooxml-3.8-20120326.jar');
javaaddpath('C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Scripts\Imported\poi_library\poi-ooxml-schemas-3.8-20120326.jar');
javaaddpath('C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Scripts\Imported\poi_library\xmlbeans-2.3.0.jar');
javaaddpath('C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Scripts\Imported\poi_library\dom4j-1.6.1.jar');
javaaddpath('C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Scripts\Imported\poi_library\stax-api-1.0.1.jar');

%% Output to .xlsx
if write==true
    for a=1:1:length(pays)
        outpath='C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Results\marketgrid.xlsx';
        xlwrite(outpath,output{a},(pays{a}))
        outpath='C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Results\cheapmarketgrid.xlsx';
        xlwrite(outpath,cheapoutput{a},(pays{a}))
    end
end