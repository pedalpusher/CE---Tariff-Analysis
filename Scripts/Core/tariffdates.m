function timedata = tariffdates

path='C:/Users/davidchristopherson/Documents/MATLAB/~Switching Behavior Modelling/Raw Data/Tariff Changes Data - EnergyLinx (fromJAN13).xlsx';
[~,~,r]=xlsread(path);

unique(r(2:end,1));%Display unique company names used in EnergyLinx Report

%% Create company identifiers

timedata=struct('BritishGas',[],'SSE',[],'npower',[],'EDFEnergy',[],'EON',[],'ScottishPower',[]);

timedata.BritishGas.id={'British','BG','British Gas'};
timedata.SSE.id={'SSE','Southern'};
timedata.npower.id={'npower','NPOWER','nPower','Npower'};
timedata.EDFEnergy.id={'EDF','EDF Energy'};
timedata.EON.id={'EON','E.ON','E.On','E.ON Energy'};
timedata.ScottishPower.id={'ScottishPower','Scottish Power'};

%% Tariff Changes
tname=cell(length(r)-1,1);
gname=cell(length(r)-1,1);
for k=1:1:(length(r)-1)
    details=r{k+1,5};
    % Find ADDED tariff names, convert to label format
    if ~isempty((strfind(details,'Launch of')))
        tname{k}=details((strfind(details,'Launch of')+10):end);
        gname{k}=genvarname(tname{k});
    end
    % Find REMOVED tariff names, convert to label format
    if ~isempty((strfind(details,'Removal of')))
        tname{k}=details((strfind(details,'Removal of')+11):end);
        gname{k}=genvarname(tname{k});
    end
    % Find company name
    suppliers=fieldnames(timedata);
    cname=r{k+1,1};
    for a=1:1:length(suppliers)
        if and(max(cell2mat(strfind(timedata.(suppliers{a}).id,cname))),~isempty((strfind(details,'Launch of'))))
            timedata.(suppliers{a}).tariffs.(gname{k}).startdate=r{k+1,3};
            timedata.(suppliers{a}).tariffs.(gname{k}).tariffname=tname{k};
        end
        if and(max(cell2mat(strfind(timedata.(suppliers{a}).id,cname))),~isempty((strfind(details,'Removal of'))))
            timedata.(suppliers{a}).tariffs.(gname{k}).enddate=r{k+1,3};
            timedata.(suppliers{a}).tariffs.(gname{k}).tariffname=tname{k};
        end
    end
end

%% Set default start date
for a=1:1:length(suppliers)
    tariffs=fieldnames(timedata.(suppliers{a}).tariffs);
    for b=1:1:length(tariffs)
        if ~isfield( timedata.(suppliers{a}).tariffs.(tariffs{b}),'startdate' )
            timedata.(suppliers{a}).tariffs.(tariffs{b}).startdate='01.01.2013';
        end
    end
end

%% Set default end date
for a=1:1:length(suppliers)
    tariffs=fieldnames(timedata.(suppliers{a}).tariffs);
    for b=1:1:length(tariffs)
        if ~isfield( timedata.(suppliers{a}).tariffs.(tariffs{b}),'enddate' )
            timedata.(suppliers{a}).tariffs.(tariffs{b}).enddate='01.01.2015';
        end
    end
end