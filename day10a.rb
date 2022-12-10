reg = [1]
File.read(ARGV[0]).lines.each do |line|
  inst, arg = line.chomp.split(' ')
  if inst == 'noop'
    reg << reg.last
  elsif inst == 'addx'
    reg << reg.last
    reg << reg.last + arg.to_i
  end
end

i = 0
while i < reg.size
  col = i % 40
  if reg[i] == col or reg[i] - 1 == col or reg[i] + 1 == col
    print '#'
  else
    print '.'
  end
  i += 1
  if i % 40 == 0
    puts ''
  end
end

