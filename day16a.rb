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

#puts dist.inspect

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

keys = nodes.keys
flowkeys = keys.select {|k| nodes[k][:rate] > 0 }

require 'set'
Option = Struct.new(:nodes, :elnodes, :pressure, :opened)

best = {}

def isbest(best, opt) 
  key = [opt[:opened].to_a.sort, opt[:nodes].last, opt[:elnodes].last]
  if best[key].nil? or best[key] < opt[:pressure]
    best[key] = opt[:pressure]
    return true
  end
  return false
end


options = [Option.new(['AA'], ['AA'], 0, Set.new())]
(1..26).each do |tick|
  nextopts = []
  options.each do |opt|
    pressure = opt.pressure + opt[:opened].sum {|x| nodes[x][:rate] }
    current = opt[:nodes].last
    elcurrent = opt[:elnodes].last

    # No more opening, just let it play out
    if opt[:opened].size == flowkeys.size
      nopt = Option.new(opt[:nodes].dup, opt[:elnodes].dup, pressure, opt[:opened].dup)
      nextopts << nopt if isbest(best, nopt)
      next
    end

    #both open
    if nodes[current][:rate] > 0 && !opt[:opened].include?(current) &&
        nodes[elcurrent][:rate] > 0 && !opt[:opened].include?(elcurrent)
      nextopened = opt[:opened].dup
      nextopened.add(current)
      nextopened.add(elcurrent)
      nopt = Option.new(opt[:nodes].dup, opt[:elnodes].dup, pressure, nextopened)
      nextopts << nopt if isbest(best, nopt)
    end

    # i move, elephant opens
    if nodes[elcurrent][:rate] > 0 && !opt[:opened].include?(elcurrent) 
      nextopened = opt[:opened].dup
      nextopened.add(elcurrent)
      neighbors = nodes[current][:neighbors]
      neighbors.each do |neighbor|
        nopt = Option.new(opt[:nodes].dup.append(neighbor), opt[:elnodes].dup, pressure, nextopened)
        nextopts << nopt if isbest(best, nopt)
      end
    end

    
    # i open, elephant moves
    if nodes[current][:rate] > 0 && !opt[:opened].include?(current) 
      nextopened = opt[:opened].dup
      nextopened.add(current)
      neighbors = nodes[elcurrent][:neighbors]
      neighbors.each do |neighbor|
        nopt = Option.new(opt[:nodes].dup, opt[:elnodes].dup.append(neighbor), pressure, nextopened)
        nextopts << nopt if isbest(best, nopt)
      end
    end


    # both move
    neighbors = nodes[current][:neighbors]
    elneighbors = nodes[elcurrent][:neighbors]
    neighbors.each do |neighbor|
      elneighbors.each do |elneighbor|
        nopt = Option.new(opt[:nodes].dup.append(neighbor), opt[:elnodes].dup.append(elneighbor), pressure, opt[:opened].dup)
        nextopts << nopt if isbest(best, nopt)
      end
    end
  end
  options = nextopts
  options = options.sort {|a,b| a[:pressure] <=> b[:pressure] }.last(10000)
  #puts "#{tick}: #{options.size}"
  #options.last(10).each { |x| puts x.inspect }
  #puts best.inspect if tick < 6
end
puts options.map {|x| x[:pressure]}.max


