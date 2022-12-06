elves = []
cals = []
File.read(ARGV[0]).lines.each do |line|
  if line.strip.empty?
    elves << cals
    cals = []
  else
    cals << line.strip.to_i
  end
end

puts elves.map { |x| x.sum }.max

