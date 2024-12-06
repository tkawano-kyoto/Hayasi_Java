function inputData(filename)
    # ファイルを開き、各行を読み込む
    open(filename, "r") do file
        lines = readlines(file)
        filtered_lines = filter(!isempty, lines)

        # データ数
        data_count = parse(Int, filtered_lines[1])

        # 定性データ数と定量データ数
        qualitative_count, quantitative_count = parse.(Int, split(filtered_lines[2]))

        # 定性データのカテゴリー数
        category_counts = parse.(Int, split(filtered_lines[3]))

        # 分析に使う説明項目の数
        explanatory_item_count = parse(Int, filtered_lines[4])

        # 説明項目が入っているデータ行列の列番号
        explanatory_columns = parse.(Int, split(filtered_lines[5]))

        # 外的基準項目が入っているデータ行列の列番号
        external_reference_column = parse(Int, filtered_lines[6])

        # データ行列
        data_matrix = [parse.(Int, split(line)) for line in filtered_lines[7:end]]

        # 必要なデータを返す
        return (
            data_count,
            qualitative_count,
            quantitative_count,
            category_counts,
            explanatory_item_count,
            explanatory_columns,
            external_reference_column,
            data_matrix,
        )
    end
end

# 関数の使用例
filename = "data.txt" # ファイル名は適宜変更
result = (inputData(filename))

data_count = result[1] # n → サンプル数。getN()
qualitative_count = result[2] # m1 → 定性データ数
quantitative_count = result[3] # n1 → 定量データ数 
category_counts = result[4] # cate[m1] →　 各定性データのカテゴリー数が入ったベクトル
explanatory_item_count = result[5] # mm1 → 実際分析に使用する定性データ数。getM()
explanatory_columns = result[6] # In_Var[mm1]  →　実際に分析に使う定性データ項目の列番ベクトル
external_reference_column = result[7] # 外的基準データが入った列番号 #In_Var[mm1+1] 
data_matrix = result[8] # データ行列[n,m1+n1]



# 除外する列以外の列を選択
data = hcat(data_matrix...)'  # ベクトルを行列に。転置が必要。
data_final = data[:, explanatory_columns] # 実際に分析に供される行列　n x mm1 。getData()

# y[n] -> 外的基準値が入ったベクトル　
y = data[:, external_reference_column] # getY()

selected_columns = category_counts[explanatory_columns]

function create_cross_tabulation(data_final, selected_columns)
    mm = sum(selected_columns)
    cross_tab = zeros(mm, mm)

    # 各カテゴリの開始インデックスを計算
    start_indices = [1]
    #for i in 2:axes(cates)
    for i ∈ 2:length(selected_columns)
        push!(start_indices, start_indices[end] + selected_columns[i-1])
    end

    # data行列を走査して集計表を更新
    for row in axes(data_final, 1)
        for i in axes(data_final, 2)
            for j in axes(data_final, 2)
                # インデックス範囲のチェック
                if data_final[row, i] > selected_columns[i] ||
                   data_final[row, j] > selected_columns[j]
                    println("エラー: data[$row, $i] または data[$row, $j] がカテゴリ数を超えています。")
                    return
                end
                index_i = start_indices[i] + data_final[row, i] - 1
                index_j = start_indices[j] + data_final[row, j] - 1
                cross_tab[index_i, index_j] += 1
            end
        end
    end

    return cross_tab
end

A = create_cross_tabulation(data_final, selected_columns)


function aggregate_category_data(data_final, y, selected_columns)
    total_categories = sum(selected_columns)
    category_sums = zeros(Int, total_categories)

    for i in axes(data_final, 1)
        for j in axes(data_final, 2)
            # 現在の列の開始インデックスを計算
            start_index = sum(selected_columns[1:j-1])
            # カテゴリーインデックスを計算
            category_index = start_index + data_final[i, j]
            # category_sumsへの加算
            category_sums[category_index] += y[i]
        end
    end

    return category_sums
end

Y = aggregate_category_data(data_final, y, selected_columns)

function get_numeric_value(exp, ext)
    using LinearAlgebra

    # 引数
    v = A   # mm × mm の要素を持つ配列 (与えられるデータに置き換えてください)
    v1 = Y  # mm 要素のベクトル (与えられるデータに置き換えてください)
    m = explanatory_item_count   # 説明変数の数
    mm = length(Y)  # 総カテゴリー数

    # 初期化
    dt = Float64[]
    var = Float64[]
    yy = zeros(mm - m + 1)

    # dt と var に値をコピー
    for i = 1:length(v)
        push!(dt, v[i])
        push!(var, dt[i])
    end

    # dt1 と yy に値をコピー
    dt1 = Float64[]
    for i = 1:length(v1)
        push!(dt1, v1[i])
        yy[i] = dt1[i]
    end

    # 必要な配列の初期化
    x = zeros(mm - m + 1)
    xx = zeros(mm)
    numericValue = zeros(mm)
    temp = zeros(m)

    # matA の構築
    matA = zeros(Complex{Float64}, mm - m + 1, mm - m + 1)
    for i = 1:(mm-m+1)
        for j = 1:(mm-m+1)
            matA[i, j] = Complex(var[i+(j-1)*(mm-m+1)], 0.0)
        end
    end

    # matY の構築
    matY = zeros(Complex{Float64}, mm - m + 1, 1)
    for i = 1:(mm-m+1)
        matY[i, 1] = Complex(yy[i], 0.0)
    end

    # matX の計算
    matX = zeros(Complex{Float64}, mm - m + 1, mm - m + 1)
    try
        matX = matA \ matY  # matA の逆行列と matY を掛ける
    catch e
        println("Error in matrix operation: ", e)
    end

    # 実数部分の抽出
    m_x = real.(matX)
    for i = 1:(mm-m+1)
        x[i] = m_x[i, 1]
    end
end

# 関数呼び出し
# v1, v = get_numeric_value(A, Y, explanatory_item_count, selected_columns)

# println("size of V1 ",size(v1))
# println(v1)
# println("size of v ",size(v))
# println(v)

#2024/6/15 T.Kawano

using LinearAlgebra

# function solve_linear_equation(A, Y)
#     println("size of A ",size(A))
#     println("size of Y ",size(Y))
#     try
#         X = A \ Y
#         return X
#     catch e
#         println("Error solving the equation: ", e)
#         return nothing
#     end

# end

# x = solve_linear_equation(A, Y)
