def path_to_regex_string(path)
  "\\A" + path.gsub(%r{:(\w+)}, "(?<\\1>.+)") + "\\Z"
end

def path_to_regex(path)
  # Since we want to be compatible with Ruby 1.8.7, we unfortunately can't use named captures like this:
  # Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(?<\\1>.+)')+'$')
  # Regex.new("^"+path.gsub(/\)/, ")?").gsub(/\//, "\/").gsub(/\./, "\.").gsub(/:(\w+)/, "(.+)")+"$")
  Regex.new path_to_regex_string(path)
end


part = ":name"
path = "Hendrik"

puts path_to_regex_string(part)

r = path_to_regex(part)

if md = r.match(path)
  puts "match!"
  puts md["name"]
end
