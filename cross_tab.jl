function create_cross_tabulation(data, cates)
    mm = sum(cates)
    cross_tab = zeros(mm, mm)

    # 各カテゴリの開始インデックスを計算
    start_indices = [1]
    #for i in 2:axes(cates)
    for i in 2:length(cates)
        push!(start_indices, start_indices[end] + cates[i-1])
    end

    # data行列を走査して集計表を更新
    for row in axes(data, 1)
        for i in axes(data, 2)
            for j in axes(data, 2)
                # インデックス範囲のチェック
                if data[row, i] > cates[i] || data[row, j] > cates[j]
                    println("エラー: data[$row, $i] または data[$row, $j] がカテゴリ数を超えています。")
                    return
                end
                index_i = start_indices[i] + data[row, i] - 1
                index_j = start_indices[j] + data[row, j] - 1
                cross_tab[index_i, index_j] += 1
            end
        end
    end

    return cross_tab
end

# 例: data行列とカテゴリ数の配列を用いた関数の呼び出し

data=[
    1 1 1 2 1
    1 3 2 1 2
    2 1 1 1 1
    3 4 2 2 2
    1 4 1 1 1
    2 3 2 2 2
    2 1 1 1 1
    1 3 1 2 2
    3 2 2 2 3
    1 1 2 1 2
    3 1 1 1 3
    2 3 1 2 1
    2 1 2 2 2
    1 3 2 2 1
    3 2 1 1 3
    2 4 1 1 3
    1 2 2 1 1
    2 1 2 1 3
    3 1 1 2 1
    2 2 1 1 2]

cates =[3,4,2,2,3]

# 例: data行列とカテゴリ数の配列を用いた関数の呼び出し
cross_tab = create_cross_tabulation(data, cates)
