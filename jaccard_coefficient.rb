class JaccardCoefficient
  
  def similarity(x, y)
    return 0.0 if x.size == 0 or y.size == 0
    set_x = x.to_set
    set_y = y.to_set
    union_xy = set_x | set_y
    intersection_xy = set_x & set_y
    intersection_xy.size.to_f / union_xy.size.to_f 
  end
  
end
