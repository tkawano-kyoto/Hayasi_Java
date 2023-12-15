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
            data_matrix
        )
    end
end

# 関数の使用例
filename = "data2.txt" # ファイル名は適宜変更
result=(inputData(filename))

data_count = result[1] # n → サンプル数。getN()
qualitative_count = result[2] # m1 → 定性データ数
quantitative_count = result[3] # n1 → 定量データ数 
category_counts = result[4] # cate[m1] →　 各定性データのカテゴリー数が入ったベクトル
explanatory_item_count =  result[5] # mm1 → 実際分析に使用する定性データ数。getM()
explanatory_columns = result[6] # In_Var[mm1]  →　実際に分析に使う定性データ項目の列番ベクトル
external_reference_column = result[7] # 外的基準データが入った列番号 #In_Var[mm1+1] 
data_matrix = result[8] # データ行列[n,m1+n1]

# 除外する列以外の列を選択
data = hcat(data_matrix...)'  # ベクトルを行列に。転置が必要。
data_final = data[:,explanatory_columns] # 実際に分析に供される行列　n x mm1 。getData()

# y[n] -> 外的基準値が入ったベクトル　
y = data[:,external_reference_column] # getY()


