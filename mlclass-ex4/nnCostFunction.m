function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% transpose input layer and output layer
% cost can be calculated using vectorized way
X_tran = [ones(m, 1) X];
Y_tran = zeros(m, num_labels);
for i = 1:m
	Y_tran(i, y(i)) = 1;
end

X_tran = X_tran';
Y_tran = Y_tran';

hidden = sigmoid(Theta1 * X_tran);
hidden = [ones(1,m);hidden];
output = sigmoid(Theta2 * hidden);

J_matrix = Y_tran .* log(output) + (1 - Y_tran) .* log(1 - output);
J = -1 * sum(J_matrix(:)) / m;

% Regularization
Theta1_sum = Theta1(:, 2:end) .* Theta1(:, 2:end);
Theta2_sum = Theta2(:, 2:end) .* Theta2(:, 2:end);
J = J + lambda * (sum(Theta1_sum(:)) + sum(Theta2_sum(:))) / (2 * m);


% using for loop to calculate derivative of theta
for i = 1:m;
	deta3 = output(:, i) - Y_tran(:, i);
	deta2 = (Theta2' * deta3) .* (hidden(:, i) .* (1 - hidden(:, i)));
	Theta2_grad = Theta2_grad + deta3 * hidden(:, i)';
	Theta1_grad = Theta1_grad + deta2(2:end) * X_tran(:, i)';
end
Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + lambda / m * Theta1(:, 2:end);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + lambda / m * Theta2(:, 2:end);

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
