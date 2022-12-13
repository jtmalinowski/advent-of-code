require 'json'

def run
  input_path = ARGV[0]

  compare = -> (left, right) {
    return left <=> right if left.is_a?(Integer) && right.is_a?(Integer)

    return compare.call([left], right) if left.is_a?(Integer)
    return compare.call(left, [right]) if right.is_a?(Integer)

    return -1 if left.count == 0 && right.count > 0

    left.each_with_index do |left_val, idx|
      return 1 if idx >= right.count

      res = compare.call(left_val, right[idx])
      return res if res == -1 || res == 1
    end

    return -1 if left.count < right.count
    return 0
  }

  sum = 0
  idx = 1
  buffer = []

  divider_1 = [[2]]
  divider_2 = [[6]]
  list = [divider_1, divider_2]

  File.open(input_path).each do |line|
    next if line.strip.empty?

    buffer.push eval(line.strip)
    list.push eval(line.strip)

    if buffer.count == 2
      sum += idx if compare.call(buffer[0], buffer[1]) == -1
      buffer = []
      idx += 1
    end
  end

  puts sum

  list.sort!(&compare)
  puts (list.find_index(divider_1) + 1) * (list.find_index(divider_2) + 1)
end

run
