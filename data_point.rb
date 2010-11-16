class DataPoint
  attr_reader :label, :attributes
  def initialize(label, attributes)
    @label = label
    @attributes = attributes
  end
  
  def get_text_attr_values
    @attributes
  end
end
