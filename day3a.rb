points = {}
("a".."z").each.with_index(1) { |x, i| points[x] = i }
("A".."Z").each.with_index(27) { |x, i| points[x] = i }
#puts points.inspect

priorities = 0
File.read(ARGV[0]).lines.each_slice(3) do |a, b, c|
  dup = (a.chars & b.chars & c.chars).first
  priorities += points[dup]
end

puts priorities
