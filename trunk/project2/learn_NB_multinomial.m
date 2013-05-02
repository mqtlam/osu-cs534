function [ likelihood, prior ] = learn_NB_multinomial( trainData, trainLabels, nClasses, vocabMap )

%TRAIN_NB_MULTINOMIAL Trains a Naive Bayes classifier with Multinomial model.
%
%   trainData:      training data, [docId wordId count] columns
%   trainLabels:    training labels
%   nClasses:       number of classes
%   vocabMap:       mapping from original vocabulary to new vocabulary
%   likelihood:     likelihood probabilities, VxKx2 matrix
%                       V vocabulary size, K classes, 2 for x_i=1 or 0
%                       3rd dim: 1 = p_{x_i=1|y=k}, 2 = p_{x_i=0|y=k}
%   prior:          prior probabilities, K vector
%                       K classes

%% initialization
% dictionary size
dictSize = sum(vocabMap ~= 0);

% likelihood probabilities, p_{x_i=1/0|y=k}
%   3rd dim: 1 = p_{x_i=1|y=k}, 2 = p_{x_i=0|y=k}
%   x in dictSize, y in nClasses
%   note: stores the log of probabilities
likelihood = zeros(dictSize, nClasses, 2);

% prior probabilities, p(y=k)
%   y in nClasses
%   note: stores the log of probabilities
prior = zeros(nClasses, 1);

% counts of examples per class in training data
nClassExamples = zeros(nClasses, 1);

% counts of particular word appearing per class in training data
nWordsPerClass = zeros(dictSize, nClasses);

% total number of training examples
nExamples = size(trainData, 1);

%% accumulate sums to compute probabilities later
for i = 1:nExamples
    docId = trainData(i, 1);
    wordId = trainData(i, 2);
    wordId = vocabMap(wordId); % vocabulary mapping
    count = trainData(i, 3); % not needed for bernoulli model
    class = trainLabels(docId);
    
    if wordId == 0 % vocabulary mapping
        continue;
    end
    
    nClassExamples(class) = nClassExamples(class)+count;
    nWordsPerClass(wordId, class) = ...
        nWordsPerClass(wordId, class)+count;
end

%% compute prior probabilities and likelihood probabilities
for class = 1:nClasses
    %% prior probabilities
    % note: log(x/y) = log(x) - log(y)
    prior(class) = log(nClassExamples(class)) - log(nExamples);
    
    %% likelihood probabilities
    % p_{x_i=1|y=k}:
    % uses Laplace smoothing
    likelihood(:, class, 1) = ...
        log( (nWordsPerClass(:, class)+1) )...
        - log( (nClassExamples(class)+nClasses) );
    
    % p_{x_i=0|y=k}:
    % uses Laplace smoothing
    % note: log(1-x/y) = log(y-x) - log(y)
    likelihood(:, class, 2) = ...
        log( (nClassExamples(class)+nClasses) - (nWordsPerClass(:, class)+1) )...
        - log( (nClassExamples(class)+nClasses) );
end


end

