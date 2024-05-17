function [Mean_Cost,Mean_CA,Std_Dev,AN_SF,Worst_CA,Best_CA] =PSO(NP,Max_FEs,Max_Run,Input,Target)


Cost=zeros(Max_FEs,Max_Run);
FN=zeros(Max_Run,1);

Run=1;
nVar=size(Input,2);   % Number of Decision Variables
VarSize=[1 nVar];     % Size of Decision Variables Matrix

VarMin=-3;            % Lower Bound of Variables
VarMax= 3;            % Upper Bound of Variables

lu_v = 3 * [-ones(1, nVar); ones(1, nVar)];

% PSO Parameters

nPop=NP;              % Population Size (Swarm Size)
c1=1.5;               % Personal Learning Coefficient
c2=2;                 % Global Learning Coefficient

while Run <=Max_Run
    
    EFs=1;
    
    
    empty_particle.Position=[];
    empty_particle.Cost=[];
    empty_particle.Velocity=[];
    empty_particle.Best.Position=[];
    empty_particle.Best.Cost=[];
    
    particle=repmat(empty_particle,nPop,1);
    
    GlobalBest.Cost=0;
    
    for i=1:NP
        particle(i).Velocity=unifrnd(VarMin,VarMax,VarSize);
        
        
    end
    

    
    for i=1:nPop
        
        % Initialize Velocity
        SS = 1 ./ (1 + exp(-particle(i).Velocity));
        R=rand(1,nVar);
        particle(i).Position= R < SS;
        particle(i).Cost=Fit(Input,Target,particle(i).Position);
        
        % Update Personal Best
        particle(i).Best.Position=particle(i).Position;
        particle(i).Best.Cost=particle(i).Cost;
        
        % Update Global Best
        if particle(i).Best.Cost>GlobalBest.Cost
            
            GlobalBest=particle(i).Best;
            
        end
        
    end
    

    
    %% PSO Main Loop
    
    while EFs <=Max_FEs
        
        
        
        
        for i=1:nPop
            
            
            % Update Velocity
            particle(i).Velocity = 1*particle(i).Velocity ...
                +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
                +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
            
            
            V_u =lu_v(2, :);
            particle(i).Velocity= (particle(i).Velocity > V_u) .* V_u + (particle(i).Velocity<= V_u) .*particle(i).Velocity;
            particle(i).Velocity= (particle(i).Velocity < -V_u) .* (-V_u) + (particle(i).Velocity>= -V_u) .*particle(i).Velocity;
            
            
            SS = 1 ./ (1 + exp(-particle(i).Velocity));
            R=rand(1,nVar);
            particle(i).Position= R < SS;
            
            
            
            % Evaluation
            particle(i).Cost =Fit(Input,Target,particle(i).Position);
            
            % Update Personal Best
            if particle(i).Cost>particle(i).Best.Cost
                
                particle(i).Best.Position=particle(i).Position;
                particle(i).Best.Cost=particle(i).Cost;
                
                % Update Global Best
                if particle(i).Best.Cost>GlobalBest.Cost
                    
                    GlobalBest=particle(i).Best;
                end
                
            end
            
        end
        Z=EFs+NP;
        Cost(EFs:Z,Run)=GlobalBest.Cost;
        
        disp(['PSO :   '  'Function Evaluation: ' num2str(EFs) '   Accuracy = ' num2str(GlobalBest.Cost) '   Number of Selected Features = ' num2str(sum(GlobalBest.Position)) '   Run: ' num2str(Run)]);
        
        EFs=EFs+NP;
        
    end
    FN(Run,1)=sum(GlobalBest.Position);
    
    Run=Run+1;
end


Mean_Cost=mean(Cost(1:Max_FEs,:),2);
Mean_CA=mean(Cost(end,:));
Std_Dev=std(Cost(end,:));
AN_SF=mean(FN);
Worst_CA=min(Cost(end,:));
Best_CA=max(Cost(end,:));



end


