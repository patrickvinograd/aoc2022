pairs = [] 
File.read(ARGV[0]).lines.each do |line|
  matches = line.match(/Sensor at x=(-?\d*), y=(-?\d*)\: closest beacon is at x=(-?\d*), y=(-?\d*)/)
  pairs << [[matches[1].to_i, matches[2].to_i], [matches[3].to_i, matches[4].to_i]]
end

#puts pairs.inspect

RNUM = 10
#RNUM = 2000000
#MAX = 20
MAX = 4000000

def merge(ranges) 
  anymerges = true

  while anymerges do
    anymerges = false
    ranges.each_index do |i|
      next if i == ranges.size-1
      if ranges[i].end >= ranges[i+1].begin - 1
        #puts "merging #{ranges[i]} and #{ranges[i+1]}"
        newrange = ([ranges[i].begin,ranges[i+1].begin].min..[ranges[i].end,ranges[i+1].end].max)
        ranges.delete_at(i+1)
        ranges.delete_at(i)
        ranges.insert(i, newrange)
        anymerges = true
        #puts ranges.inspect
      end
    end
  end
  return ranges
end

(0..MAX).each do |y|
  ranges = []
  pairs.each do |sensor, beacon|
    md = (sensor[0] - beacon[0]).abs + (sensor[1] - beacon[1]).abs

    ydist = (sensor[1] - y).abs
    next if ydist > md
    fanout = md - ydist 
    ranges << (sensor[0]-fanout..sensor[0]+fanout)
  end
  ranges = ranges.sort {|a,b| a.begin <=> b.begin}
  ranges = merge(ranges)
  if ranges.size > 1
    puts "#{y}: #{ranges.inspect}"
    puts (ranges[0].end + 1) * 4000000 + y
  end
end


