class SimilarCluster
  
  attr_reader :cluster_key, :goodness
  
  def initialize(cluster_key, goodness = 0.0)
    @cluster_key = cluster_key
    @goodness = goodness 
  end
  
  def goodness
    @goodness
  end
  
  def self.sort_by_goodness(values)
    values.sort do |one, another|
      # Sort descending
      another.goodness <=> one.goodess
    end
  end

  
end
