require 'json'

Expr = Struct.new :op, :left, :right

def run

  store = {}

  File.open(ARGV[0]).each do |line|
    if (match = line.match(/([a-z]{4})\: (\-?\d+)/))
      raise unless match.captures.count == 2
      ref, val = match.captures
      store[ref] = val.to_i
    elsif (match = line.match(/([a-z]{4})\: ([a-z]{4}) (.) ([a-z]{4})/))
      raise unless match.captures.count == 4
      ref, left, op, right = match.captures
      store[ref] = Expr.new op, left, right
    elsif line.strip.empty?
      next
    else
      raise "malformed file line"
    end
  end

  comp = -> (ref) {
    raise "referenced #{ref} which is not present" unless store.has_key? ref
    return store[ref] if store[ref].is_a? Integer

    expr = store[ref]
    comp.call(expr.left).send(expr.op, comp.call(expr.right))
  }
  puts comp.call("root")

  find_in_tree = -> (top, ref) {
    return true if top == ref
    return false if store[top].is_a? Numeric
    find_in_tree.call(store[top].left, ref) || find_in_tree.call(store[top].right, ref)
  }

  solve = -> (expr, y) {
    left_unknown = find_in_tree.call(expr.left, "humn")
    right_unknown = find_in_tree.call(expr.right, "humn")
    raise "cant compute this" if left_unknown && right_unknown
    raise "cant compute this" if !left_unknown && !right_unknown

    if left_unknown && y == nil
      {side: 'left', val: comp.call(expr.right)}
    elsif right_unknown && y == nil
      {side: 'right', val: comp.call(expr.left)}
    elsif left_unknown && expr.op == '+'
      {side: 'left', val: y - comp.call(expr.right)}
    elsif right_unknown && expr.op == '+'
      {side: 'right', val: y - comp.call(expr.left)}
    elsif left_unknown && expr.op == '-'
      {side: 'left', val: y + comp.call(expr.right)}
    elsif right_unknown && expr.op == '-'
      {side: 'right', val: comp.call(expr.left) - y}
    elsif left_unknown && expr.op == '*'
      {side: 'left', val: y / comp.call(expr.right)}
    elsif right_unknown && expr.op == '*'
      {side: 'right', val: y / comp.call(expr.left)}
    elsif left_unknown && expr.op == '/'
      {side: 'left', val: y * comp.call(expr.right)}
    elsif right_unknown && expr.op == '/'
      {side: 'right', val: comp.call(expr.left) / y}
    else
      raise "couldnt solve #{expr} #{left_unknown} #{right_unknown} #{expr.op == '-'}"
    end
  }

  comp_humn = -> (ref, expected = nil) {
    raise "wrong" unless store[ref]
    raise "wrong" if store[ref].is_a? Numeric

    expr = store[ref]
    sltn = solve.call(expr, expected)

    if expr.send(sltn[:side]) == "humn"
      return sltn[:val]
    else
      comp_humn.call(expr.send(sltn[:side]), sltn[:val])
    end
  }

  puts comp_humn.call("root")

end

run
