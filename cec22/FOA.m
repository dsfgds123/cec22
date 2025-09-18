% 果蝇优化算法
function [Best_pos, Best_fitness, Iter_curve, History_pos, History_best, BestX, BestY] = FOA(pop, dim, ub, lb, fobj, maxIter)
%pop 种群数量
%dim 问题维数
%ub 变量上边界
%lb 变量下边界
%maxIter 最大迭代次数
%ouput
%Best_pos 全局果蝇最优位置
%Best_fitness 全局最优位置对应的适应度值
%Iter_curve 每代最优适应度值
%History_pos 每代果蝇种群位置
%History_best 每代最优果蝇位置
%BestX 最优果蝇位置X距离
%BestY 最优果蝇位置Y距离
%% 算法初始化
% 果蝇位置初始化 
for i = 1:dim
    X_axis(:,i) = lb(i)+rand(pop,1)*(ub(i)-lb(i));
    Y_axis(:,i) = lb(i)+rand(pop,1)*(ub(i)-lb(i));
end
% 最优适应度值初始化
Best_fitness = inf;
% 参数初始化
X = zeros(pop, dim);
Y = zeros(pop, dim);
S = zeros(pop, dim);
Dist = zeros(pop, dim);
Smell = zeros(1, pop);
Iter_curve = zeros(1, maxIter);
%% 迭代
for t = 1:maxIter
    for i = 1:pop
        % 果蝇通过气味确定食物方向
        X(i,:) = X_axis(i,:) + 2 * rand(1, dim) - 1;
        Y(i,:) = Y_axis(i,:) + 2 * rand(1, dim) - 1;
        % 计算距离
        Dist(i,:) = (X(i,:).^2 + Y(i,:).^2).^0.5;
        S(i,:) = 1./Dist(i,:);
        % 检查边界
        Flag4ub=S(i,:)>ub;
        Flag4lb=S(i,:)<lb;
        S(i,:)=(S(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        % 计算浓度
        Smell(i) = fobj(S(i,:));
    end
    % 最优适应度值&位置
    [bestSmell, bestIndex] = min(Smell);
    % 保存位置
    for i = 1:pop
        X_axis(i,:) = X(bestIndex,:);
        Y_axis(i,:) = Y(bestIndex,:);
    end
    if bestSmell < Best_fitness
        Best_fitness = bestSmell;
        Best_pos = S(bestIndex,:);
    end
    BestXTemp = X(bestIndex,:);
    BestYTemp = Y(bestIndex,:);
    %记录距离值
    History_pos{t} = S;
    History_best{t} = Best_pos;
    BestX{t} = BestXTemp;
    BestY{t} = BestYTemp;
    Iter_curve(t) = Best_fitness;
end
end
