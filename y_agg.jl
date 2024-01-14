function aggregate_category_data(data, y_data, selected_columns)
    total_categories = sum(selected_columns)
    category_sums = zeros(Int, total_categories)

    for i in axes(data, 1)
        for j in axes(data, 2)
            # 現在の列の開始インデックスを計算
            start_index = sum(selected_columns[1:j-1]) # + 1
            # カテゴリーインデックスを計算
            category_index = start_index + data[i, j]
            # category_sumsへの加算
            category_sums[category_index] += y_data[i]
        end
    end

    return category_sums
end


# 仮のデータセット
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

y_data = [2,1,5,6,3,2,6,3,5,2,10,4,3,1,9,10,3,4,6,6] # 他の y_data の値...
ll = [3,4,2,2,3] # 各カテゴリの数

aggregate_category_data(data, y_data, ll)
