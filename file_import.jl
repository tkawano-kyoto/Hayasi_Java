# ファイルパス（適宜変更してください）
filename = "data.txt"

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

    # 処理の例：データ行列の最初の行を出力
    println(data_matrix[1])
end
