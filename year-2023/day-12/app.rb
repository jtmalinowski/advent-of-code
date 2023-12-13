input_path = ARGV[0] || 'example'

def recur(springs, arrangements, cache, hash_cont = false)
  key = springs + arrangements
  return cache[key] if cache[key]
  
  if springs == []
    return (cache[key] = 1) if arrangements == []
    return (cache[key] = 0) if arrangements.length > 1
    return (cache[key] = 0) if arrangements[0] > 0
    return (cache[key] = 1)
  end
  
  ch = springs[0]
  if ch == '.'
    return (cache[key] = 0) if hash_cont && arrangements[0] > 0

    if hash_cont && arrangements[0] == 0 &&
      arrangements = arrangements[1..-1]
    end

    return (cache[key] = recur(springs[1..-1], arrangements, cache, false))
  end

  if ch == '#'
    return (cache[key] = 0) if arrangements.length == 0
    return (cache[key] = 0) if arrangements[0] == 0

    arrangements = arrangements.clone
    arrangements[0] -= 1
    return (cache[key] = recur(springs[1..-1], arrangements, cache, true))
  end

  sum_dott = recur(['.'] + springs[1..-1], arrangements, cache, hash_cont)
  sum_hash = recur(['#'] + springs[1..-1], arrangements, cache, hash_cont)
  return (cache[key] = sum_dott + sum_hash)
end

sum = 0
sum2 = 0
@lines = File.open(input_path)
@lines.each_with_index do |line,idx|
  line = line.strip
  next if line.empty?

  puts idx
  match = line.match(/^([\.\?#]+) ([0-9,]+)$/)
  springs, arrangements = match[1], match[2]
  springs = springs.chars
  arrangements = arrangements.split(',').map(&:to_i)

  sum += recur(springs, arrangements, {})
  sum2 += recur(5.times.map{springs.join('')}.join('?').chars, arrangements * 5, {})
end
puts sum
puts sum2
