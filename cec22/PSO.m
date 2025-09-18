function [Best_pos, Best_fitness, Iter_curve, History_pos, History_best] = PSO(pop, dim, ub, lb, fobj, vmax, vmin, maxIter)
%input
%pop 种群数量
%dim 问题维数
%ub 变量上边界
%lb 变量下边界
%fobj 适应度函数
%vmax 粒子速度上边界
%vmin 粒子速度下边界
%maxIter 迭代次数
%output
%Best_pos 粒子全局最优位置
%Best_fitness 全局最优位置对应的适应度函数值
%Iter_curve 每次迭代最优适应度值
%Histroy_pos 记录每代粒子群位置
%History_best 记录每代粒子群最优位置
if max(size(lb)) == 1
    lb = lb.*ones(1,dim);
    ub = ub.*ones(1,dim);
end
%% 设置学习因子c1,c2
c1 = 2;
c2 = 2.5;
w = 1;
wdamp = 0.99;
%% 初始化种群位置和速度
X = initialization(pop, ub, lb, dim);
V = initialization(pop, vmax, vmin, dim);
%% 计算适应度
fitness = zeros(1, pop);
for i = 1:pop
    fitness(i) = fobj(X(i,:));
end
%% 将初始种群记为历史最优值
pBest = X;
pBestFitness = fitness;
%% 记录初始全局最优值
% 寻找种群中适应度最小的位置
[~, index] = min(fitness);
gBestFitness = fitness(index); %全局最优fitness
gBest = X(index, :); %全局最优粒子位置
% 位置&适应度更新
Xnew = X;
fitnessNew = fitness;
Iter_curve = zeros(1, maxIter);
%% 开始迭代
for t = 1:maxIter
    for i = 1:pop
        % 对每个粒子速度更新
        r1 = rand(1, dim);
        r2 = rand(1, dim);
        V(i, :) = w*V(i, :) + c1 * r1 .* (pBest(i, :) - X(i, :)) + c2 * r2 .* (gBest - X(i, :));
        % 速度边界检查
        V(i, :) = BoundaryCheck(V(i,:), vmax, vmin, dim);
        % 位置更新&边界检查
        Xnew(i, :) = X(i, :) + V(i, :);
        Xnew(i, :) = BoundaryCheck(Xnew(i, :), ub, lb, dim);
        % 计算适应度
        fitnessNew(i) =  fobj(Xnew(i, :));
        % 更新粒子i历史最优值
        if fitnessNew(i) < pBestFitness(i)
            pBest(i, :) = Xnew(i, :);
            pBestFitness(i) = fitnessNew(i);
        end
        % 更新全局最优值
        if fitnessNew(i) < gBestFitness
            gBestFitness = fitnessNew(i);
            gBest = Xnew(i, :);
        end
    end

    w = w*wdamp;
    % 将上次迭代的位置和适应度当做本次迭代初始值
    X = Xnew;
    fitness = fitnessNew;
    % 记录最优位置和适应度
    Best_pos = gBest;
    Best_fitness = gBestFitness;
    Iter_curve(t) = gBestFitness;
    History_best{t} = Best_pos;
    History_pos{t} = X;
end
end
%%
function X = initialization(pop, ub, lb, dim)
%input
%pop 种群数量
%ub 每个纬度变量上边界
%lb 每个纬度变量下边界
%dim 问题纬度
%ouput
%X 输出种群，size为[pop, dim]
    for i = 1:pop
        for j = 1:dim
            X(i, j) = (ub(j) - lb(j)) * rand() + lb(j);
        end
    end
end
%%
function X = BoundaryCheck(x, ub, lb, dim)
%x 单个粒子
%ub 变量上边界
%lb 变量下边界
%dim 维数
     for i = 1:dim
         if x(i) > ub(i)
             x(i) = ub(i);
         end
         if x(i) < lb(i)
             x(i) = lb(i);
         end    
     end
     X = x;
end

    
