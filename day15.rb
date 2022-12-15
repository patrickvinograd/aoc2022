pairs = [] 
File.read(ARGV[0]).lines.each do |line|
  matches = line.match(/Sensor at x=(-?\d*), y=(-?\d*)\: closest beacon is at x=(-?\d*), y=(-?\d*)/)
  pairs << [[matches[1].to_i, matches[2].to_i], [matches[3].to_i, matches[4].to_i]]
end

puts pairs.inspect

RNUM = 2000000
row = {}

pairs.each do |_, beacon|
  if beacon[1] == RNUM
    row[beacon[0]] = 'B'
  end
end

pairs.each do |sensor, beacon|
  md = (sensor[0] - beacon[0]).abs + (sensor[1] - beacon[1]).abs
  puts "#{sensor.inspect}/#{beacon.inspect}: #{md}"

  ydist = (sensor[1] - RNUM).abs
  next if ydist > md
  fanout = md - ydist 
  (sensor[0]..(sensor[0]+fanout)).each do |x|
    row[x] = '#' if row[x] != 'B'
  end
  (sensor[0]-fanout..sensor[0]).each do |x|
    row[x] = '#' if row[x] != 'B'
  end
end

puts row.values.count {|x| x == '#'}
