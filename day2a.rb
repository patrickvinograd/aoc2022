points = {
  ["A", "X"] => 3, # rock lose = rock scissors = 0 + 3 
  ["A", "Y"] => 4, # rock draw = rock rock = 3 + 1
  ["A", "Z"] => 8, # rock win = rock paper = 6 + 2 
  ["B", "X"] => 1, # paper lose = paper rock = 0 + 1
  ["B", "Y"] => 5, # paper draw = paper paper = 3 + 2
  ["B", "Z"] => 9, # paper win = paper scissors = 6 + 3
  ["C", "X"] => 2, # scissors lose = scissors paper = 0 + 2
  ["C", "Y"] => 6, # scissors draw = scissors scissors = 3 + 3  
  ["C", "Z"] => 7  # scissors win = scissors rock = 6 + 1
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
