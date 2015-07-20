module TreeDelta::Sorter
  def self.sort(array, enumerator)
    sorted_array = []

    enumerator.each do |object|
      element = array.detect { |e| e.identity == object.identity }
      sorted_array << element if element
    end

    sorted_array
  end
end
