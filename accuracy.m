%Questo script legge tutte le confusion matrix create e calcola
%l'accuratezza media del programma

pathConfusion = fullfile('sampleData', 'confusion');

files = dir(fullfile(pathConfusion, '*.csv'));
orders = dir(fullfile(pathConfusion, '*.order'));

sommaAcc = 0;

for f = 1 : numel(files)
    
    confusion = csvread(fullfile(pathConfusion, files(f).name));
    order = csvread(fullfile(pathConfusion, orders(f).name));
 
    dimensione = size(confusion);
    for i = 1 : dimensione(1)
        sommaRiga(i) = sum(confusion(i,:));
    end
    
    for j = 1 : dimensione(2)
        sommaColonna(j) = sum(confusion(:,j));
    end
    
    sommaTot = sum(sommaColonna);
    sommaDiagonale = trace(confusion);
    
    accuratezza = sommaDiagonale / sommaTot * 100;
    
   
    sommaAcc = sommaAcc + accuratezza;
    
end

disp(sommaAcc / numel(files));
