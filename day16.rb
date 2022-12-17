Node = Struct.new(:name, :rate, :neighbors)

nodes = {}

File.read(ARGV[0]).lines.each do |line|
  matches = line.match(/Valve (..) has flow rate=(\d*); tunnels? leads? to valves? (.*)$/)
  neighbors = matches[3].split(', ') unless matches.nil?
  nodes[matches[1]] = Node.new(matches[1], matches[2].to_i, neighbors) unless matches.nil?
end

#puts nodes.inspect

keys = nodes.keys
dist = {}
keys.each do |k1| 
  keys.each do |k2|
    dist[[k1, k2]] = 1000000
    dist[[k1, k2]] = 0 if k1 == k2
  end
end

keys.each do |k|
  nodes[k].neighbors.each do |n|
    dist[[k, n]] = 1
  end
end

keys.each do |k|
  keys.each do |i|
    keys.each do |j|
      if dist[[i, k]] + dist[[k, j]] < dist[[i,j]]
        dist[[i,j]] = dist[[i,k]] + dist[[k,j]]
      end
    end
  end
end

puts dist.inspect

def flow(order, nodes, dist) 
  result = 0
  current = "AA"
  time = 1
  order.each do |node|
#    puts "going from #{current} to #{node}"
    time += dist[[current, node]] + 1 #account for opening time
    result += nodes[node][:rate] * (31 - time)
    break if time >= 31
#    puts "result = #{result} after #{node} at time #{time}"
    current = node
  end
  return result
end

#1651
#puts flow(["DD", "BB", "JJ", "HH", "EE", "CC"], nodes, dist)

flowkeys = keys.select {|k| nodes[k][:rate] > 0 }
puts flowkeys.inspect
puts flowkeys.count

require 'set'

Option = Struct.new(:nodes, :pressure, :opened)

options = [Option.new(['AA'], 0, Set.new())]
(1..30).each do |tick|
  nextopts = []
  options.each do |opt|
    pressure = opt.pressure + opt[:opened].sum {|x| nodes[x][:rate] }
    current = opt[:nodes].last
    if nodes[current][:rate] > 0 && !opt[:opened].include?(current)
      nextopened = opt[:opened].dup
      nextopened.add(current)
      nextopts << Option.new(opt[:nodes].dup, pressure, nextopened)
    end

    nodes[current][:neighbors].each do |neighbor|
      nextopts << Option.new(opt[:nodes].dup.append(neighbor), pressure, opt[:opened].dup)
    end
  end
  options = nextopts
  options = options.sort {|a,b| a[:pressure] <=> b[:pressure] }.last(10000)
  puts "#{tick}: #{options.size}"
end
puts options.map {|x| x[:pressure]}.max


