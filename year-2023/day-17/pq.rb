class PQ
  def initialize(min = false)
    @stack = []
    @min = min
  end

  def insert(item)
    @stack << item

    idx = @stack.length - 1
    loop do
      break if idx == 0

      target_idx = (idx - 1) / 2
      break if larger?(@stack[target_idx], @stack[idx])

      @stack[idx], @stack[target_idx] = @stack[target_idx], @stack[idx]
      idx = target_idx
    end
  end

  def pop()
    return nil if empty?

    res = @stack.first
    last = @stack.pop
    return res if empty?

    @stack[0] = last
    idx = 0
    
    loop do
      break if idx >= @stack.length
      
      left = (idx + 1) * 2 - 1
      break if left >= @stack.length

      right = (idx + 1) * 2
      target = if right >= @stack.length
        left
      else
        larger?(@stack[left], @stack[right]) ? left : right
      end
      break if larger?(@stack[idx], @stack[target])

      @stack[idx], @stack[target] = @stack[target], @stack[idx]
      idx = target
    end

    return res
  end

  def empty? = @stack.empty?

  def larger?(a,b) = if @min then (a <=> b) < 0 else (a <=> b) > 0 end
end
