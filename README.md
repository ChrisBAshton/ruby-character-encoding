# Ruby character encoding

This repo is inspired by this excellent article:

https://www.honeybadger.io/blog/the-rubyist-guide-to-unicode-utf8/

...which explains how characters are represented in bits, and how character sets have evolved.

To run, simply `ruby run.rb "Hello world"`.

## Fun examples to try

* `ruby run.rb "🇫🇷 Ça va? 👩‍👦‍👦"`

## Explanation

UTF=Unicode Transformation Format

"Some characters in Unicode are defined as the combination of several characters."
"In Unicode, the flag emojis are internally represented by some abstract Unicode characters called "Regional Indicator Symbols" like 🇦 or 🇿. They're usually not used outside flags, and when the computer sees the two symbols together, it shows the flag if there is one for that combination."
emojis are represented by the renderer as one character (👩‍👦‍👦)
but are often made up of several (👩👦👦)
and in fact in some renderers may not be rendered as one character.

```ruby
# NO LONGER NEEDED, but useful info around 1s and 0s positioning depicting the number of
# bytes for a character.
input_string.chars.each do |char|
  # If bits begin with a 0, this character could be represented in one byte in ASCII
  if char.unpack("B1") != ["0"]
    # this could either be a 2 byte or 4 byte representation.
    # Let's start by looking at the first 2 bytes:
    two_bytes = char.unpack("B8 B8")
    # If we have a character whose value or code point in Unicode is beyond 127, up to 2047, we use two bytes with the following template: 110_____ 10______
    if two_bytes[0].start_with?("110") && two_bytes[1].start_with?("10")
      puts "\t #{char} needs two bytes"
    # "🙂"'s value or code point in Unicode is 128578. That number in binary is: 11111011001000010, 17 bits. This means it doesn't fit in the 3-byte template since we only had 16 empty slots, so we need to use a new template that takes 4 bytes in memory: 11110___  10______ 10______  10______
    else
      four_bytes = char.unpack("B8 B8 B8 B8")
      if four_bytes[0].start_with?("11110") &&
        four_bytes[1].start_with?("10") &&
        four_bytes[2].start_with?("10") &&
        four_bytes[3].start_with?("10")
        puts "\t #{char} needs 4 bytes"
      else
        puts "\t #{char} invisible whitespace character needs 3 bytes"
      end
    end
  end
end
```
