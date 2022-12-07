input_path = ARGV[0]

Fil = Struct.new(:name, :size, :parent) do
  def all_nodes; [] end
  def path; parent ? "#{parent.path}#{self.name}" : name; end
end

Diry = Struct.new(:name, :nodes, :parent) do
  def type; :dir; end
  def go_up; parent; end
  def go_down(new_name); nodes[new_name] ||= Diry.new(new_name, {}, self); end
  def path; parent ? "#{parent.path}#{self.name}/" : name; end
  def size; nodes.values.map(&:size).sum; end
  def all_nodes; nodes.values.flat_map{|n| [n] + n.all_nodes }; end
  def add_file(name, size); nodes[name] = Fil.new name, size, self; end
end

@current_dir = nil
@root_dir = Diry.new "/", {}, nil

File.open(input_path).each do |line|
  if line.match /\$ cd \//
    @current_dir = @root_dir
  elsif line.match /\$ cd \.\./
    @current_dir = @current_dir.go_up
    raise "incorrect navigation up" if @current_dir == nil
  elsif line.start_with? "$ cd"
    match = line.match /\$ cd ([a-zA-Z]+)/
    raise "could not match cd in '#{line}'" unless match&.captures&.count == 1
    @current_dir = @current_dir.go_down match.captures[0]
  elsif match = line.match(/(\d+) ([a-zA-Z\.]+)/)
    raise "malformed file line" unless match&.captures&.count == 2
    size = match.captures[0].to_i
    name = match.captures[1]
    @current_dir.add_file name, size
  end
end

puts ([@root_dir] + @root_dir.all_nodes)
  .filter{|n| n.is_a? Diry}
  .filter{|n| n.size <= 100000}
  .map{|n| n.size}
  .sum

free_space = 70000000 - @root_dir.size
missing_space = 30000000 - free_space

puts ([@root_dir] + @root_dir.all_nodes)
  .filter{|n| n.is_a? Diry}
  .filter{|n| n.size >= missing_space}
  .map{|n| n.size}
  .min
