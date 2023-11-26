# 必要なパッケージをインポートする
using DelimitedFiles

# "data.txt" ファイルを読み込み、その内容を data_array に格納する
function load_data(filename::String)
    # readdlm関数を使ってファイルを読み込み、デリミターに空白を指定する 
    return readdlm(filename, ' ';comment_char='#')

end

# 関数を呼び出してデータを読み込む
data_array = load_data("data.txt")

# 結果を表示する（オプション）
println(data_array)
