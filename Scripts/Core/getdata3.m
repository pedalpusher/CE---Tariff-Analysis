function output = getdata3

%% Set tariff filepath
%path = 'C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Raw Data\Current Tariffs - Big Six and Independent Variable';
%path = 'C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Raw Data\Current Tariffs - Variable Rate';
%path = 'C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Raw Data\Current Tariffs - Variable Rate Big Six';
path = 'C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Raw Data\Current Tariffs - Fixed Rate Big Six';

%% Set discounts filepath
dispath = 'C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Raw Data\Discount Data.xlsx';

%% Get filepaths
filepaths = getdirs(path);

%% Get raw data
for k=length(filepaths):-1:1
    [~,t,r]=xlsread(filepaths{k});
    txt{k}=t;
    raw{k}=r;
end

%% Find company names
for k=length(raw):-1:1
    title=raw{k}{6,1};
    cname{k}=title((strfind(title,'for')+4):(strfind(title,'- ')-2));
    companyname{k}=cname{k};
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
%% Create data structures
data=struct();
for i=1:1:length(cname)
    data.(cname{i})=[];
end

for k=length(raw):-1:1    
    %% Find tariff names
    title=raw{k}{6,1};
    tname{k}=title((strfind(title,'- ')+2):length(title));
    tariffname{k}=tname{k};
    if length(tname{k})>30
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
        if strcmp(tname{k}(i),'1')
            tname{k}(i)=[];
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
    %% Create tariff level, check for duplicates
    if ~isfield(data.(cname{k}),tname{k})
        %% Find region names
        for j=1:1:14
            rname{j}=txt{1,1}{(6+j),2};
            rname2{j}=txt{1,1}{(6+j),2};
            rname{j}(1:4)=[];
            for m=length(rname{j}):-1:1
                if strcmp(rname{j}(m),' ')
                    rname{j}(m)=[];
                end
            end
        end
        
        %% Pre-allocate structs
        SDates=struct('Start',[],'End',[],'Term',[]);
        SCost=struct('GasU',[],'GasSt',[],'Elec0',[],'Elec1',[],'Elec2',[],'ElecN',[],'ElecSt',[],'DOL',[],'DDF',[]);
        SPay=struct('MDD',[],'QDD',[],'PreP',[],'PayOn',[],'Dates',SDates);
        SReg=cell2struct(cell(length(rname),1),rname);
        
        for p=1:1:length(rname)
            SReg.(rname{p})=SCost;
        end
        payname=fieldnames(SPay);
        payname(5)=[];
        for p=1:1:length(payname)
            SPay.(payname{p})=SReg;
        end
        data.(cname{k}).(tname{k})=SPay;
        
        %% Include origonal company/tariff names
        
        data.(cname{k}).(tname{k}).CompanyName=companyname{k};
        data.(cname{k}).(tname{k}).TariffName=tariffname{k};
    
        %%  Allocate tariff data
        for j=1:1:length(raw{k})
            if ~isempty(strfind(raw{k}{j,1},'Monthly Direct Debit'))
                if ~isempty(strfind(raw{k}{j,4},'Yes'))
                    for i=1:1:length(rname)
                        if ~isempty(strfind(raw{k}{j,2},rname2{i}))
                            if ~isempty(strfind((raw{k}{j,3}),'Gas'))
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).GasU=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).GasSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(standard meter)'))
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).Elec0=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).ElecSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(E7 meter)'))
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).Elec1=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).Elec2=[raw{k}{j,10}];
                                data.(cname{k}).(tname{k}).MDD.(rname{i}).ElecN=[raw{k}{j,11}];
                            end
                            data.(cname{k}).(tname{k}).MDD.(rname{i}).DOL=[];
                            data.(cname{k}).(tname{k}).MDD.(rname{i}).DDF=[];
                        end
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,1},'Pay On Receipt Of Bill'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname2{i}))
                        if ~isempty(strfind(raw{k}{j,4},'Yes'))
                            if ~isempty(strfind((raw{k}{j,3}),'Gas'))
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).GasU=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).GasSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(standard meter)'))
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).Elec0=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).ElecSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(E7 meter)'))
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).Elec1=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).Elec2=[raw{k}{j,10}];
                                data.(cname{k}).(tname{k}).PayOn.(rname{i}).ElecN=[raw{k}{j,11}];
                            end
                            data.(cname{k}).(tname{k}).PayOn.(rname{i}).DOL=[];
                            data.(cname{k}).(tname{k}).PayOn.(rname{i}).DDF=[];
                        end
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,1},'Quarterly Direct Debit'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname2{i}))
                        if ~isempty(strfind(raw{k}{j,4},'Yes'))
                            if ~isempty(strfind((raw{k}{j,3}),'Gas'))
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).GasU=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).GasSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(standard meter)'))
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).Elec0=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).ElecSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(E7 meter)'))
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).Elec1=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).Elec2=[raw{k}{j,10}];
                                data.(cname{k}).(tname{k}).QDD.(rname{i}).ElecN=[raw{k}{j,11}];
                            end
                            data.(cname{k}).(tname{k}).QDD.(rname{i}).DOL=[];
                            data.(cname{k}).(tname{k}).QDD.(rname{i}).DDF=[];
                        end
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,1},'Prepayment Meter'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname2{i}))
                        if ~isempty(strfind(raw{k}{j,4},'Yes'))
                            if ~isempty(strfind((raw{k}{j,3}),'Gas'))
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).GasU=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).GasSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(standard meter)'))
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).Elec0=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).ElecSt=[raw{k}{j,6}];
                            end
                            if ~isempty(strfind((raw{k}{j,3}),'Electricity(E7 meter)'))
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).Elec1=[raw{k}{j,9}];
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).Elec2=[raw{k}{j,10}];
                                data.(cname{k}).(tname{k}).PreP.(rname{i}).ElecN=[raw{k}{j,11}];
                            end
                            data.(cname{k}).(tname{k}).PreP.(rname{i}).DOL=[];
                            data.(cname{k}).(tname{k}).PreP.(rname{i}).DDF=[];
                        end
                    end
                end
            end

        end
    end     
end

%%  Find and allocate discount data
[~,~,rawdis]=xlsread(dispath);
for a=1:1:length(cname)
    tnames=fieldnames(data.(cname{a}));
    for b=1:1:length(tnames)
        for c=1:1:length(payname)
            for d=1:1:length(rname)
                for e=1:1:length(rawdis(1,:))
                    if strcmp(rawdis(2,e),cname(a))
                        data.(cname{a}).(tnames{b}).(payname{c}).(rname{d}).DDF=cell2mat(rawdis((d+2),e));
                        %data.(cname{a}).(tname{b}).(payname{c}).(rname{d}).DOL=[];
                    end
                end
            end
        end
    end
    clear tnames
end