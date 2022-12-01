is_test = ENV.fetch("AOC_TEST", "false").downcase == "true"
input_path = is_test ? "input-test" : "input"

@single_elf_sum = 0
@single_elf_max = 0
@top3 = []

def sumup_single()
  @single_elf_max = [@single_elf_sum, @single_elf_max].max

  @top3.append @single_elf_sum
  @top3 = @top3.sort.reverse.slice(0, 3)

  @single_elf_sum = 0
end

File.open(input_path).each do |line|
  if line.strip.empty?
    sumup_single
    next
  end

  @single_elf_sum += line.to_i
end

sumup_single

puts "Single biggest: #{@single_elf_max}"
puts "Top 3 biggest: #{@top3.sum}"
