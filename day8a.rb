trees = []
scores = []
File.read(ARGV[0]).lines.each do |line|
  trees << line.chomp.split('').map(&:to_i)
end

#puts trees.inspect
maxi = trees.size-1
maxj = trees[0].size-1

visible = 0
for i in (0..trees.size-1)
  scores << Array.new(maxj+1)
  for j in (0..trees[0].size-1)
    val = trees[i][j]
    if i == 0 or i == maxi or j == 0 or j == maxj
      scores[i][j] = 0
      next
    end
    score = 1
    left = (trees[i][0..j-1].reverse_each.find_index {|x| x >= val } || j-1) + 1
    right = (trees[i][j+1..maxj].find_index {|x| x >= val } || maxj - j - 1) + 1   
    up = (trees[0..i-1].map {|a| a[j]}.reverse_each.find_index {|x| x >= val } || i-1) + 1
    down = (trees[i+1..maxi].map {|a| a[j]}.find_index {|x| x >= val} || maxi - i - 1) + 1

    score = left * right * up * down
    scores[i][j] = score
  end
end

#puts scores.inspect
puts scores.each.map(&:max).max


