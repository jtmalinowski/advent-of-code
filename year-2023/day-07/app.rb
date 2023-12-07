input_path = ARGV[0] || 'example'

SINGLE = %i[A K Q J T 9 8 7 6 5 4 3 2]
SINGLE2 = %i[A K Q T 9 8 7 6 5 4 3 2 J]

Hand = Struct.new(:cards, :bid) {
  def counts_power(counts)
    return 0 if counts[0][1] == 5
    return 1 if counts[0][1] == 4
    return 2 if counts[0][1] == 3 && counts[1][1] == 2
    return 3 if counts[0][1] == 3 
    return 4 if counts[0][1] == 2 && counts[1][1] == 2
    return 5 if counts[0][1] == 2
    return 6
  end

  def power
    counts_power cards.tally.sort{|a,b| [b[1],SINGLE.index(b[0])] <=> [a[1],SINGLE.index(a[0])] }
  end

  def power2
    tally = cards.tally
    j_count = tally[:J] || 0
    tally[:J] = 0
    counts = tally.sort{|a,b| [b[1],SINGLE.index(b[0])] <=> [a[1],SINGLE.index(a[0])] }
    counts[0][1] += j_count

    counts_power counts
  end

  def score
    [power, *cards.map{|c| SINGLE.index(c)}]
  end

  def score2
    [power2, *cards.map{|c| SINGLE2.index(c)}]
  end
}

hands = []

lines = File.open(input_path).to_a
lines.each_with_index do |line, idx|
  line = line.strip
  next if line.empty?

  if /([A-Z0-9]+) (\d+)/ =~ line
    hand = Hand.new $1.chars.map(&:to_sym), $2.to_i
    hands.push hand
  end
end

sum = 0
hands.sort_by!(&:score)
hands.each_with_index{|h,idx| sum += h.bid * (hands.size - idx) }
puts sum

sum = 0
hands.sort_by!(&:score2)
hands.each_with_index{|h,idx| sum += h.bid * (hands.size - idx) }
puts sum
