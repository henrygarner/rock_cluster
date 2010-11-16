require 'matrix'
class LinkMatrix
  attr_reader :object_to_index_mapping
  def initialize(points, point_sim, th)
    @object_to_index_mapping = {}
    similarity_matrix = calculate_point_similarities(points, point_sim)
    init(points, similarity_matrix, th)
  end
  
  def calculate_point_similarities(points, point_sim)
    n = points.size
    
    sim_matrix = []
    n.times { |i| sim_matrix[i] = [] }
    puts sim_matrix.inspect
    
    points.each_with_index do |item_x, i|
      attributes_x = item_x.get_text_attr_values
      (i+1...n).each do |j|
        item_y = points[j]
        puts item_y
        attributes_y = item_y.get_text_attr_values
        sim_matrix[i][j] = point_sim.similarity(attributes_x, attributes_y);
        sim_matrix[j][i] = sim_matrix[i][j]
      end
      sim_matrix[i][i] = 1.0
    end
    puts sim_matrix.inspect
    sim_matrix
  end
  
  def init(points, similarity_matrix, th)
    n = points.length
    
    points.each_with_index do |p,i|
      puts "Setting object_to_index_mapping[#{p}] to #{i}"
      @object_to_index_mapping[p] = i
    end
    
    point_neighbour_matrix = []
    n.times { |i| point_neighbour_matrix[i] = [] }
    
    n.times do |i|
      (i+1...n).each do |j|
        point_neighbour_matrix[i][j] = (similarity_matrix[i][j] >= th) ? 1 : 0
         point_neighbour_matrix[j][i] = point_neighbour_matrix[i][j]
      end
      point_neighbour_matrix[i][i] = 1
    end
    
    point_link_matrix = []
    n.times { |i| point_link_matrix[i] = [] }
    
    n.times do |i|
      (i...n).each do |j|
        point_link_matrix[i][j] = n_links_between_points(point_neighbour_matrix, i, j)
        point_link_matrix[j][i] = point_link_matrix[i][j]
      end
    end
    
    @point_link_matrix = point_link_matrix
    @point_neighbour_matrix = point_neighbour_matrix
  end
  
  def n_links_between_points(neighbours, index_x, index_y)
    n_links = 0
    neighbours.first.size.times do |i|
      links = neighbours[index_x][i] * neighbours[i][index_y]
      n_links += links
    end
    n_links
  end
  
  def get_datapoint_links(x, y)
    puts "Getting links for #{x} and #{y}"
    @point_link_matrix[object_to_index_mapping[x]][object_to_index_mapping[y]]
  end
  
  # This is the cluster implementation, which wraps the data point implementation
  # May need to recurse deeply depending on cluster size
  def get_links(cluster_x, cluster_y)
    puts "Getting links for #{cluster_x} and #{cluster_y}"
    items_x = cluster_x.get_elements
    items_y = cluster_y.get_elements
    link_sum = 0
    items_x.each do |x|
      items_y.each do |y|
        if x.is_a? DataPoint and y.is_a? DataPoint
          link_sum += get_datapoint_links(x,y)
        else
          link_sum += get_links(x, y)
        end
      end
    end
    link_sum
  end
  
end