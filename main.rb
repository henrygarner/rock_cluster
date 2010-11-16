require 'set'
require 'rock_algorithm'
require 'data_point'

    
a = ['1','2','3'].to_set
b = ['11','9','10'].to_set
c = ['11','9','10'].to_set
d = ['11','10','6'].to_set
e = ['5','6','7'].to_set

dps = [DataPoint.new('a', a), DataPoint.new('b', b), DataPoint.new('c', c), DataPoint.new('d', d), DataPoint.new('e',e)]

rock = RockAlgorithm.new(dps, 3, 0.2)

dnd = rock.cluster

puts '='*50
puts dnd.inspect
