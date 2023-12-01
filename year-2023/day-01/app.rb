is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
input_path = is_test ? "input-test" : "input"

def is_digit?(s)
  code = s.ord
  # 48 is ASCII code of 0
  # 57 is ASCII code of 9
  48 <= code && code <= 57
end

@sum = 0
@sum2 = 0

@literals = {
  "one": "1",
  "two": "2",
  "three": "3",
  "four": "4",
  "five": "5",
  "six": "6",
  "seven": "7",
  "eight": "8",
  "nine": "9",
}

File.open(input_path).each do |line|
  if line.strip.empty?
    next
  end

  first_digit = nil
  first_digit2 = nil
  last_digit = nil
  last_digit2 = nil

  (0...line.length).each do |idx|
    digit = (is_digit? line[idx]) ? line[idx] : nil
    if digit
      last_digit = digit
      first_digit = digit if first_digit == nil

      last_digit2 = digit
      first_digit2 = digit if first_digit2 == nil

      next
    end

    literal = @literals.keys.find{|k| line[0..idx].end_with? k.to_s}
    if literal
      last_digit2 = @literals[literal]
      first_digit2 = @literals[literal] if first_digit2 == nil
    end
  end

  @sum += "#{first_digit}#{last_digit}".to_i
  @sum2 += "#{first_digit2}#{last_digit2}".to_i
end

puts "Sum: #{@sum}"
puts "Sum2: #{@sum2}"
