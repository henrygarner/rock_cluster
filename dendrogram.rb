require 'cluster_set'
class Dendrogram
  
  attr_reader :next_level
  
  def initialize(level_label_name)
    @level_label_name = level_label_name
    @next_level = 0
    @entry_map = []
    @level_labels = []
  end
  
  def add_level(label, clusters)
    
    cluster_set = ClusterSet.new
    clusters.each do |cluster|
      cluster_set.add(cluster.clone)
    end
    
    level = next_level
    
    @entry_map[level] = cluster_set
    @level_labels[level] = label
    
    @next_level += 1
    
  end
  
  def inspect
    str = ''
    @level_labels.size.times do |i|
      str << "Cluster #{i}: Goodness #{@level_labels[i]}\n"
      str << @entry_map[i].inspect
      str << "\n"
    end
    str
  end
  
end
