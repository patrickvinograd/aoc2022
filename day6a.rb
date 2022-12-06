input = File.read(ARGV[0]).lines.first.chomp

(0..input.length-4).each do |i|
  if input.chars.slice(i, 14).uniq.length == 14
    puts i + 14
    break
  end

end


