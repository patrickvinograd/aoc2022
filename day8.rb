trees = []
File.read(ARGV[0]).lines.each do |line|
  trees << line.chomp.split('').map(&:to_i)
end

puts trees.inspect
maxi = trees.size-1
maxj = trees[0].size-1

visible = 0
for i in (0..trees.size-1)
  for j in (0..trees[0].size-1)
    isvis = false
    val = trees[i][j]
    if i == 0 or i == maxi
      isvis = true
    elsif j == 0 or j == maxj
      isvis = true
    elsif trees[i][0..j-1].all? {|x| x < val}
      isvis = true
    elsif trees[i][j+1..maxj].all? {|x| x < val}
      isvis = true
    elsif trees[0..i-1].map {|a| a[j]}.all? {|x| x < val}
      isvis = true
    elsif trees[i+1..maxi].map {|a| a[j]}.all? {|x| x < val}
      isvis = true
    end
    visible +=1 if isvis
  end
end

puts visible
