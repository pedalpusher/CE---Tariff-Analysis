function filepaths = getdirs(path)

dirs = dir(path);

for k=length(dirs):-1:1
    %remove files that do not begin with '20'
    fname=dirs(k).name;
    if length(fname)>1
        if ~strcmp(fname(1:2),'20')
            dirs(k)=[];
        end
    else
        dirs(k)=[];
    end
end

for k=length(dirs):-1:1
    filepaths(k)={dirs(k).name};
    filepaths(k)=strcat(path,'\',filepaths(k));
end
