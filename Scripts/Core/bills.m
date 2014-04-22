function [gTMB,eTMB] = bills (data)

GasCon=13500;
ElecCon=3200;

gTMB=cell(7,14);
eTMB=cell(7,14);

cname=fieldnames(data);
for a=1:1:length(cname)
    tname=fieldnames(data.(cname{a}));
    for b=1:1:length(tname)
        rname=fieldnames(data.(cname{a}).(tname{b}).MDD);
        for c=1:1:length(rname)
            GasU=data.(cname{a}).(tname{b}).MDD.(rname{c}).GasU;
            GasSt=data.(cname{a}).(tname{b}).MDD.(rname{c}).GasSt;
            ElecU=data.(cname{a}).(tname{b}).MDD.(rname{c}).Elec0;
            ElecSt=data.(cname{a}).(tname{b}).MDD.(rname{c}).ElecSt;
            gTAB=( (GasU*GasCon) + (365*GasSt) ) / (GasCon);
            gTMB{a+1,c+1}=gTAB;
            eTAB=( (ElecU*ElecCon) + (365*ElecSt) ) / (ElecCon);
            eTMB{a+1,c+1}=eTAB;
        end
    end
end

gTMB(1,2:end)=rname;
eTMB(1,2:end)=rname;
gTMB(2:end,1)=cname;
eTMB(2:end,1)=cname;
