require 'json'
require 'Set'

Item = Struct.new(:val, :prev, :next)

def run

  list = []
  list2 = []
  origin = nil
  zero = nil

  File.open(ARGV[0]).each do |line|
    next if line.strip.empty?
    val = line.strip.to_i
    item = Item.new val, nil, nil
    origin = item unless origin
    zero = item if item.val == 0
    item.prev = list.last if list.last
    list.last.next = item if list.last
    list.push item
  end
  list.first.prev = list.last
  list.last.next = list.first

  list2 = list.dup

  move = -> (x1, d) {
    while d <= -list.count; d += list.count; end
    while d >=  list.count; d -= list.count; end
      
    return if d == 0

    x2 = x1
    i = d
    loop do
      if i < 0
        x2 = x2.prev
        i += 1
      elsif i > 0
        x2 = x2.next
        i -= 1
      else
        break
      end
    end

    origin = x1.next if origin == x1
    x1.prev.next, x1.next.prev = x1.next, x1.prev

    if d > 0
      origin = x1 if x2.next == origin
      x2.next, x1.prev, x1.next, x2.next.prev = x1, x2, x2.next, x1
    elsif d < 0
      origin = x1 if x2.prev == origin
      x2.prev, x1.next, x1.prev, x2.prev.next = x1, x2, x2.prev, x1
    end
  }

  move2 = -> (x1, d) {
    return if d == 0

    list2_idx = list2.find_index(x1)
    list2.delete_at(list2_idx)
    target_idx = (list2_idx + d) % (list2.count)

    if target_idx == 0
      list2.push x1
    else
      list2.insert(target_idx, x1)
    end
    list2 = list2.rotate(list2.find_index(zero))
  }

  collect = -> (start) {
    res = [start]
    curr = start
    loop do
      curr = curr.next
      break res if curr == start
      res.push curr
    end
  }

  list.each_with_index{|i,idx| 
    move2.call i, i.val
  }

  c = collect.call zero

  puts list2[1000 % list2.count].val + list2[3000 % list2.count].val + list2[2000 % list2.count].val

  list = list.each{|x| x.val *= 811589153}
  list2 = list.dup

  10.times{
    list.each_with_index{|i,idx| 
      move2.call i, i.val
    }
  }
  puts list2[1000 % list2.count].val + list2[3000 % list2.count].val + list2[2000 % list2.count].val
end

run if __FILE__ == $0
