
% Ref: https://github.com/wangxb96/MEL

function cost = Fit_2(feat,label,X)

% Check if any feature exist
if sum(X == 1) == 0
  cost = 1;
else
  % Error rate
  error    = jwrapper_KNN(feat(:,X == 1),label);

    cost     = error; 

end
end


%---Call Functions-----------------------------------------------------
function error = jwrapper_KNN(sFeat,label)

Md = cvpartition(label, 'KFold', 5);
    for i = 1 : 5
        % Define training & validation sets
        testIdx = Md.test(i);
        xtrain   = sFeat(~testIdx,:); ytrain  = label(~testIdx);
        xvalid   = sFeat(testIdx,:);  yvalid  = label(testIdx);
        % Training model
        My_Model = fitcknn(xtrain,ytrain,'NumNeighbors',5); 
        % Prediction
        pred     = predict(My_Model,xvalid);
        % Accuracy
        Acc(i)   = sum(pred == yvalid) / length(yvalid);
    end
% Error rate
error    = mean(Acc)*100; 
end