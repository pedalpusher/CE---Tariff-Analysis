function output = getdata(path)

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

data=struct([]);

for k=length(raw):-1:1
    %% Find company names
    title=raw{k}{6,1};
    cname{k}=title((strfind(title,'for')+4):(strfind(title,'-')-2));
    for i=length(cname{k}):-1:1
        if strcmp(cname{k}(i),' ')
            cname{k}(i)=[];
        end
    end
    
    %%Create company struct, check for duplicates
    if ~isfield(data,cname{k})
        tempstruct=struct(cname{k},[]);
        data=[data,tempstruct];
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
    if ~isfield(data.(cname{k}),tname{k})
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
        SDisc=struct('Online',[],'DF',[]);
        SDates=struct('Start',[],'End',[],'Term',[]);
        SCost=struct('GasU',[],'GasSt',[],'Elec1',[],'Elec2',[],'ElecN',[],'ElecSt',[]);
        Ssd=struct('StartDate',[]);
        Sed=struct('EndDate',[]);
        Std=struct('TermDate',[]);
        Sdis=struct('OnlineDis',[],'DFDis',[]);
        SFuel=struct('Gas',[],'Elec',[],'E7',[]);
        SReg=cell2struct(cell(length(rname)),rname);
        SPay=struct('MDD',[],'QDD',[],'PreP',[],'PayOn',[],'Dates',SDates,'Discounts',SDisc);
        
        for p=1:1:length(rname)
            Sreg.(rname{p})=SCost;
        end
        funames=fieldnames(SFuel);
        for p=1:1:length(funames)
            SFuel.(funames{p})=Sreg;
        end
        payname=fieldnames(SPay);
        payname(5:6)=[];
        for p=1:1:length(payname)
            SPay.(payname{p})=SFuel;
        end
        data.(cname{k}).(tname{k})=SPay;
    end
%     
    for j=1:1:length(raw{k})
        if ~isempty(strfind(raw{k}{j,1},'Monthly Direct Debit'))
            if ~isempty(strfind(raw{k}{j,3},'Gas'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasU=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(standard meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).Elec=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(E7 meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec1=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec2=[raw{k}{j,10}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecN=[raw{k}{j,11}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            end
        elseif ~isempty(strfind(raw{k}{j,1},'Pay On Receipt Of Bill'))
            if ~isempty(strfind(raw{k}{j,3},'Gas'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasU=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(standard meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).Elec=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(E7 meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec1=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec2=[raw{k}{j,10}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecN=[raw{k}{j,11}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            end
        elseif ~isempty(strfind(raw{k}{j,1},'Quarterly Direct Debit'))
            if ~isempty(strfind(raw{k}{j,3},'Gas'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasU=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(standard meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).Elec=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(E7 meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec1=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec2=[raw{k}{j,10}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecN=[raw{k}{j,11}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            end
        elseif ~isempty(strfind(raw{k}{j,1},'Prepayment Meter'))
            if ~isempty(strfind(raw{k}{j,3},'Gas'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasU=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Gas.(rname{i}).GasSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(standard meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).Elec=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.Elec.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            elseif ~isempty(strfind(raw{k}{j,3},'Electricity(E7 meter)'))
                for i=1:1:length(rname)
                    if ~isempty(strfind(raw{k}{j,2},rname{i}))
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec1=[raw{k}{j,9}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).Elec2=[raw{k}{j,10}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecN=[raw{k}{j,11}];
                        data.(cname{k}).(tname{k}).MDD.E7.(rname{i}).ElecSt=[raw{k}{j,6}];
                    end
                end
            end
        else
        end
    end
%     
end
output=data;
