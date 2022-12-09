require 'set'

def move(head, tail, direction)
  newhead = [head,[1,0]].transpose.map(&:sum) if direction == 'R'
  newhead = [head,[-1,0]].transpose.map(&:sum) if direction == 'L'
  newhead = [head,[0,1]].transpose.map(&:sum) if direction == 'U'
  newhead = [head,[0,-1]].transpose.map(&:sum) if direction == 'D'

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
  return newhead, newtail

end

tailpos = Set.new

head = [0,0]
tail = [0,0]
tailpos.add tail

File.read(ARGV[0]).lines.each do |line|
  direction, count = line.chomp.split(' ')
  count.to_i.times.each do |x|
    head, tail = move(head, tail, direction)
    tailpos.add tail
    puts direction
    puts [head, tail].inspect
  end
end

puts tailpos.size
