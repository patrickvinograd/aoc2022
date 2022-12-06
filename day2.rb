points = {
  ["A", "X"] => 4, # 3 + 1
  ["A", "Y"] => 8, # 6 + 2
  ["A", "Z"] => 3, # 0 + 3
  ["B", "X"] => 1, # 0 + 1
  ["B", "Y"] => 5, # 3 + 2
  ["B", "Z"] => 9, # 6 + 3
  ["C", "X"] => 7, # 6 + 1
  ["C", "Y"] => 2, # 0 + 2
  ["C", "Z"] => 6  # 3 + 3
}

score = 0
File.read(ARGV[0]).lines.each do |line|
  them, me = line.split(" ")
  key = [them, me]
  #puts key.inspect
  #puts points[key]
  score += points[key]
end

puts score
