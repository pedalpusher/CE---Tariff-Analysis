function output = tarifftimeline(path)

path='C:/Users/davidchristopherson/Documents/MATLAB/~Switching Behavior Modelling/Raw Data/Energy Linx Data.xlsx';
[~,~,r]=xlsread(path);

%% Create company identifiers

timedata=struct('BritishGas',[],'SSE',[],'npower',[],'EDFEnergy',[],'EON',[],'ScottishPower',[]);

timedata.BritishGas.id={'British','BG'};
timedata.SSE.id={'SSE','Southern'};
timedata.npower.id={'npower','NPOWER','nPower','Npower'};
timedata.EDFEnergy.id={'EDF'};
timedata.EON.id={'EON','E.ON','E.On'};
timedata.ScottishPower.id={'ScottishPower','Scottish Power',};

tname=cell(length(r)-1,1);
for k=1:1:(length(r)-1)
    details=r{k+1,5};
    % Find tariff names, convert to label format
    if ~isempty((strfind(details,'Launch ')))
        tname{k}=details((strfind(details,'Launch of')+10):end);
        if false%length(tname{k})>30
             tname{k}=tname{k}(1:25);
        end
        for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),' ')
                tname{k}(i)=[];
            end
        end
        for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),'&')
                tname{k}(i)=[];
            end
        end
        for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),'.')
                tname{k}(i)=[];
            end
        end
         for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),'(')
                tname{k}(i)=[];
            end
         end
         for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),')')
                tname{k}(i)=[];
            end
         end
         for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),'@')
                tname{k}(i)='a';
            end
         end
         for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),'+')
                tname{k}(i)=[];
            end
         end
         for i=length(tname{k}):-1:1
            if strcmp(tname{k}(i),'-')
                tname{k}(i)=[];
            end
         end
    end
    % Find company
    suppliers=fieldnames(timedata);
    cname=r{k+1,1};
    for a=1:1:length(suppliers)
        if and(~isempty(strfind(suppliers,cname)),~isempty(tname{k}))
            timedata.(suppliers{a}).(tname{k}).startdate=r{k+1,3};
        end
    end
end

%% Find company names
for k=1:1:(length(r)-1)
    cname{k}=r{k+1,1};
end
timedata=unique(cname);

%% Reformat company names
for k=length(raw):-1:1
    details=r{k+1,2};
    details=r{k+1,2};
    for i=length(cname{k}):-1:1
        if strcmp(cname{k}(i),' ')
            cname{k}(i)=[];
        end
    end
    for i=length(cname{k}):-1:1
        if strcmp(cname{k}(i),'.')
            cname{k}(i)=[];
        end
    end
    for i=length(cname{k}):-1:1
        if strcmp(cname{k}(i),':')
            cname{k}(i)=[];
        end
    end
    for i=length(cname{k}):-1:1
        if strcmp(cname{k}(i),'-')
            cname{k}(i)=[];
        end
    end
end

for a=2:1:length(r)
    if ~isempty(cell2mat(strfind(r(18,5),'Launch ')))
        