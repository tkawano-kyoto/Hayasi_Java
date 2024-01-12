function aggregate_category_data(data, y_data, ll)
    category_sums = Dict{String, Int}()

    for i in 1:axes(data, 1)
        for j in 1:axes(data, 2)
            key = "Category $(j)-$(data[i, j])"
            category_sums[key] = get(category_sums, key, 0) + y_data[i]
        end
    end

    for i in 1:length(ll)
        for j in 0:(ll[i] - 1)
            key = "Category $(i)-$(j)"
            println("$key: ", get(category_sums, key, 0))
        end
    end
end

# 仮のデータセット
data = [
    0 1 2;
    1 0 1;
    0 2 1
    # 他の症例データ...
]

y_data = [10, 20, 30] # 他の y_data の値...
ll = [2, 3, 3] # 各カテゴリの数

aggregate_category_data(data, y_data, ll)
