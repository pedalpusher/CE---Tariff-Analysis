function conval = getconsumption

conpath='C:\Users\davidchristopherson\Documents\MATLAB\~Switching Behavior Modelling\Raw Data\Consumption Values.xlsx';

[~,~,rawcon]=xlsread(conpath);

arch=rawcon(2:(length(rawcon)-1),8);

conval=struct();
for i=1:1:length(arch)
    conval.(arch{i})=struct('Elec',cell2mat(rawcon(i+1,5)),'Gas',cell2mat(rawcon(i+1,6)));
end
