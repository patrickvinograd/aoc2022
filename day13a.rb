require 'json'
signals = []

File.read(ARGV[0]).lines.each_slice(3) do |chunk|
  signals << JSON.parse(chunk[0].chomp)
  signals << JSON.parse(chunk[1].chomp)
end
signals << [[2]]
signals << [[6]]

def compare(left, right)
  #puts "compare #{left} #{right}"
  if left.is_a?(Numeric) and right.is_a?(Numeric)
    return -1 if left < right
    return 1 if right < left
    return 0
  elsif left.is_a?(Array) and right.is_a?(Array)
    i = 0
    while true do
      l = left[i]
      r = right[i]
      if l.nil? and r.nil?
        return 0
      elsif l.nil? and not r.nil?
        return -1
      elsif r.nil? and not l.nil?
        return 1
      else
        result = compare(l, r)
        return -1 if result < 0
        return 1 if result > 0
        # continue if nil
      end
      i += 1
    end
  elsif left.is_a?(Array) and right.is_a?(Numeric)
    result = compare(left, [right])
    return -1 if result < 0
    return 1 if result > 0
  elsif left.is_a?(Numeric) and right.is_a?(Array)
    result = compare([left], right)
    return -1 if result < 0
    return 1 if result > 0
  end
  return 0 
end

sorted = signals.sort { |a,b| compare(a,b) }

#sorted.each.with_index(1) { |x, i| puts "#{i}: #{x.inspect}" }

s1 = sorted.find_index { |x| x == [[2]] } + 1
s2 = sorted.find_index { |x| x == [[6]] } + 1

puts s1*s2


