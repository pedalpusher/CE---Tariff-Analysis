function output = findmddeleconly (data) % Add gas/elec consumption fields, discount fields, date current/all fields, Company List fields, later on

%Get fieldnames
cname=fieldnames(data);
payname={'MDD','QDD','PreP','PayOn'};

%%Calculate Tariff Annual Bill (TAB)
%where EMB = ((1+VAT) * ( (Elec. Standing/day * 365) + (Elec. Rate * Elec Use) + (Gas Standing/day *365) + (Gas Rate * Gas Use) ) ) + DISCOUNT

%Set Consumption Values

conval=getconsumption;
%GasCon=[13500];
%ElecCon=[3200];

%Set VAT
VAT=1.05;


for a=1:1:length(cname)
    tname=fieldnames(data.(cname{a}));
    for b=1:1:length(tname)
        for c=1:1:length(payname)
            rname=fieldnames(data.(cname{a}).(tname{b}).(payname{c}));
            for e=1:1:length(rname)

                %Find Values in £
                GasU=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).GasU);
                GasSt=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).GasSt);
                Elec0=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).Elec0);
                Elec1=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).Elec1);
                Elec2=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).Elec2);
                ElecN=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).ElecN);
                ElecSt=(1/100).*(data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).ElecSt);
                DOL=data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).DOL;
                DDF=data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).DDF;

                %Calculate TAB
                arch=fieldnames(conval);
                for d=1:1:length(arch)
                    ElecCon=conval.(arch{d}).Elec;
                    GasCon=conval.(arch{d}).Gas;
                    if conval.(arch{d}).Gas==0
                        E1TAB=((VAT).*( (ElecSt.*365)+(Elec0.*ElecCon))) -DDF;% no standing gas charge for non gas customers
                        E7TAB=(VAT).*( (ElecSt.*365)+(Elec1.*ElecCon.*0.55)+(ElecN.*ElecCon.*0.45));
                    else
                        E1TAB=((VAT).*( (ElecSt.*365)+(Elec0.*ElecCon) )) -DDF;
                        E7TAB=(VAT).*( (ElecSt.*365)+(Elec1.*ElecCon.*0.55)+(ElecN.*ElecCon.*0.45) );
                    end
                    data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E1TAB.(arch{d})=E1TAB;
                    data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E7TAB.(arch{d})=E7TAB;
                    data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E1TMB.(arch{d})=(E1TAB/12);
                    data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E7TMB.(arch{d})=(E7TAB/12);
                end
            end
        end
    end
end

output=data;