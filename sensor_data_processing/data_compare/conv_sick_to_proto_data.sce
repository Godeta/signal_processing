clc;
clear;


PATH = 'C:\devRoot\data\signal_processing\sensor_data_processing\data_compare\';

////test résultat
//proto9 = csvRead(PATH+'proto9.csv',",");
///*


//small file to create data similar to my prototype upon the sick sensor data
proto9 = csvRead(PATH+'capteurs9.csv',",");
proto9(isnan(proto9))=0;

val = proto9(:,2)*10;
opp = ones(prod(size(val)),1)*90;
time = proto9(:,1);
//minMax = proto9(:,4);
//falseTrue = proto9(:,5);

newValues = opp-val;
SIZE = prod(size(time));
//tests
//plot(newValues)
//dataProto{9}= cat(2,time,newValues);


//generate CSV data
format("v",25);
csvData{1,1}= "temps";
csvData{1,2} = "distance";
csvData{1,3} = "vide";
csvData{1,4} = "minMax";
csvData{1,5} = "falseTrue";

    for i=1:SIZE
    //ajouter les résultats au tableau de données CSV
        csvData{i+1,1}= string(time(i));
        csvData{i+1,2}= string(newValues(i));
        csvData{i+1,3}= string(0);
        csvData{i+1,4}= string(1);//string(minMax(i));
        csvData{i+1,5}= string(1);//string(falseTrue(i));
    end
    
//write CSV
    printf("\n");
    printf("############################################################################\n")
    printf(" Saving the result in a .csv file \n")
    printf("############################################################################\n")
    printf("\n");
    RESU2 = mopen(PATH + "newProto" + ".csv",'w') ;
//    disp(csvData{11,4});
    for i=1:SIZE
//        disp(strcat([csvData{i,1} "," csvData{i,2} "\n"]))
        mfprintf(RESU2,strcat([csvData{i,1} "," csvData{i,2} "," csvData{i,3} "," csvData{i,4} "," csvData{i,5} "\n"]));
    end
    mfprintf(RESU2,'\n\n');
    mclose(RESU2);
