%*****************************************************************************************************************************************************
% Authors: Behrouz Ahadzadeh, Moloud Abdar, Mahdieh Foroumandi, Fatemeh Safara, Abbas Khosravi,  Salvador García and Ponnuthurai Nagaratnam Suganthan
% Last Edited: May 5, 2024
% Email: b.ahadzade@yahoo.com ; m.abdar1987@gmail.com
% Reference: "UniBFS: A Novel Uniform-solution-driven Binary Feature Selection Algorithm for High-Dimensional Data" 
%****************************************************************************************************************************************************


clear all
close all
clc;


% % Select a data set from the list
Datasets_list = {'colon','smk_can_187', '9_tumor','brain_tumor_2','breast_cancer','glioma','cns','bladder','leukemia_3'};

[Data_ID ] = read_data(Datasets_list );
selection_method = Datasets_list{Data_ID};




switch lower(selection_method)



    case 'colon'
        dat1=load('colon.mat');
        data_train_2=(dat1.data(:,2:end));
        data_train_label_2=dat1.data(:,1);
        dataset=[data_train_2 data_train_label_2];


    case '9_tumor'
        dat1=load('9_Tumor.mat');
        data_train_2=(dat1.X(:,2:end));
        data_train_label_2=dat1.Y(:,1);
        dataset=[data_train_2 data_train_label_2];


    case 'brain_tumor_2'
        dat1=load('Brain_Tumor_2.mat');
        data_train_2=(dat1.data(:,2:end));
        data_train_label_2=dat1.data(:,1);
        dataset=[data_train_2 data_train_label_2];



    case 'breast_cancer'
        dat1=load('Breast.mat');
        data_train_2=(dat1.M(:,2:end-1));
        data_train_label_2=dat1.M(:,end);
        dataset=[data_train_2 data_train_label_2];

    case 'glioma'
        dat1=load('GLIOMA.mat');
        data_train_2=(dat1.X(:,2:end));
        data_train_label_2=dat1.Y(:,1);
        dataset=[data_train_2 data_train_label_2];

    case 'smk_can_187'
        dat1=load('SMK_CAN_187 .mat');
        data_train_2=(dat1.X(:,2:end));
        data_train_label_2=dat1.Y(:,1);
        dataset=[data_train_2 data_train_label_2];

    case 'bladder'
        dat1=load('Bladder_GSE31189.mat');
        data_train_2=(dat1.M(:,2:end-1));
        data_train_label_2=dat1.M(:,end);
        dataset=[data_train_2 data_train_label_2];

    case 'cns'
        dat1=load('CNS.mat');
        data_train_2=(dat1.data(:,2:end));
        data_train_label_2=dat1.data(:,1);
        dataset=[data_train_2 data_train_label_2];

    case 'leukemia_3'
        dat1=load('Leukemia_3.mat');
        data_train_2=(dat1.X(:,2:end));
        data_train_label_2=dat1.Y(:,1);
        dataset=[data_train_2 data_train_label_2];


    otherwise
        disp('Unknown method.')
end




Input=dataset(:,1:end-1);
Target=dataset(:,end);


Input=zscore(Input);
tic
Max_FEs=6000;
Max_Run=2;




%% UniBFS Algorithm
tic;
[best_solution_psoitation,best_selected_gen,BestCost_UniBFS,SF_Best_Sol] =UniBFS(Max_FEs,Max_Run,Input,Target);
UniBFS_Time=toc;

Cost_UniBFS=mean(BestCost_UniBFS,2);
Mean_UniBFS=mean(BestCost_UniBFS(end,:));
Std_UniBFS=std(BestCost_UniBFS(end,:));
Worst_UniBFS=min(BestCost_UniBFS(end,:));
Best_UniBFS=max(BestCost_UniBFS(end,:));
AN_SF_UniBFS=mean(SF_Best_Sol(end,:));


