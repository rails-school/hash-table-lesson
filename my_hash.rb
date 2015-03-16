class MyHash
  def initialize
    @size  = 10
    @array = []
  end

  def [](key)
    kv_pair = @array[slot_number(key)]
    kv_pair[1] if kv_pair
  end

  def []=(key, value)
    n = slot_number(key)
    @array[n] = [key, value]
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
      self[k] = v
    end
  end

  def slot_number(key)
    # Collision resolution via open addressing / linear probing
    initial_slot_number = slot_number = hash(key)
    loop do
      kv_pair = @array[slot_number]

      if !kv_pair || kv_pair[0] == key
        # Either this slot belongs to the key, or the slot is free
        return slot_number
      end

      slot_number = (slot_number + 1) % @size

      if slot_number == initial_slot_number
        # Uh oh, we wrapped around to where we started
        resize
        initial_slot_number = slot_number = hash(key)
      end
    end
  end
end
