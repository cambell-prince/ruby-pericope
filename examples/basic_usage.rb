#!/usr/bin/env ruby
# frozen_string_literal: true

# Add lib to load path
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "ruby/pericope"

puts "Ruby Pericope Library - Basic Usage Examples"
puts "=" * 50

# Book examples
puts "\n1. Book Management:"
puts "-" * 20

# Find books by different methods
genesis = Ruby::Pericope::Book.find_by_code("GEN")
puts "Find by code 'GEN': #{genesis.name} (#{genesis.code})"

matthew = Ruby::Pericope::Book.find_by_name("Matthew")
puts "Find by name 'Matthew': #{matthew.name} (#{matthew.code})"

corinthians = Ruby::Pericope::Book.find_by_name("1 Corinthians")
puts "Find by name '1 Corinthians': #{corinthians.name} (#{corinthians.code})"

# Fuzzy matching
mathew = Ruby::Pericope::Book.find_by_name("Mathew") # misspelled
puts "Fuzzy match 'Mathew': #{mathew&.name} (#{mathew&.code})"

# Book properties
puts "\nBook properties:"
puts "Genesis - Old Testament? #{genesis.old_testament?}, Chapters: #{genesis.chapter_count}"
puts "Matthew - New Testament? #{matthew.new_testament?}, Chapters: #{matthew.chapter_count}"

# VerseRef examples
puts "\n2. Verse References:"
puts "-" * 20

verse1 = Ruby::Pericope::VerseRef.new("GEN", 1, 1)
puts "Genesis 1:1: #{verse1}"
puts "As integer: #{verse1.to_i}"

verse2 = Ruby::Pericope::VerseRef.new("MAT", 5, 3)
puts "Matthew 5:3: #{verse2}"

# Comparison
puts "Genesis 1:1 before Matthew 5:3? #{verse1.before?(verse2)}"

# Navigation
next_verse = verse1.next_verse
puts "Next verse after Genesis 1:1: #{next_verse}"

# Pericope examples
puts "\n3. Pericope Parsing:"
puts "-" * 20

# Single verse
pericope1 = Ruby::Pericope::Pericope.new("GEN 1:1")
puts "Single verse: #{pericope1}"
puts "Verse count: #{pericope1.verse_count}"
puts "Single verse? #{pericope1.single_verse?}"

# Verse range
pericope2 = Ruby::Pericope::Pericope.new("GEN 1:1-3")
puts "\nVerse range: #{pericope2}"
puts "Verse count: #{pericope2.verse_count}"
puts "Verses: #{pericope2.to_a.map(&:to_s).join(", ")}"

# Cross-chapter range
pericope3 = Ruby::Pericope::Pericope.new("GEN 1:30-2:2")
puts "\nCross-chapter range: #{pericope3}"
puts "Spans chapters? #{pericope3.spans_chapters?}"
puts "Chapter count: #{pericope3.chapter_count}"
puts "First verse: #{pericope3.first_verse}"
puts "Last verse: #{pericope3.last_verse}"

# Multiple ranges
pericope4 = Ruby::Pericope::Pericope.new("GEN 1:1,3,5")
puts "\nMultiple ranges: #{pericope4}"
puts "Range count: #{pericope4.range_count}"

# Different formats
puts "\nOutput formats:"
puts "Canonical: #{pericope2.to_s(:canonical)}"
puts "Full name: #{pericope2.to_s(:full_name)}"
puts "Abbreviated: #{pericope2.to_s(:abbreviated)}"

# Text parsing
puts "\n4. Text Parsing:"
puts "-" * 20

text = "In the beginning (GEN 1:1), God created the heavens and earth. " \
       "Later, Jesus taught about the Beatitudes in MAT 5:3-12."
pericopes = Ruby::Pericope::Pericope.parse(text)

puts "Text: #{text}"
puts "\nFound pericopes:"
pericopes.each_with_index do |pericope, index|
  puts "#{index + 1}. #{pericope} (#{pericope.verse_count} verses)"
end

# Error handling
puts "\n5. Error Handling:"
puts "-" * 20

begin
  Ruby::Pericope::Pericope.new("INVALID 1:1")
rescue Ruby::Pericope::InvalidBookError => e
  puts "Invalid book error: #{e.message}"
end

begin
  Ruby::Pericope::Pericope.new("")
rescue Ruby::Pericope::ParseError => e
  puts "Parse error: #{e.message}"
end

# Book statistics
puts "\n6. Library Statistics:"
puts "-" * 20

all_books = Ruby::Pericope::Book.all_books
old_testament = Ruby::Pericope::Book.testament_books(:old)
new_testament = Ruby::Pericope::Book.testament_books(:new)

puts "Total books: #{all_books.length}"
puts "Old Testament books: #{old_testament.length}"
puts "New Testament books: #{new_testament.length}"

puts "\nFirst few Old Testament books:"
old_testament.first(5).each { |book| puts "  #{book.number}. #{book.name} (#{book.code})" }

puts "\nFirst few New Testament books:"
new_testament.first(5).each { |book| puts "  #{book.number}. #{book.name} (#{book.code})" }

puts "\n#{"=" * 50}"
puts "Ruby Pericope Library - Examples Complete"