%% UniBFS_ReliFish Algorithm
tic;
[best_solution_psoitation_UniBFS_ReliFish,best_selected_gen_UniBFS_ReliFish,BestCost_UniBFS_ReliFish,SF_Best_Sol_UniBFS_ReliFish] =UniBFS_ReliFish(Max_FEs,Max_Run,Input,Target);
UniBFS_ReliFish_Time=toc;

Cost_UniBFS_ReliFish=mean(BestCost_UniBFS_ReliFish,2);
Mean_UniBFS_ReliFish=mean(BestCost_UniBFS_ReliFish(end,:));
Std_UniBFS_ReliFish=std(BestCost_UniBFS_ReliFish(end,:));
Worst_UniBFS_ReliFish=min(BestCost_UniBFS_ReliFish(end,:));
Best_UniBFS_ReliFish=max(BestCost_UniBFS_ReliFish(end,:));
AN_SF_UniBFS_ReliFish=mean(SF_Best_Sol_UniBFS_ReliFish(end,:));



%% PSO Algorithm
NP = 20;

tic;
[Mean_Cost_PSO,Mean_CA_PSO,Std_Dev_PSO,AN_SF_PSO,Worst_CA_PSO,Best_CA_PSO] =PSO(NP,Max_FEs,Max_Run,Input,Target);
PSO_Time=toc;




disp('*************************UniBFS Algorithm**********************************');

disp(['Worst_CA : ' num2str(Worst_UniBFS)]);
disp(['Best_CA  : ' num2str(Best_UniBFS)]);
disp(['Mean_CA  : ' num2str(Mean_UniBFS)]);

disp(['Std_Dev  : ' num2str(Std_UniBFS)]);
disp(['AN_SF    : ' num2str(AN_SF_UniBFS)]);
disp(['Time     : ' num2str(UniBFS_Time)]);


disp('*************************UniBFS_ReliFish Algorithm**********************************');

disp(['Worst_CA : ' num2str(Worst_UniBFS_ReliFish)]);
disp(['Best_CA  : ' num2str(Best_UniBFS_ReliFish)]);
disp(['Mean_CA  : ' num2str(Mean_UniBFS_ReliFish)]);

disp(['Std_Dev  : ' num2str(Std_UniBFS_ReliFish)]);
disp(['AN_SF    : ' num2str(AN_SF_UniBFS_ReliFish)]);
disp(['Time     : ' num2str(UniBFS_ReliFish_Time)]);



disp('****************************PSO Algorithm **************************');

disp(['Worst_CA : ' num2str(Worst_CA_PSO)]);
disp(['Best_CA  : ' num2str(Best_CA_PSO)]);
disp(['Mean_CA  : ' num2str(Mean_CA_PSO)]);
disp(['Std_Dev  : ' num2str(Std_Dev_PSO)]);
disp(['AN_SF    : ' num2str(AN_SF_PSO)]);
disp(['Time     : ' num2str(PSO_Time)]);



figure(1);


plot(Mean_Cost_PSO,'-h','LineWidth',0.4,...
    'MarkerEdgeColor','#00FF00',...
    'MarkerFaceColor','#FFFFFF',...
    'Color' , '#00FF00',...
    'MarkerSize',4,'MarkerIndices',1:500:size(Mean_Cost_PSO,1))
hold on
plot(Cost_UniBFS,'->','LineWidth',0.4,...
    'MarkerEdgeColor','#0000FF',...
    'MarkerFaceColor','#FFFFFF',...
    'Color' , '#0000FF',...
    'MarkerSize',4,'MarkerIndices',1:500:size(Cost_UniBFS,1))
hold on
plot(Cost_UniBFS_ReliFish,'<-','LineWidth',0.4,...
    'MarkerEdgeColor','#FF0000',...
    'MarkerFaceColor','#FFFFFF',...
    'Color' , '#FF0000',...
    'MarkerSize',4,'MarkerIndices',1:500:size(Cost_UniBFS_ReliFish,1))

xlabel('Number of Fitness Evaluations');
ylabel('Classification Accuracy');

legend('PSO','UniBFS','UniBFS-ReliFish');



