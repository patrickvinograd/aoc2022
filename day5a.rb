STACKS = {}
INSTRUCTIONS = []

def fill_stacks(line)
  boxes = line.chars.each_slice(4).map(&:join).map(&:strip).map {|x| x.tr('[]', "") }
  boxes.each.with_index(1) do |box, i|
    STACKS[i] = [] if STACKS[i].nil?
    STACKS[i].prepend(box) unless box.empty?
  end
end

def fill_instructions(line)
  step = line.split.each_slice(2).map {|x| x[1]}.map(&:to_i)
  INSTRUCTIONS << step
end

def go
  INSTRUCTIONS.each do |step|
    num, from, to = step
    STACKS[to].concat(STACKS[from].pop(num))
  end
end

File.read(ARGV[0]).lines.each do |line|
  if line.strip.start_with?('[')
    fill_stacks(line)
  elsif line.start_with?('move')
    fill_instructions(line)
  end
end

go
result = ""
STACKS.each { |k,v| result << v.last }
puts result


