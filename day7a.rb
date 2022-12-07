EFile = Struct.new(:name, :size)

EDir = Struct.new(:name, :parent, :directories, :files)

root = EDir.new("/", nil, {}, [])
current = nil

File.read(ARGV[0]).lines.each do |line|
  input = line.chomp
  if input.start_with?("$ cd /")
    current = root
  elsif input.start_with?("$ ls")
    # noop
  elsif input.start_with?("$ cd ..")
    current = current.parent
  elsif input.start_with?("$ cd")
    sub = input.split(' ')[2]
    current = current[:directories][sub]
  elsif input.start_with?("dir ")
    name = input.split(' ')[1]
    subdir = EDir.new(name, current, {}, [])
    current[:directories][name] = subdir
  elsif input.start_with?(/[0-9]/)
    size, name = input.split(' ')
    file = EFile.new(name, size.to_i)
    current[:files] << file
  end
end

$dirmap = {}

def fullname(dir)
  result = dir[:name]
  if dir[:parent].nil?
    return "/"
  else 
    return fullname(dir[:parent]) + "/" + dir[:name]
  end
end

def edir_size(dir)
  size = dir[:files].sum { |f| f[:size] }
  size += dir[:directories].sum { |key, value| edir_size(value) }
  $dirmap[fullname(dir)] = size
  return size
end

used = edir_size(root)
#puts $dirmap.inspect
#puts $dirmap.keys.size

available = 70000000 - used
needed = 30000000 - available

puts $dirmap.values.select { |x| x > needed}.min 

