require "terminal-table"

input_string = ARGV[0]
bytes = input_string.bytes.map { |e| e.to_s(2)}.size
visible_character_count = input_string.scan(/\X/).size # 'grapheme' count (https://bugs.ruby-lang.org/issues/13780)
ascii_representation = begin
                         input_string.encode(
                           "ASCII",
                           "UTF-8",
                           # fallback: {"🙂" => ":)"},
                         )
                       rescue Encoding::UndefinedConversionError
                         false
                       end

if input_string.size == visible_character_count
  puts "Input is #{input_string.size} characters long and is #{bytes} bytes."
else
  puts "Input is #{visible_character_count} visible characters long, " \
       "represented as #{input_string.size} characters under the hood. It is #{bytes} bytes."
end

if ascii_representation
  puts "This input could be stored as ASCII, as it uses no special characters."
else
  puts "This input cannot be stored as ASCII (unless you provide fallbacks for the non-ASCII characters)."
end

to_bytes = ->(subject) { subject.bytes.map { |e| e.to_s(2)} }
to_bits = ->(subject) { subject.unpack("B*").first }

graphemes = input_string.scan(/\X/)

headings = ["Character", "Bytes", "Bytes in UTF-8", "Bit sequence"]
rows = []
graphemes.each_with_index do |grapheme, i|
  if grapheme.chars.size == 1
    bytes = to_bytes.call(grapheme)
    rows << [grapheme, bytes.size, bytes, to_bits.call(grapheme.chars.first)]
  else
    rows << [grapheme, bytes.size, "See below", "See below"]
    rows << :separator
    grapheme.chars.each do |char|
      bytes = to_bytes.call(char)
      rows << [{ value: char, alignment: :right }, bytes.size, bytes, to_bits.call(char)]
    end
    rows << :separator unless i == graphemes.size - 1
  end
end

table = Terminal::Table.new(headings: headings, rows: rows)
puts table
