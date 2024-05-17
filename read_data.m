function [Data_ID ] =read_data( list )  

fprintf('Please, select a dataset from the list:\n'); 
for i=1:length(list)
   fprintf('[%d] %s \n',i,list{i});
end
Data_ID = input('> ');

end

