class DynamicArrayHash
  def initialize
    @size  = 10
    @array = []
  end

  def [](key)
    dynamic_array = @array[hash(key)]
    if dynamic_array
      kv_pair = dynamic_array.find { |el|
        el[0] == key
      }
      kv_pair[1] if kv_pair
    end
  end

  def []=(key, value)
    n = hash(key)
    dynamic_array = @array[n]
    if @array[n]
      @array[n] |= [ [key, value] ]
    else
      @array[n] = [ [key, value] ]
    end
  end

  private
  def hash(object)
    object.hash % @size
  end

  def resize
    old_array = @array
    @array = []
    @size *= 2
    old_array.each do |k, v|
      @array[hash[v[0]]] = v
    end
  end
end
