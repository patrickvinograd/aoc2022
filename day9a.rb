require 'set'

def move(head, tail, shift)
  newhead = [head,shift].transpose.map(&:sum)

  tailshift = [0,0]
  if newhead[0] == tail[0]
    tailshift = [0, 1] if newhead[1] - tail[1] == 2
    tailshift = [0, -1] if newhead[1] - tail[1] == -2
  elsif newhead[1] == tail[1]
    tailshift = [1, 0] if newhead[0] - tail[0] == 2
    tailshift = [-1, 0] if newhead[0] - tail[0] == -2
  elsif (newhead[0] - tail[0]).abs == 2 or (newhead[1] - tail[1]).abs == 2
    tailshiftx = 1 if newhead[0] > tail[0]
    tailshiftx = -1 if newhead[0] < tail[0]
    tailshifty = 1 if newhead[1] > tail[1]
    tailshifty = -1 if newhead[1] < tail[1]
    tailshift = [tailshiftx, tailshifty]
  end
  newtail = [tail,tailshift].transpose.map(&:sum)
  return newhead, newtail, tailshift
end

def dirshift(direction)
  return [0,1] if direction == 'R'
  return [0,-1] if direction == 'L'
  return [1,0] if direction == 'U'
  return [-1,0] if direction == 'D'
end

tailpos = Set.new
rope = Array.new(10).fill [0,0]

tailpos.add rope[9]

File.read(ARGV[0]).lines.each do |line|
  direction, count = line.chomp.split(' ')
  count.to_i.times.each do |x|
    for i in (0..8)
      rope[i], rope[i+1] = move(rope[i], rope[i+1], i == 0 ? dirshift(direction) : [0,0])
    end
    tailpos.add rope[9]
  end
end

puts tailpos.size
