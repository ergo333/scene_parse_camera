%Questo script calcola, data la matrice di confusione, la sensitività
%del segmentatore

pathConfusion = fullfile('sampleData', 'confusionDilated');

files = dir(fullfile(pathConfusion, '*.csv'));
orders = dir(fullfile(pathConfusion, '*.order'));

matriceAccuratezza = zeros(151, numel(files));

for f = 1 : numel(files)
        
    confusion = csvread(fullfile(pathConfusion, files(f).name));
    order = csvread(fullfile(pathConfusion, orders(f).name));
    
    righe = size(order);
        
    for i = 1 : righe(1)
        sommaRiga = sum(confusion(i,:));
        
        if (sommaRiga ~= 0)
            matriceAccuratezza(order(i)+1,f) = (confusion(i,i) / sommaRiga) * 100;
          
        end
        
    end  
    
   
   
end

%medio le accuratezze per categoria
categoria = zeros(150,1);
for i = 1 : 151
    somma = sum(matriceAccuratezza(i,:));
    if (nnz(matriceAccuratezza(i,:)) ~= 0)
        categoria(i) = somma/nnz(matriceAccuratezza(i,:));
    end
end

categoria = categoria/norm(categoria);

disp(categoria);
csvwrite('sensitivity_Dilated.csv',categoria);