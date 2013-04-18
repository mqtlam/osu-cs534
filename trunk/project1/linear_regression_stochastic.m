function [ w, plot ] = linear_regression_stochastic( X, y )
%LINEAR_REGRESSION_BATCH Batch training for linear regression.
%   X:      MxN training matrix
%               M training examples
%               N dimensions (no bias term)
%   y:      Mx1 matrix of target predictions
%   w:      learned weight/parameter vector
%   plot:   vector of SSE for each step 

[nExamples, nFeatures] = size(X);

% constants
LEARNING_RATE = 1/nExamples;
EPSILON = 0.0001;

% augment X with bias terms
X_aug = [X ones(nExamples,1)];

% initialize parameters
w = zeros(nFeatures + 1, 1);
w_prev = w;

% main loop
step = 1;
while (1)
    % shuffle rows
    aug = [X_aug y];
    aug = shuffle_rows(aug);
    X_aug = aug(:, 1:end-1);
    y = aug(:, end);
    
    for i = 1:nExamples
        [plot(step), gradient] = SSE_loss(predict_target(X_aug(i, :), w), y(i, :), X_aug(i, :));
        w = w - LEARNING_RATE*gradient;
    end
    
    step = step + 1;
    if norm(w_prev-w) < EPSILON
        break;
    end
    w_prev = w;
end

end
