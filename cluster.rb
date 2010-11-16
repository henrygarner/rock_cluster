require 'set'
class Cluster
  
  def initialize(*args)
    puts "Initializing cluster with args #{args.inspect}"
    @elements = Set[]
    args.each do |a|
      add(a)
    end
    puts "Cluster created with elements: #{get_elements.collect { |e| e.inspect }.join(', ')}"
  end
  
  def add(e)
    if e.is_a? Cluster
      e.get_elements.each do |element|
        puts "Adding element #{element}"
        @elements.add element
      end
    else
      puts "Adding element #{e}"
      @elements.add e
    end
  end
  
  def contains(e)
    @elements.include? e
  end
  
  def get_elements
    @elements
  end
  
  def size
    @elements.size
  end
  
end