require 'json'
require 'Set'

def run

  snafu_range = -> (digits_no) {
    digits_no.times.map{|i| 5.pow(i) * 2}.sum
  }

  val_snafu_map = { -2 => '=', -1 => '-', 0 => '0', 1 => '1', 2 => '2' }
  to_snafu = -> (num, force_digit = nil) {
    # puts "to_snafu #{num} #{force_digit}"
    
    if num >= -2 && num <= 2
      return val_snafu_map[num] unless force_digit
      return val_snafu_map[0] + to_snafu.call(num, force_digit - 1) if force_digit > 1
      return val_snafu_map[num]
    end

    if force_digit == nil
      most_digit = 1
      loop do
        hi = snafu_range.call(most_digit)
        lo = -hi
        # puts "lo hi #{lo} #{hi}"
        break if num >= lo && num <= hi
        return nil if most_digit > 20
        most_digit += 1
      end
    else
      most_digit = force_digit
    end
    
    ((-2)..(2)).each do |curr|
      rest = num - curr * 5.pow(most_digit - 1)
      next unless rest.abs <= snafu_range.call(most_digit - 1)
      # puts "num: #{num} c: #{curr} rest: #{rest} lower_range: #{snafu_range.call(most_digit - 1)}"
      return val_snafu_map[curr] + to_snafu.call(rest, most_digit - 1)
    end
  }

  snafu_val_map = { '2' => 2, '1' => 1, '0' => 0, '-' => -1, '=' => -2 }
  to_int = -> (num) {
    num.chars.reverse.each_with_index.reduce(0){ |acc,kv|
      val, idx = kv
      raise "unexpected char #{val}" unless snafu_val_map[val]
      acc + snafu_val_map[val] * 5.pow(idx)
    }
  }

  sum = 0
  File.open(ARGV[0]).map do |line|
    next if line.strip.empty?
    sum += to_int.call(line.strip)
    # puts to_int.call(to_snafu.call(line.strip.to_i))
  end
  puts to_snafu.call(sum)

end

run
