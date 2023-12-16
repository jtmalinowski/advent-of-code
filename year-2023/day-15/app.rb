input_path = ARGV[0] || 'input-test'

def hash(str) = str.chars.reduce(0){|acc,ch| (acc+ch.ord)*17%256 }

cmds = File.open(input_path).to_a[0].split(',').map(&:strip)
puts cmds.map(&method(:hash)).reduce(:+)

boxes = 256.times.map{ {} }
cmds.each do |cmd|
  if match = cmd.match(/([a-z]+)=([0-9]+)/)
    raise "malformed file line" unless match&.captures&.count == 2
    label = match.captures[0]
    lens = match.captures[1].to_i
    boxes[hash label][label] = lens
  end

  if match = cmd.match(/([a-z]+)\-/)
    raise "malformed file line" unless match&.captures&.count == 1
    label = match.captures[0]
    boxes[hash label].delete label
  end
end

puts boxes.inspect

puts boxes.each_with_index.map{|box,box_idx| 
  box.values.each_with_index.map{|val,val_idx| (box_idx+1)*(val_idx+1)*val }.reduce(:+)
}.compact.reduce(:+)
