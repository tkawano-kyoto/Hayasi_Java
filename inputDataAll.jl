# 定数定義
const DATA_MAX  = 1000
const ITEM_MAX  = 50
const ITEM_MAX4 = 100
const CATE_MAX  = 20
const EXP_MAX = 10

# InputError型を定義します。
struct InputError <: Exception
    msg::String
end

# InputDataAll型を定義します。
mutable struct InputDataAll
    dt::Vector{Float64}
    a::Matrix{Int}
    double_a::Matrix{Float64}
    y::Vector{Float64}
    cate::Vector{Int}
    In_Var::Vector{Int}
    PriData::Matrix{Float64}
    l::Vector{Int}
    n::Int
    ln::Int
    m1::Int
    n1::Int
    nn1::Int
    mm1::Int
    k::Int
    i::Int
    j::Int
    mmm::Int
    Gr::Vector{Int}
    flag::Int
    Type::Int
    dataType::String

    function InputDataAll(dt::Vector{Float64}, Type::Int)
        new(dt, zeros(Int, 0, 0), zeros(Float64, 0, 0), Float64[], Int[], Int[], zeros(Float64, 0, 0),
            Int[], length(dt), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Int[], 0, Type, "")
    end
end

# インスタンスメソッド ReadData と ReadData2 を定義する必要がありますが、これはかなり長くなるため、
# ここでは具体的なコードを省略します。ただし、以下のようにエラーチェックを行うことができます：

function check_bounds(x, bound, message)
    if x > bound
        throw(InputError(message))
    end
end

# 使用例:
# check_bounds(n, DATA_MAX, "Sample number $(n) must be smaller than $(DATA_MAX).")

# この関数はReadData関数内で、Javaの例外処理に相当するエラーチェックの部分に対応するところで使用します。

# ... ここにReadDataとReadData2の詳細な実装が続きます ...

# そして、インスタンスメソッドの代わりに、次のように関数を定義します。
# （以下は一例です）

function getM(data::InputDataAll)
    if data.Type == 2
        return data.mm1 + 1
    elseif data.Type == 4 && data.dataType == "SimilarMatrix"
        return data.m1
    else
        return data.mm1
    end
end

# 同様にgetN、getCate、getData、getDoubleData、getY、getItemName、getExtItem、getMmm、getGr、getFlag関数も定義する必要があります。

# nを取得
function getN(data::InputDataAll)
    return data.n
end

# カテゴリを取得
function getCate(data::InputDataAll)
    if data.Type == 2
        data.l[1:data.mm1] .= data.cate[data.In_Var[1:data.mm1] .- 1]
        data.l[data.mm1 + 1] = data.cate[data.nn1 - 1]
    else
        data.l .= data.cate[data.In_Var .- 1]
    end
    return data.l
end

# データ行列を取得
function getData(data::InputDataAll)
    for i in 1:data.n
        for j in 1:data.mm1
            data.a[i, j] = data.PriData[i, data.In_Var[j] - 1]
        end
        if data.Type == 2
            data.a[i, data.mm1 + 1] = data.PriData[i, data.nn1 - 1]
        end
    end
    return data.a
end

# double_a配列を取得
function getDoubleData(data::InputDataAll)
    return data.double_a
end

# yベクトルを取得
function getY(data::InputDataAll)
    return data.y
end

# In_Var配列（項目名）を取得
function getItemName(data::InputDataAll)
    return data.In_Var
end

# 外部項目を取得
function getExtItem(data::InputDataAll)
    return data.nn1
end

# mmmを取得（Type 2のときのカテゴリ数）
function getMmm(data::InputDataAll)
    return data.mmm
end

# グループ配列を取得（Type 3のとき）
function getGr(data::InputDataAll)
    return data.Gr
end

# フラグを取得
function getFlag(data::InputDataAll)
    return data.flag
end
