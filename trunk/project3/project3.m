%% Main script

%% load data
train = importdata('data/SPECT-train.csv');
trainLabels = train.data(:, 1);
trainData = train.data(:, 2:end);

test = importdata('data/SPECT-test.csv');
testLabels = test.data(:, 1);
testData = test.data(:, 2:end);

clearvars train test

%% constants
ensembleSizes = [5, 10, 15, 20, 25, 30];

%% bagging
%TODO

%% AdaBoost
trainingErrors = zeros(length(ensembleSizes), 1);
testingErrors = zeros(length(ensembleSizes), 1);

% experiment over different ensemble sizes
for i = 1:length(ensembleSizes)
    ensembleSize = ensembleSizes(i);
    
    % learn ensemble hypothesis
    hypothesis = learnAdaBoost(trainData, trainLabels, ensembleSize);
    
    % test on training examples
    predictedTrainingLabels = inferAdaBoost(trainData , hypothesis);
    trainingErrors(i) = sum(predictedTrainingLabels ~= trainLabels)/size(trainLabels, 1);
    
    % test on test examples
    predictedTestingLabels = inferAdaBoost(testData , hypothesis);
    testingErrors(i) = sum(predictedTestingLabels ~= testLabels)/size(trainLabels, 1);
end

% plot training and testing errors
plot(ensembleSizes, trainingErrors, 's--');
xlabel('Ensemble Size');
ylabel('Training Error');
title('AdaBoost: Training Error vs. Ensemble Size');
pause;

plot(ensembleSizes, testingErrors, 's--');
xlabel('Ensemble Size');
ylabel('Test Error');
title('AdaBoost: Test Error vs. Ensemble Size');
pause;
