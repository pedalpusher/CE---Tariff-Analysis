function output = findmdd (data) % Add gas/elec consumption fields, discount fields, date current/all fields, Company List fields, later on

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
                E1TAB=(VAT).*( (ElecSt.*365)+(Elec0.*ElecCon)+(GasSt.*365)+(GasU*GasCon) );
                E7TAB=(VAT).*( (ElecSt.*365)+(Elec1.*ElecCon.*0.55)+(ElecN.*ElecCon.*0.45)+(GasSt.*365)+(GasU*GasCon) );
                data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E1TAB=E1TAB;
                data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E7TAB=E7TAB;
                data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E1TMB=(E1TAB/12);
                data.(cname{a}).(tname{b}).(payname{c}).(rname{e}).E7TMB=(E7TAB/12);

            end
        end
    end
end

output=data;