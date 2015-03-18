class DynamicArrayHash
  LOAD_FACTOR = 0.7

  def initialize
    @size  = 10
    initialize_array
  end

  def [](key)
    slot_number = h(key)
    dynamic_array = @array[slot_number]
    kv_pair = dynamic_array.find { |pair|
      pair[0] == key
    }
    kv_pair[1] if kv_pair
  end

  def []=(key, value)
    @count += 1
    resize if (@count.to_f / @size > LOAD_FACTOR)

    slot_number = h(key)
    dynamic_array = @array[slot_number]
    kv_pair = dynamic_array.find { |pair|
      pair[0] == key
    }
    if kv_pair
      kv_pair[1] = value
    else
      @array[slot_number] << [key, value]
    end
  end

  private
  def h(object)
    object.hash % @size
  end

  def initialize_array
    @count = 0
    @array = Array.new(@size) { [] }
  end

  def resize
    old_array = @array
    @size *= 2
    initialize_array
    old_array.each do |dynamic_array|
      dynamic_array.each do |k, v|
        self[k] = v
      end
    end
  end
end
