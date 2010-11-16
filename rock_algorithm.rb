require 'jaccard_coefficient'
require 'link_matrix'
require 'cluster'
require 'dendrogram'
require 'merge_goodness_measure'
require 'rock_clusters'

class RockAlgorithm
  attr_reader :similarity_measure, :points, :th, :link_matrix, :k
  
  def initialize(points, k, th)
    @points = points
    @k = k
    @th = th
    similarity_measure = JaccardCoefficient.new
    @link_matrix = LinkMatrix.new points, similarity_measure, th
  end
  
  def cluster
    initial_clusters = []
    points.each do |point|
      initial_clusters.push Cluster.new(point)
    end
    
    dnd = Dendrogram.new 'Goodness'
    dnd.add_level('inf', initial_clusters)
    
    goodness_measure = MergeGoodnessMeasure.new th
    
    all_clusters = RockClusters.new initial_clusters, link_matrix, goodness_measure
    
    n_clusters = all_clusters.size
    
    while n_clusters > k
      n_clusters_before_merge = n_clusters
      g = all_clusters.merge_best_candidates
      n_clusters = all_clusters.size
      # No linked clusters to merge
      break if (n_clusters == n_clusters_before_merge)
      dnd.add_level(g.to_s, all_clusters.get_all_clusters)
      
      puts "Number of clusters: #{all_clusters.get_all_clusters.size}"
    end
    
    #all_clusters.cluster_map.each do |k, c|
    #  puts c.get_elements.inspect
    #end
    
    dnd
  end
  
end