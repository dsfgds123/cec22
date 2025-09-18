function [lb, ub, dim, fobj] = cec22_test_func_details(func_name, dim)
    % 从 'F1', 'F2' 等格式中提取函数编号
    f_num = sscanf(func_name, 'F%d');
    
    % 定义所有函数的通用边界
    lb = -100;
    ub = 100;
    
    % 定义函数句柄，注意输入x需要转置以适应cec22_test_func的要求
    fobj = @(x) cec22_test_func(x', f_num);
end