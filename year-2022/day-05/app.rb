input_path = ARGV[0]

Box = Struct.new(:val, :parent)
# BoxStack = Struct.new(:first, :last) do
#   @stack = []
#   def push
#     @stack.push
#     self
#   end
# end

parse_stacks = -> (line) {
  white_spaces = 0
  letter = nil
  boxes = []
  idx = 0

  line.split('').each do |c|
    if c == " "
      white_spaces += 1
    elsif c == "["
      idx += white_spaces / 4
      white_spaces = 0
    elsif c in 'A'..'Z'
      boxes[idx] = c
    elsif c == "]"
      idx += 1
    end
  end

  boxes
}

@stacks = Array.new{[]}
@stacks2 = Array.new{[]}

File.open(input_path).each do |line|

  if line.include? "["
    parse_stacks.call(line).each_with_index do |box,idx|
      next unless box
      @stacks[idx] ||= []
      @stacks2[idx] ||= []
      @stacks[idx].prepend box if box
      @stacks2[idx].prepend box if box
    end

    # puts "-------"
    # puts @stacks.map{|s| s&.join(' ') || " "}.join("\n")
    # puts "-------"
  elsif line.start_with? "move"
    match = line.match /move\s*(\d+)\s*from\s*(\d+)\s*to\s*(\d+)/
    len, from, to = match.captures.map(&:to_i)

    # adjust indexes
    from -= 1
    to -= 1

    @stacks[to] ||= []
    @stacks2[to] ||= []

    len.times{ @stacks[to].push @stacks[from].pop }

    @stacks2[to] += @stacks2[from].slice(-len, len)
    @stacks2[from] = @stacks2[from].slice(0, @stacks2[from].count - len)

    # puts "-------"
    # puts @stacks.map{|s| s&.join(' ') || " "}.join("\n")
    # puts "-------"
  end
end

puts @stacks.map{|s| s&.last }.compact.join("")
puts @stacks2.map{|s| s&.last }.compact.join("")
