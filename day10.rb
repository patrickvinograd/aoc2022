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

puts reg.inspect

signal = 0
i = 20
while i < reg.size
  x = i * reg[i-1] 
  puts x
  signal += x 
  i+= 40
end

puts signal
