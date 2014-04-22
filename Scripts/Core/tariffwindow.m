data=timedata;

setstartdate='01.11.13';
setenddate='01.10.13';

formatIn='dd.mm.yy';
setstartstamp=datenum(setstartdate,formatIn);
setendstamp=datenum(setenddate,formatIn);

outnumber=0;
suppliers=fieldnames(data);
for a=1:1:length(suppliers)
    tariffs=fieldnames(data.(suppliers{a}).tariffs);
    for b=1:1:length(tariffs)
        startstamp=datenum(data.(suppliers{a}).tariffs.(tariffs{b}).startdate,formatIn);
        endstamp=datenum(data.(suppliers{a}).tariffs.(tariffs{b}).enddate,formatIn);
        if and( endstamp>setendstamp,startstamp<setstartstamp )
            outnumber=outnumber+1;
            output{outnumber,1}=suppliers{a};
            output{outnumber,2}=data.(suppliers{a}).tariffs.(tariffs{b}).tariffname;
            output{outnumber,3}=datestr(startstamp);
            output{outnumber,4}=datestr(endstamp);
        end
    end
end
