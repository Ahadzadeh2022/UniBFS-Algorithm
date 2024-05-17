%*****************************************************************************************************************************************************
% Authors: Behrouz Ahadzadeh, Moloud Abdar, Mahdieh Foroumandi, Fatemeh Safara, Abbas Khosravi,  Salvador García and Ponnuthurai Nagaratnam Suganthan
% Last Edited: May 5, 2024
% Email: b.ahadzade@yahoo.com ; m.abdar1987@gmail.com
% Reference: "UniBFS: A Novel Uniform-solution-driven Binary Feature Selection Algorithm for High-Dimensional Data"
%****************************************************************************************************************************************************




function [best_solution_psoitation,best_selected_gen,BestCost,SF_Best_Sol] =UniBFS(Max_FEs,Max_Run,Input,Target)

Input1=Input;
counter=0;
Nvar=size(Input,2);
gen_number1=1:Nvar;
Input=[Input1;gen_number1];

BestCost=zeros(Max_FEs,Max_Run);

Run = 1;
SF_Best_Sol=zeros(Max_FEs,Max_Run);


Input1=Input;
while Run <=Max_Run

    EFs=0;
    X=randi([0,1],1,size(Input,2));
    Fit_X=Fit(Input(1:end-1,:),Target,X);
    Nvar=numel(X);

    while EFs <=Max_FEs

        EFs=EFs+1;



        X_New=X;

        if rand>0.8

            [~,S_Index]=find(X==0);
            NSF_X=size(S_Index,2);
            SN=1;
            K1=randi(NSF_X,SN,1);
            X_New=X;

            K=S_Index(K1)';
            X_New(K)=1;
        else
            nmu=ceil(rand*Nvar);

            j=randsample(Nvar,nmu);
            X_New(j)=0;
        end

        if (sum(X_New)==0)

            j=randsample(Nvar,1);
            X_New=X;
            X_New(j)=1;
        end


        % Evaluate X_New
        Fit_X_New=Fit(Input(1:end-1,:),Target,X_New);

        if Fit_X_New>Fit_X


            counter=0;
        else
            if EFs>2000
                counter=counter+1;
            end

        end



        if Fit_X_New>=Fit_X

            X=X_New;
            Fit_X=Fit_X_New;


        end


        BestCost(EFs,Run)=Fit_X;
        SF_Best_Sol(EFs,Run)=sum(X);

        disp(['UniBFS:  Function Evaluation: ' num2str(EFs) '   Accuracy = ' num2str(Fit_X) '   Number of Selected Features = ' num2str(sum(X)) '   Run: ' num2str(Run)]);





        %% Local Search
        if counter>500 && sum(X)>50


            [row,column1]=find(X==0);
            Input(:,column1)=[];

            Max_F=500;
            [BestCost,Best_Gene,EFs,SF_Best_Sol]=RFE(Max_F,EFs,Run,Input,Target,BestCost,Fit_X,SF_Best_Sol);
            Input=Input1;




            X=zeros(1,Nvar);
            X(1,Best_Gene)=1;
            Fit_X=Fit(Input(1:end-1,:),Target,X);
            counter=0;


        end

    end

    Run = Run + 1;


end

BestCost=BestCost(1:Max_FEs,:);
SF_Best_Sol=SF_Best_Sol(1:Max_FEs,:);
best_selected_gen=Input(end,logical(X));
best_solution_psoitation=X;


end


