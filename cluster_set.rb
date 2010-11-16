require 'set'
class ClusterSet

  def initialize
    @all_clusters = Set[]
  end
  
  def add(cluster)
    @all_clusters.add cluster
  end
  
  def remove(cluster)
    @all_clusters.remove cluster
  end
  
  def inspect
    @all_clusters.collect do |cluster|
        cluster.inspect
    end.join("\n")
  end
  
end
