priorities = 0
File.read(ARGV[0]).lines.each do |line|
  a, b = line.split(',')
  starta, enda = a.split('-').map(&:to_i)
  startb, endb = b.split('-').map(&:to_i)
  if ((starta..enda).to_a & (startb..endb).to_a).any?
    priorities += 1
  end
end

puts priorities
