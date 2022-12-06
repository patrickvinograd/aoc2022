priorities = 0
File.read(ARGV[0]).lines.each do |line|
  a, b = line.split(',')
  starta, enda = a.split('-').map(&:to_i)
  startb, endb = b.split('-').map(&:to_i)
  if ((starta <= startb && enda >= endb) || (startb <= starta && endb >= enda))
    priorities += 1
  end
end

puts priorities
