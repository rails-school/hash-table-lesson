class DynamicArrayHash
  LOAD_FACTOR = 0.7

  def initialize
    @size  = 10
    @count = 0
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
    @count += 1
    resize if (@count.to_f / @size > LOAD_FACTOR)

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
    @count = 0
    @size *= 2
    old_array.each do |dynamic_array|
      if dynamic_array
        dynamic_array.each do |k, v|
          self[k] = v
        end
      end
    end
  end
end
