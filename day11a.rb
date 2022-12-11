Monkey = Struct.new(:number, :items, :operation, :test, :iftrue, :iffalse)

monkeys = {}

File.read(ARGV[0]).lines.each_slice(7) do |chunk|
  number = chunk[0].strip.match(/Monkey (\d*)\:/)[1].to_i
  items = chunk[1].strip.split(':', 2)[1].split(',').map(&:to_i)
  opstring = chunk[2].strip.split(':')[1].split('=')[1].strip.split(' ')
  operation = nil
  if opstring[1] == '*'
    if opstring[2] == 'old'
      operation = Proc.new { |x| x * x }
    else
      operation = Proc.new { |x| x * opstring[2].to_i }
    end
  elsif opstring[1] == '+'
    operation = Proc.new { |x| x + opstring[2].to_i }
  end
  test = chunk[3].strip.match(/divisible by (\d*)/)[1].to_i
  iftrue = chunk[4].strip.match(/throw to monkey (\d*)/)[1].to_i
  iffalse = chunk[5].strip.match(/throw to monkey (\d*)/)[1].to_i
  monkey = Monkey.new(number, items, operation, test, iftrue, iffalse)
  monkeys[number] = monkey
end
  
# puts monkeys.inspect

factor = monkeys.values.map { |m| m[:test] }.reduce(&:*)
puts factor.inspect

inspects = Hash.new {|h,k| h[k] = 0}

def printmonkeys(monkeys)
  monkeys.each do |num, monkey|
    puts "#{num}: #{monkey[:items].inspect}"
  end
end

for round in (1..10000) do
  monkeys.each do |num, monkey|
    while monkey[:items].any?
      inspects[num] += 1
      item = monkey[:items].shift
      level = monkey[:operation].call(item)
      level = level % factor
      if level % monkey[:test] == 0
        monkeys[monkey[:iftrue]][:items] << level
#        puts "#{num}: monkey #{monkey[:iftrue]} gets #{level}"
      else
        monkeys[monkey[:iffalse]][:items] << level
#        puts "#{num}: monkey #{monkey[:iffalse]} gets #{level}"
      end
    end
  end
end

puts inspects.inspect

puts inspects.values.max(2).reduce(:*)

