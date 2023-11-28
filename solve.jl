using LinearAlgebra
using Random

# 連立方程式計算
function solve_linear_system()
    n = 1000
    A = rand(ComplexF64, n, n)
    b = rand(ComplexF64, n)
    
    x = A \ b
    
    return x
end

x = solve_linear_system()

# 固有値と固有ベクトル計算
function compute_eigenvalues_and_vectors()
    A = [3.0 4.0 5.0; 2.0 3.0 4.0; 4.0 5.0 6.0]
    e = eigen(A)
    
    println("V =")
    println(round.(e.vectors, digits=5))
    
    println("D =")
    println(round.(Diagonal(e.values), digits=5))
end

compute_eigenvalues_and_vectors()
