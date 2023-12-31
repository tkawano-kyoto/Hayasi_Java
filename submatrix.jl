# # 元の行列を定義
# array = [0 1 2 3 4 5 6 7 8 9;
#         10 11 12 13 14 15 16 17 18 19;
#          20 21 22 23 24 25 26 27 28 29]

# # 除外する列のインデックス
# exc_vec = [2, 4, 7]

# # 除外する列以外の列を選択
# submatrix = Array[:, setdiff(1:size(Array, 2), exclude_columns)]

# # 結果を表示
# println(submatrix)

# 元の行列
Array = [0 1 2 3 4 5 6 7 8 9;
         10 11 12 13 14 15 16 17 18 19;
         20 21 22 23 24 25 26 27 28 29]

# 抜き出す列のインデックス
include_columns = [2, 4, 7]

# 指定された列だけを含む行列を作成
selected_columns_matrix = Array[:, include_columns]

# 結果を表示
println(selected_columns_matrix)