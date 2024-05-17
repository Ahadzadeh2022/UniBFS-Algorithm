%*****************************************************************************************************************************************************
% Authors: Behrouz Ahadzadeh, Moloud Abdar, Mahdieh Foroumandi, Fatemeh Safara, Abbas Khosravi,  Salvador García and Ponnuthurai Nagaratnam Suganthan
% Last Edited: May 5, 2024
% Email: b.ahadzade@yahoo.com ; m.abdar1987@gmail.com
% Reference: "UniBFS: A Novel Uniform-solution-driven Binary Feature Selection Algorithm for High-Dimensional Data"
%****************************************************************************************************************************************************

% Redundant  Features  Elimination  algorithm(RFE)

function [BestCost,Best_sol,E,SF_Best_Sol] =RFE(Max_FEs,EFs,Run,Input,Target,BestCost,Fit_X,SF_Best_Sol)

CH_r= 0.01;
Max_FEs_LSA=Max_FEs;

nVar=size(Input,2);
X=ones(1,nVar);

Fit_X=Fit(Input(1:end-1,:),Target,X);

Max_FEs=EFs+Max_FEs_LSA;
while EFs <=Max_FEs


    EFs=EFs+1;
    X_New=X;
    [~,U_Index]=find(X==1);
    NUSF_X=size(U_Index,2);
    UN=ceil(NUSF_X*CH_r);
    UN=randperm(UN,1);
    K1=randi(NUSF_X,UN,1);
    K=U_Index(K1)';
    X_New(K)=0;


    Fit_X_New=Fit(Input(1:end-1,:),Target,X_New);




    if Fit_X_New>=Fit_X
        X=X_New;
        Fit_X=Fit_X_New;

    end



    BestCost(EFs,Run)=Fit_X;
    SF_Best_Sol(EFs,Run)=sum(X);



    disp(['RFE:   Function Evaluation: ' num2str(EFs) '  Accuracy = ' num2str(Fit_X) '  Number of Selected Features = ' num2str(sum(X)) ' Run: ' num2str(Run)]);

end
Best_sol=Input(end,logical(X));

E=EFs;

end


