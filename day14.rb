allpoints = []
map = Array.new(170)
(0...170).each { |y| map[y] = Array.new(560, '.') }
File.read(ARGV[0]).lines.each do |line|
  coords = line.chomp.split(' -> ').map {|x| x.split(',').map {|x| x.to_i} }
  allpoints.concat coords
  coords.each_cons(2) do |a, b|
    if a[0] == b[0] # same x = vertical
      x = a[0]
      range = a[1] < b[1] ? (a[1]..b[1]) : (b[1]..a[1])
      range.each do |y|
        map[y] = Array.new(560, '.') if map[y].nil?
        map[y][x] = '#'
      end
    else # same y = horizontal
      y = a[1]
      range = a[0] < b[0] ? (a[0]..b[0]) : (b[0]..a[0])
      range.each do |x|
        map[y] = [] if map[y].nil?
        map[y][x] = '#'
      end
    end
    puts a.inspect, b.inspect
  end 
end

def printmap(map) 
  for y in (0..$maxy)
    puts map[y][$minx,$maxx-$minx].join('') unless map[y].nil?
  end
end

$minx = allpoints.map { |x| x[0] }.min
$maxx = allpoints.map { |x| x[0] }.max
$miny = allpoints.map { |x| x[1] }.min
$maxy = allpoints.map { |x| x[1] }.max

puts $minx
puts $maxx
puts $miny
puts $maxy
printmap(map)

def dropsand(map)
  x, y = 500, 0
  falling = true
  while falling do
    if y > $maxy
      return false
    end
    if map[y+1][x] == '.'
      y += 1
      next
    elsif map[y+1][x] == '#' or map[y+1][x] == 'o'
      if map[y+1][x-1] == '.'
        x, y = x-1, y+1
        next
      elsif map[y+1][x+1] == '.'
        x, y = x+1, y+1
        next
      else
        map[y][x] = 'o'
        falling = false
      end
    end
  end
  return true
end


count = 0
moresand = true
while moresand do
  moresand = dropsand(map)
  count += 1
end
printmap(map)
puts count-1
