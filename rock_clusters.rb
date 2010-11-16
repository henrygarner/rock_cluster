require 'similar_cluster'
class RockClusters
  
  attr_reader :link_matrix, :goodness_measure, :cluster_map
  
  def initialize(initial_clusters, link_matrix, goodness_measure)
    @link_matrix = link_matrix
    
    # Cluster maps are stored as hashes with integer keys
    # Arrays are not used because we need integer keys to be persistent
    @cluster_map = {}
    @similar_clusters_map = {}
    @next_key = 0
    @goodness_measure = goodness_measure
    
    initial_clusters.each do |cluster|
      add_cluster(cluster)
    end
    calculate_cluster_similarities
  end
  
  def size
    @cluster_map.size
  end
  
  def add_cluster(cluster)
    key = @next_key
    @cluster_map[key] = cluster
    @next_key += 1
  end
  
  def calculate_cluster_similarities
    @similar_clusters_map = {}
    get_all_keys.each do |cluster_key|
      similar_clusters = []
      cluster = get_cluster(cluster_key)
      get_all_keys.each do |similar_cluster_key|
        if (cluster_key != similar_cluster_key)
          similar_cluster = get_cluster(similar_cluster_key)
          n_links = link_matrix.get_links(cluster, similar_cluster)
          if (n_links > 0)
            goodness = goodness_measure.g(n_links, cluster.size, similar_cluster.size)
            similar_clusters.push SimilarCluster.new(similar_cluster_key, goodness)
          end
        end
      end
      set_similar_clusters(cluster_key, similar_clusters)
    end
  end
  
  def set_similar_clusters(key, list)
    list.each { |e| puts "sorting #{e}" }
    sorted_list = list.sort { |a,b| b.goodness <=> a.goodness }
    @similar_clusters_map[key] = list
  end
  
  def merge_best_candidates
    merge_candidates = find_best_merge_candidates
    goodness = nil
    if (merge_candidates.size > 1) 
      key_1 = merge_candidates.first
      key_2 = merge_candidates.last
      goodness = @similar_clusters_map[key_1].first.goodness
      
      merge_clusters(key_1, key_2)
    end
    goodness
  end

  # Finds a pair of cluster indexes with the best goodness measure.
  
  def find_best_merge_candidates
    best_key = nil
    best_similar_cluster = nil
    best_goodness = -1.0/0.0 # Negative infinity
    @similar_clusters_map.each do |key, similar_clusters|
      top_similar_cluster = similar_clusters.first
      if (top_similar_cluster && top_similar_cluster.goodness > best_goodness)
        best_goodness = top_similar_cluster.goodness
        best_key = key
        best_similar_cluster = top_similar_cluster
      end
    end
    best_merge_candidates = []
    if (best_key != nil)
      best_merge_candidates << best_key
      best_merge_candidates << best_similar_cluster.cluster_key
    end
    puts "Found best merge candidates #{best_merge_candidates}"
    best_merge_candidates
  end
  
  def merge_clusters(key_1, key_2)
    puts "Merging clusters #{key_1} and #{key_2}"
    cluster_1 = get_cluster(key_1)
    cluster_2 = get_cluster(key_2)
    
    cluster_3 = Cluster.new(cluster_1, cluster_2)
    remove_cluster(key_1)
    remove_cluster(key_2)
    key_3 = add_cluster(cluster_3)
    puts "Cluster 3's elements: #{cluster_3.get_elements}"
    calculate_cluster_similarities
    
    key_3
  end
  
  def remove_cluster(key)
    @cluster_map.delete key
  end
  
  def get_cluster(i)
    @cluster_map[i]
  end
  
  def get_all_keys
    @cluster_map.keys
  end
  
  def get_all_clusters
    @cluster_map
  end

  
  
end