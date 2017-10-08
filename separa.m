%% Questo script prende in input un'immagine e la sua segmentazione e produce
%% n immagini: una per ogni oggetto identificato

imagesFolder = fullfile('sampleData', 'images');
predictionsFolder_Dilated = fullfile('sampleData', 'predictions_Dilated');
predictionsFolder_FCN = fullfile('sampleData', 'predictions_FCN');
mkdir sampleData segmented_FCN;
segmentedFolder_FCN = fullfile('sampleData', 'segmented_FCN');

%% Creo le cartelle che contengono gli oggetti suddivisi per classe

classesFID = fopen('objectInfo150.txt');
line = fgetl(classesFID);
line = fgetl(classesFID);
labels = [];
while ischar(line)
    
    [token, remain] = strtok(line);
    [token, remain] = strtok(remain);
    [token, remain] = strtok(remain);
    [token, remain] = strtok(remain);
    
    remain = strtrim(remain);
    token = strtok(remain, ' ,;'); 
    token = strtrim(token);
    labels = [labels, string(token)];
    
    line = fgetl(classesFID);
end
fclose(classesFID);

%{
for i = 1:numel(labels)
   
    mkdir(char(strcat('sampleData/', strcat('segmented_FCN/',labels(i)))));
    
end
%}
images = dir(fullfile(imagesFolder, '*.jpg'));

for f = 1: numel(images)
    
    fileImage = fullfile(imagesFolder, images(f).name);
    filePred_Dilated = fullfile(predictionsFolder_Dilated, strrep(images(f).name, '.jpg', '.png'));
    filePred_FCN =  fullfile(predictionsFolder_FCN, strrep(images(f).name, '.jpg', '.png'));
    
    im = imread(fileImage);
    imPred_Dilated = imread(filePred_Dilated);
    imPred_FCN = imread(filePred_FCN);
    
    [rows, cols, pix] = size(im);
   
    %Array che contiene l'indice degli oggetti presenti nell'immagine
    objects = zeros(1);
   
    %% Controllo gli oggetti esistenti ed inserisco quelli nuovi in objects
    for i = 1:rows
        for j = 1:cols
            if (ismember(objects, imPred_FCN(i, j)) ~= 1)
                objects = [objects imPred_FCN(i,j)];
            end
        end
    end
    [objRows, objCols] = size(objects);
        
    %% Creo una nuova immagine per ogni oggetto rilevato
    for obj = 1:objCols
       
        %Creo una nuova immagine con le stesse dimensioni dell'immagine
        %originale e la imposto come nera
        segment = im;
        
        %Ad ogni pixel dell'immagine che appartiene al segmento, assegno il
        %colore originale
        for i = 1:rows
            for j = 1:cols
                if (objects(obj) ~= imPred_FCN(i, j))
                    segment(i, j, 1) = 0;
                    segment(i, j, 2) = 0;
                    segment(i, j, 3) = 0;
                end
            end
        end
               
        %Salvo in memoria l'immagine con il nome del segmento
        %segmentName = fullfile(segmentedFolder_FCN, strcat(labels(int8(objects(obj))),images(f).name));
        %imwrite(segment, segmentName);
    end
    
end

