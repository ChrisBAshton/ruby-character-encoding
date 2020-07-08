# Ruby character encoding

This repo is inspired by [this excellent article](https://www.honeybadger.io/blog/the-rubyist-guide-to-unicode-utf8/) by [José M. Gilgado](https://twitter.com/jmgilgado), which explains how character encodings work and how characters can be broken down to individual bytes and bits.

It also explains some of the intricacies of modern Unicode, and how UTF-8
(Unicode Transformation Format) is efficient and clever in how it encodes
the Unicode standard.

## Requirements

Tested in Ruby 2.5.3 and above. Anything earlier won't extract the emojis properly.

Set up with `bundle install`, then run with `ruby run.rb "your string"`.

## Fun examples to try

* `ruby run.rb "ABCabc"`
  - Not exactly 'fun', but shows how simple characters map to 1 byte each.
  - Note that we'd store "A" as "1000001" with the original ASCII encoding (now known as US-ASCII).
  - Nowadays, with 8-bit computers commonplace, the actual bits used are 01000001 (8 bits = 1 byte).
* `ruby run.rb "こんにちは世界"`
  - Non-latin scripts such as Japanese are outside of the (very limited) 127-character ASCII set.
  - In this example, each character needs 3 bytes.
* `ruby run.rb "It must be 100° outside! 🎔😅"`
  - Some characters, such as the heart icon or 'sweat smile' emoji at the end of this example, need four bytes.

Where it gets interesting is when Unicode combines several characters under the hood,
to render just one character on the screen. It's worth noting that different renderers
or contexts may not render these combinations as just one character, and instead
render them in their individual forms:

* `ruby run.rb "🖖Heya 🖖🏾"`
  - Compare the 'vulcan salute' emojis here.
  - The one in the brown skin tone emoji is actually a combination of the default yellow one followed by a special character that defines the colour.
* `ruby run.rb "Warning ⚠️"`
  - As above, see how the symbol is represented by a `⚠` character followed by a character that colours it.
* `ruby run.rb "Ça va? 🇫🇷"`
  - Flag emojis are internally represented by abstract Unicode characters called "Regional Indicator Symbols", such as `🇦` or `🇿`.
  - They're usually not used outside flags, and when the computer sees the two symbols together, it shows the flag if there is one for that combination.
* `ruby run.rb "Meet my family 👩‍👦‍👦"`
  - The family is represented by a `👩`, `👦` and `👦` under the hood, joined by some sort of special character in between.

## Example output

```
$ ruby run.rb "🇬🇧 Ruby dev 🎉"

=>

Input is 12 visible characters long, represented as 13 characters under the hood. It is 22 bytes.
This input cannot be stored as ASCII (unless you provide fallbacks for the non-ASCII characters).
+-----------+-------+--------------------------------------------------+----------------------------------+
| Character | Bytes | Bytes in UTF-8                                   | Bit sequence                     |
+-----------+-------+--------------------------------------------------+----------------------------------+
| 🇬🇧        | 8     | See below                                        | See below                        |
+-----------+-------+--------------------------------------------------+----------------------------------+
|         🇬 | 4     | ["11110000", "10011111", "10000111", "10101100"] | 11110000100111111000011110101100 |
|         🇧 | 4     | ["11110000", "10011111", "10000111", "10100111"] | 11110000100111111000011110100111 |
+-----------+-------+--------------------------------------------------+----------------------------------+
|           | 1     | ["100000"]                                       | 00100000                         |
| R         | 1     | ["1010010"]                                      | 01010010                         |
| u         | 1     | ["1110101"]                                      | 01110101                         |
| b         | 1     | ["1100010"]                                      | 01100010                         |
| y         | 1     | ["1111001"]                                      | 01111001                         |
|           | 1     | ["100000"]                                       | 00100000                         |
| d         | 1     | ["1100100"]                                      | 01100100                         |
| e         | 1     | ["1100101"]                                      | 01100101                         |
| v         | 1     | ["1110110"]                                      | 01110110                         |
|           | 1     | ["100000"]                                       | 00100000                         |
| 🎉        | 4     | ["11110000", "10011111", "10001110", "10001001"] | 11110000100111111000111010001001 |
+-----------+-------+--------------------------------------------------+----------------------------------+
```
