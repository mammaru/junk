require 'date'

@data = Hash.new{ |hash,key| hash[key] = Hash.new(0) }

Dir::foreach('.') {|f|
  if File::ftype(f) != "file"
    next
  elsif f =~ /\d*-\d*-\d*/
    date = Date.strptime(f, "%Y-%m-%d")
    open(f) do |ff|
      # skip headers
      ff.gets
      ff.gets
      while l = ff.gets
        r = l.split(",")
        @data[date][r[0]] = r
      end
    end
  end
}

names = @data[@data.keys[0]].keys.sort

start = Time.local(2013, 12, 1)
0.upto(65) do |i|
  d = start + i * 24 * 60 * 60
  str = d.strftime("%Y-%m-%d")
  data = @data[str]
  row = [str]
  names.each do |n|
    row << [
  end
end
