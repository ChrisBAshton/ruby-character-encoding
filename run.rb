input_string = ARGV[0]
puts "INPUT: #{input_string}"

# doesn't work in ruby 2.3.7p456 (2018-03-28 revision 63024) [universal.x86_64-darwin18]
# DOES work in ruby 2.6.6p146 (2020-03-31 revision 67876) [x86_64-darwin18]
# not sure yet what the earliest supported version is.
# Could check this programmatically using global `RUBY_VERSION`

# 'grapheme' count (https://bugs.ruby-lang.org/issues/13780)
visible_character_count = input_string.scan(/\X/).size
if input_string.size == visible_character_count
  puts "CHARACTERS: #{input_string.size}"
else
  puts "VISIBLE CHARACTERS ('GRAPHEMES'): #{visible_character_count}"
  puts "CHARACTERS UNDER THE HOOD: #{input_string.size}"
end

puts "BYTES: #{input_string.bytes.map { |e| e.to_s(2)}.size}"

ascii_representation = begin
                         input_string.encode("ASCII", "UTF-8", fallback: {"🙂" => ":)"})
                       rescue Encoding::UndefinedConversionError
                         false
                       end

if ascii_representation
  puts "This input could be stored as ASCII, as it uses no special characters."
else
  puts "This input can NOT be stored as ASCII, as it contains characters outside of the 127-character ASCII range."
end

puts "CHARACTER BREAKDOWN:"
input_string.scan(/\X/).each do |grapheme|
  chars = grapheme.chars
  raw_bits = chars.map { |char| char.unpack("B*") }.flatten.join("")
  bytes = grapheme.bytes.map { |e| e.to_s(2)}
  byte_size = bytes.size == 1 ? "1 byte" : "#{bytes.size} bytes"
  if grapheme.chars.size > 1
    puts "`#{grapheme}` (#{byte_size}) as it is represented as #{grapheme.chars} under the hood. " \
         "Its bit sequence is: \n\t #{raw_bits} (as bytes: #{bytes})"
  else
    puts "`#{grapheme}` (#{byte_size}). Its bit sequence is: #{raw_bits} (as bytes: #{bytes})"
  end
end
