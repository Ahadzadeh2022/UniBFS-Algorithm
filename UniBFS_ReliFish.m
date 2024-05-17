%*****************************************************************************************************************************************************
% Authors: Behrouz Ahadzadeh, Moloud Abdar, Mahdieh Foroumandi, Fatemeh Safara, Abbas Khosravi,  Salvador García and Ponnuthurai Nagaratnam Suganthan
% Last Edited: May 5, 2024
% Email: b.ahadzade@yahoo.com ; m.abdar1987@gmail.com
% Reference: "UniBFS: A Novel Uniform-solution-driven Binary Feature Selection Algorithm for High-Dimensional Data"
%****************************************************************************************************************************************************





function [best_solution_psoitation,best_selected_gen,BestCost,SF_Best_Sol] =UniBFS_ReliFish(Max_FEs,Max_Run,Input,Target)


NS_ch= 0.8;
C_t=500;
N_t=50;

Input1=Input;
counter=0;
Nvar=size(Input,2);
gen_number1=1:Nvar;
Input=[Input1;gen_number1];

BestCost=zeros(Max_FEs,Max_Run);
best_solution_psoitation=zeros(Max_Run,Nvar);
Run = 1;
SF_Best_Sol=zeros(Max_FEs,Max_Run);

[ranks,weights] = relieff(Input(1:end-1,:),Target,10);

idx=fsFisher(Input(1:end-1,:),Target);


Input1=Input;


while Run <=Max_Run
    EFs=0;


    X=randi([0,1],1,size(Input,2));
    Fit_X=Fit(Input(1:end-1,:),Target,X);

    X11=randi([0,1],1,size(Input,2));
    Fit_X11=0;

    X22=randi([0,1],1,size(Input,2));
    Fit_X22=0;

    for i=1:200
        X1=zeros(1,Nvar);
        rf=ranks(1,1:i);
        X1(1,rf)=1;
        Fit_X1=Fit(Input(1:end-1,:),Target,X1);
        if Fit_X1>Fit_X11
            X11=X1;
            Fit_X11=Fit_X1;
        end

        X2=zeros(1,Nvar);
        rf2=idx(1,1:i);
        X2(1,rf2)=1;
        Fit_X2=Fit(Input(1:end-1,:),Target,X2);
        EFs=EFs+1;
        if Fit_X2>Fit_X22
            X22=X2;
            Fit_X22=Fit_X2;
        end


        sol=[X11;X22;X];
        fit_sol=[Fit_X11 Fit_X22 Fit_X];
        [~,indexx]=sort(fit_sol);
        X=sol(indexx(1,3),:);
        Fit_X=fit_sol(indexx(1,3));

        BestCost(EFs:EFs+1,Run)=Fit_X;
        EFs=EFs+1;

        disp(['UniBFS_ReliFish: Function Evaluation: ' num2str(EFs) '   Accuracy = ' num2str(Fit_X) '   Number of Selected Features = ' num2str(sum(X)) '   Run: ' num2str(Run)]);

    end


    Nvar=numel(X);



    sol=[X11;X22;X];
    fit_sol=[Fit_X11 Fit_X22 Fit_X];
    [~,indexx]=sort(fit_sol);
    X=sol(indexx(1,3),:);
    Fit_X=fit_sol(indexx(1,3));


    while EFs <=Max_FEs

        EFs=EFs+1;



        X_New=X;

        if rand>NS_ch

            if rand>0.5

                [~,S_Index]=find(X==0);
                NSF_X=size(S_Index,2);
                SN=1;
                K1=randi(NSF_X,SN,1);
                X_New=X;
                K=S_Index(K1)';
                X_New(K)=1;

            else

                k=randperm(100,1);
                if rand>0.5
                    K=ranks(1,k);
                else
                    K=idx(1,k);
                end

                X_New=X;
                X_New(K)=1;

            end

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

        Fit_X_New=Fit(Input(1:end-1,:),Target,X_New);

        if Fit_X_New>Fit_X
            counter=0;
        else
            counter=counter+1;
        end



        if Fit_X_New>=Fit_X
            X=X_New;
            Fit_X=Fit_X_New;
        end


        BestCost(EFs,Run)=Fit_X;

        disp(['UniBFS_ReliFish:  Function Evaluation: ' num2str(EFs) '   Accuracy = ' num2str(Fit_X) '   Number of Selected Features = ' num2str(sum(X)) '   Run: ' num2str(Run)]);



        SF_Best_Sol(EFs,Run)=sum(X);




        %% Local Search
        if  counter>C_t  && sum(X)>N_t
            Input=Input1;

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
    best_solution_psoitation(Run,:)=X;
    Run = Run + 1;


end

BestCost=BestCost(1:Max_FEs,:);
SF_Best_Sol=SF_Best_Sol(1:Max_FEs,:);
best_selected_gen=Input(end,logical(X));


end


