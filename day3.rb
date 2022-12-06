points = {}
("a".."z").each.with_index(1) { |x, i| points[x] = i }
("A".."Z").each.with_index(27) { |x, i| points[x] = i }
#puts points.inspect

priorities = 0
File.read(ARGV[0]).lines.each do |line|
  first, second = line[0, line.length/2], line[line.length/2, line.length/2]
  dup = (first.chars & second.chars).first
  priorities += points[dup]
end

puts priorities
