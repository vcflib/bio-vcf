module BioVcf

  module Variant

    def Variant.diff normal,tumor
      tumor.each_with_index.map {|t,i| t-normal[i]}
    end

    def Variant.threshold_diff t,normal,tumor
      normal2,tumor2 = apply_threshold(t,normal,tumor)
      diff(normal2,tumor2)
    end

    def Variant.relative_diff normal,tumor
      d = diff(normal,tumor)
      total = tumor.each_with_index.map {|t,i| t+normal[i]}
      total.each_with_index.map {|t,i| (t==0 ? 0 : ((d[i].to_f/t)*100.0).round/100.0)}
    end

    def Variant.relative_threshold_diff t,normal,tumor
      normal2,tumor2 = apply_threshold(t,normal,tumor)
      relative_diff(normal2,tumor2)
    end

    def Variant.index normal,tumor
      rd = relative_diff(normal,tumor) 
      max = rd.reduce(0){|mem,v| (v>mem ? v : mem) }
      rd.index(max)
    end

    def Variant.apply_threshold t,normal,tumor
      normal2 = normal.map{|v| (v>t ? 0 : v) }
      tumor2 = tumor.each_with_index.map{|v,i| (normal2[i]==0 ? 0 : v) }
      return normal2,tumor2
    end
  end

end
