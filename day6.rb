input = File.read(ARGV[0]).lines.first.chomp

(0..input.length-4).each do |i|
  if input.chars.slice(i, 4).uniq.length == 4
    puts i + 4
    break
  end

end


