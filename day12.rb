Node = Struct.new(:x, :y, :height, :best, :isstart, :isend, :val)

hm = []
$start = nil
$end = nil

def init_node(val, x, y)
  if val == 'S'
    $start = [x, y]
    Node.new(x, y, 1, nil, true, false, val)
  elsif val == 'E'
    $end = [x, y]
    Node.new(x, y, 26, 0, false, true, val)
  else
    Node.new(x, y, (val.ord - 'a'.ord + 1), nil, false, false, val)
  end
end

File.read(ARGV[0]).lines.each_with_index do |line, y|
  hm.append line.chomp.split('').map.with_index { |val, x| init_node(val, x, y) }
end

$maxx = hm[0].size - 1
$maxy = hm.size - 1

#puts hm.inspect
#puts $start.inspect
#puts $end.inspect

def neighbors(node)
  result = []
  result << [node[:x]-1, node[:y]] if node[:x] > 0
  result << [node[:x], node[:y]-1] if node[:y] > 0
  result << [node[:x]+1, node[:y]] if node[:x] < $maxx
  result << [node[:x], node[:y]+1] if node[:y] < $maxy
  result
end

def printmap(hm)
  hm.each do |row|
    row.each { |node| print "#{node[:val]}/#{node[:best] || '-'} " }
    puts ""
  end
end

def lookup(hm, coord)
  hm[coord[1]][coord[0]]
end

puts neighbors(lookup(hm, $start)).inspect
puts neighbors(lookup(hm, $end)).inspect

searchlist = []
searchlist << $end

while searchlist.size > 0 do
  current = lookup(hm, searchlist.shift)
  neighbors(current).each do |n|
    neighbor = lookup(hm, n)
    #puts neighbor.inspect
    if neighbor[:height] >= current[:height] - 1
      if neighbor[:best].nil? or neighbor[:best] > current[:best] + 1
        neighbor[:best] = current[:best] + 1
        searchlist << [neighbor[:x], neighbor[:y]]
      end
    end
  end
end

#printmap(hm)
puts lookup(hm, $start).inspect
puts lookup(hm, $start)[:best]

best = 1000000
hm.each do |row|
  row.each do |node|
    if node[:height] == 1 && !node[:best].nil? && node[:best] < best
      best = node[:best]
    end
  end
end

puts best


