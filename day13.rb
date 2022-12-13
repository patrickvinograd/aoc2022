require 'json'
pairs = []

File.read(ARGV[0]).lines.each_slice(3) do |chunk|
  pairs << [JSON.parse(chunk[0].chomp), JSON.parse(chunk[1].chomp)]
end

def compare(left, right)
  #puts "compare #{left} #{right}"
  if left.is_a?(Numeric) and right.is_a?(Numeric)
    return true if left < right
    return false if right < left
    return nil
  elsif left.is_a?(Array) and right.is_a?(Array)
    while true do
      l = left.shift
      r = right.shift
      if l.nil? and r.nil?
        return nil
      elsif l.nil? and not r.nil?
        return true
      elsif r.nil? and not l.nil?
        return false
      else
        result = compare(l, r)
        return true if result == true
        return false if result == false
        # continue if nil
      end
    end
  elsif left.is_a?(Array) and right.is_a?(Numeric)
    result = compare(left, [right])
    return true if result == true
    return false if result == false
  elsif left.is_a?(Numeric) and right.is_a?(Array)
    result = compare([left], right)
    return true if result == true
    return false if result == false
  end
end

puts pairs.inspect
total = 0
pairs.each.with_index(1) do |pair, i|
  left = pair[0]
  right = pair[1]
  #puts "#{i}: #{compare(left, right)}"
  total += i if compare(left, right) == true
end
puts total
