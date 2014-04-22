function output = getdata3(path)

%% get filepaths
filepaths = getdirs(path);

%% get raw data
for k=length(filepaths):-1:1
    [n,t,r]=xlsread(filepaths{k});
    num{k}=n;
    txt{k}=t;
    raw{k}=r;
end
%% Create data structures

data=struct(1,0);

for k=length(raw):-1:1
    %% Find company names
    title=raw{k}{6,1};
    cname{k}=title((strfind(title,'for')+4):(strfind(title,'-')-2));
    for i=length(cname{k}):-1:1
        if strcmp(cname{k}(i),' ')
            cname{k}(i)=[];
        end
        if strcmp(cname{k}(i),'.')
            cname{k}(i)=[];
        end
    end
    
    %%Create company struct, check for duplicates
    if ~isfield(data,cname{k})
        %[data(:).cname{k}]=deal(:);
        data().(cname{k})=[0];
    end
    
    %% Find tariff names
    tname{k}=title((strfind(title,'-')+2):length(title));
    for i=length(tname{k}):-1:1
        if strcmp(tname{k}(i),' ')
            tname{k}(i)=[];
        end
        if strcmp(tname{k}(i),'&')
            tname{k}(i)=[];
        end
    end
    %% Create tariff level, check for duplicates
    if ~isfield(data,tname{k})
        %% Find region names
        for j=1:1:13
            rname{j}=txt{1,1}{(6+j),2};
            rname{j}(1:4)=[];
            for m=length(rname{j}):-1:1
                if strcmp(rname{j}(m),' ')
                    rname{j}(m)=[];
                end
            end
        end
        
        %% Pre-allocate structs
        SDates=struct('Start',[],'End',[],'Term',[]);
        SCost=struct('GasU',[],'GasSt',[],'Elec0',[],'Elec1',[],'Elec2',[],'ElecN',[],'ElecSt',[],'DOL',[],'DDF',[],'TAB',[],'TMB',[]);
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
    
    %%  Allocate Data
        for j=1:1:length(raw{k})
            if ~isempty(strfind(raw{k}{j,1},'Monthly Direct Debit'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
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
            elseif ~isempty(strfind(raw{k}{j,1},'Pay On Receipt Of Bill'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
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
            elseif ~isempty(strfind(raw{k}{j,1},'Quarterly Direct Debit'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
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
            elseif ~isempty(strfind(raw{k}{j,1},'Prepayment Meter'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
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
output=data;
