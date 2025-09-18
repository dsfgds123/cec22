%--------------------------------------------------------------------------
% 主函数：用于测试和比较FA, PSO, GWO, HADEGWO在CEC2022测试函数上的性能
% (已修复边界（lb, ub）格式问题)
%--------------------------------------------------------------------------
clear, clc, close all

% --- 1. 参数设置 ---
SearchAgents_no = 30; % 种群大小
Max_iteration = 500; % 最大迭代次数
Function_name = 'F1'; % 测试函数名称, 可选 'F1' 到 'F12'
dim = 10;             % 问题的维度

% --- 2. 获取测试函数信息 ---
[lb, ub, ~, fobj] = Get_CEC2022_details(Function_name, dim);

% ========================== FIX START ===================================
% 问题修复：检查lb和ub是否为标量，如果是，则将其扩展为与维度匹配的向量。
% 这是因为初始化函数期望ub和lb是向量，以便为每一维设置边界。
if isscalar(lb)
    lb = ones(1, dim) * lb;
end
if isscalar(ub)
    ub = ones(1, dim) * ub;
end
% =========================== FIX END ====================================

% --- 3. 运行四种优化算法 ---

% 3.1 运行萤火虫算法 (FA)
disp('Running FA...');
[Best_score_FA, Best_pos_FA, Convergence_curve_FA] = FA(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% 3.2 运行粒子群算法 (PSO)
disp('Running PSO...');
[Best_score_PSO, Best_pos_PSO, Convergence_curve_PSO] = PSO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% 3.3 运行灰狼优化器 (GWO)
disp('Running GWO...');
[Best_score_GWO, Best_pos_GWO, Convergence_curve_GWO] = GWO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% 3.4 运行混合算法 (HADEGWO)
disp('Running HADEGWO...');
[Best_score_HADEGWO, Best_pos_HADEGWO, Convergence_curve_HADEGWO] = HADEGWO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);

% --- 4. 结果展示与绘图 ---

% 4.1 在命令窗口显示结果
disp(['Function: ', Function_name, ', Dimension: ', num2str(dim)]);
disp(['FA Best Score: ', num2str(Best_score_FA)]);
disp(['PSO Best Score: ', num2str(Best_score_PSO)]);
disp(['GWO Best Score: ', num2str(Best_score_GWO)]);
disp(['HADEGWO Best Score: ', num2str(Best_score_HADEGWO)]);

% 4.2 绘制收敛曲线对比图
figure('Position',[500 300 700 450])

% 使用 semilogy 可以更好地观察数量级的变化
semilogy(1:Max_iteration, Convergence_curve_FA, 'Color', 'r', 'LineWidth', 1.5);
hold on
semilogy(1:Max_iteration, Convergence_curve_PSO, 'Color', 'g', 'LineWidth', 1.5);
semilogy(1:Max_iteration, Convergence_curve_GWO, 'Color', 'b', 'LineWidth', 1.5);
semilogy(1:Max_iteration, Convergence_curve_HADEGWO, 'Color', 'k', 'LineWidth', 1.5);

title(['Convergence Curve on ', Function_name, ' (Dim=', num2str(dim), ')']);
xlabel('Iteration');
ylabel('Best score (log scale)');
legend('FA', 'PSO', 'GWO', 'HADEGWO');
grid on;
box on;
hold off;