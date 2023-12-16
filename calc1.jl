   		
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


# 前提: m, ll, y, crossTab は適切に定義されていること

v1 = []
v = []

for jj in 1:m
    if jj == 1
        l1 = ll[jj]; l2 = ll[jj+1]
    else
        l1 = ll[jj]+1; l2 = ll[jj+1]
    end
    for i in l1:l2-1
        push!(v1, y[i])
        for ii in 1:m
            if ii == 1
                k1 = ll[ii]; k2 = ll[ii+1]
            else
                k1 = ll[ii]+1; k2 = ll[ii+1]
            end
            for j in k1:k2-1
                push!(v, crossTab[i, j])
            end
        end
    end
end

