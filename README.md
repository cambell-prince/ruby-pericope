# Ruby::Pericope

A Ruby library for parsing, manipulating, and working with biblical references (pericopes). This library provides comprehensive support for biblical book recognition, verse reference handling, and pericope parsing with flexible input formats.

## Features

- **Comprehensive Book Database**: All 66 canonical books with multiple aliases and abbreviations
- **Flexible Book Recognition**: Fuzzy matching for misspelled book names
- **Verse Reference Handling**: Create, validate, and manipulate individual verse references
- **Pericope Parsing**: Parse complex biblical references including ranges and multiple passages
- **Text Extraction**: Extract biblical references from natural text
- **Multiple Output Formats**: Canonical, full name, and abbreviated formats
- **Robust Error Handling**: Comprehensive error classes for different failure modes
- **Full Test Coverage**: 127+ test cases covering all functionality

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add ruby-pericope

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install ruby-pericope

## Usage

### Basic Book Operations

```ruby
require 'ruby/pericope'

# Find books by different methods
genesis = Ruby::Pericope::Book.find_by_code("GEN")
matthew = Ruby::Pericope::Book.find_by_name("Matthew")
corinthians = Ruby::Pericope::Book.find_by_name("1 Corinthians")

# Fuzzy matching for misspelled names
mathew = Ruby::Pericope::Book.find_by_name("Mathew") # finds "Matthew"

# Book properties
puts genesis.name              # "Genesis"
puts genesis.code              # "GEN"
puts genesis.old_testament?    # true
puts genesis.chapter_count     # 50
```

### Verse References

```ruby
# Create verse references
verse1 = Ruby::Pericope::VerseRef.new("GEN", 1, 1)
verse2 = Ruby::Pericope::VerseRef.new("MAT", 5, 3)

puts verse1.to_s              # "GEN 1:1"
puts verse1.to_i              # 1001001 (BBBCCCVVV format)

# Comparison and navigation
puts verse1.before?(verse2)   # true
puts verse1.next_verse        # "GEN 1:2"
puts verse1.previous_verse    # nil (beginning of book)
```

### Pericope Parsing

```ruby
# Single verse
pericope1 = Ruby::Pericope::Pericope.new("GEN 1:1")
puts pericope1.to_s           # "GEN 1:1"
puts pericope1.verse_count    # 1

# Verse range
pericope2 = Ruby::Pericope::Pericope.new("GEN 1:1-3")
puts pericope2.to_s           # "GEN 1:1-3"
puts pericope2.verse_count    # 3

# Cross-chapter range
pericope3 = Ruby::Pericope::Pericope.new("GEN 1:30-2:2")
puts pericope3.spans_chapters? # true
puts pericope3.chapter_count   # 2

# Multiple ranges
pericope4 = Ruby::Pericope::Pericope.new("GEN 1:1,3,5")
puts pericope4.range_count     # 3
```

### Text Parsing

```ruby
text = "In the beginning (GEN 1:1), God created. Later, Jesus taught (MAT 5:3-12)."
pericopes = Ruby::Pericope::Pericope.parse(text)

pericopes.each do |pericope|
  puts "#{pericope} (#{pericope.verse_count} verses)"
end
# Output:
# GEN 1:1 (1 verses)
# MAT 5:3-12 (10 verses)
```

### Output Formats

```ruby
pericope = Ruby::Pericope::Pericope.new("GEN 1:1-3")

puts pericope.to_s(:canonical)    # "GEN 1:1-3"
puts pericope.to_s(:full_name)     # "Genesis 1:1-3"
puts pericope.to_s(:abbreviated)   # "GEN 1:1-3"
```

### Error Handling

```ruby
begin
  Ruby::Pericope::Pericope.new("INVALID 1:1")
rescue Ruby::Pericope::InvalidBookError => e
  puts e.message # "Invalid book: 'INVALID'"
end

begin
  Ruby::Pericope::VerseRef.new("GEN", 0, 1)
rescue Ruby::Pericope::InvalidChapterError => e
  puts e.message # "Invalid chapter 0 for book GEN"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

Run the test suite:

```bash
bundle exec rake spec
```

Run tests with coverage:

```bash
bundle exec rake coverage
```

Run linting:

```bash
bundle exec rake rubocop
```

Run all checks (tests + linting):

```bash
bundle exec rake
```

## Documentation

Generate documentation:

```bash
bundle exec rake doc
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cambell-prince/ruby-pericope. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cambell-prince/ruby-pericope/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby::Pericope project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cambell-prince/ruby-pericope/blob/main/CODE_OF_CONDUCT.md).
