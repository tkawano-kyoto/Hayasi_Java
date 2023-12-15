#=     		
# 前提: n, m, ll, data, crossTab, y, y_data は適切に定義されていること

for i in 1:n
    for j in 1:m
        for j1 in 1:m
            pk = ll[j]
            pl = ll[j1]
            k = data[i, j]
            l = data[i, j1]
            crossTab[k + pk, l + pl] += 1
        end
    end
end

for i in 1:n
    for j in 1:m
        pk = ll[j]
        k = data[i, j]
        y[k + pk] += y_data[i]
    end
end
=#	
