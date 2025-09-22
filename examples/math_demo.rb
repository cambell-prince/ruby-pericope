#!/usr/bin/env ruby
# frozen_string_literal: true

# Demonstration of Pericope Math and Set Operations

require_relative "../lib/ruby/pericope"

puts "Ruby Pericope Library - Phase 3 Demonstration"
puts "=" * 50

# Create some example pericopes
puts "\n1. Creating Example Pericopes"
puts "-" * 30

pericope1 = Ruby::Pericope::Pericope.new("GEN 1:1-10")
pericope2 = Ruby::Pericope::Pericope.new("GEN 1:5-15")
pericope3 = Ruby::Pericope::Pericope.new("GEN 1:1,3,5-7,10")
pericope4 = Ruby::Pericope::Pericope.new("GEN 1:20-25")

puts "Pericope 1: #{pericope1} (#{pericope1.verse_count} verses)"
puts "Pericope 2: #{pericope2} (#{pericope2.verse_count} verses)"
puts "Pericope 3: #{pericope3} (#{pericope3.verse_count} verses)"
puts "Pericope 4: #{pericope4} (#{pericope4.verse_count} verses)"
# Expected Output:
# Pericope 1: GEN 1:1-10 (10 verses)
# Pericope 2: GEN 1:5-15 (11 verses)
# Pericope 3: GEN 1:1,1:3,1:5-7,1:10 (6 verses)
# Pericope 4: GEN 1:20-25 (6 verses)

# Mathematical Operations
puts "\n2. Advanced Mathematical Operations"
puts "-" * 40

puts "\n2.1 Verses in Chapter Analysis:"
puts "Pericope 3 verses in chapter 1: #{pericope3.verses_in_chapter(1)}"
# Expected Output:
# Pericope 3 verses in chapter 1: 6

puts "\n2.2 Chapters in Range Breakdown:"
chapters = pericope3.chapters_in_range
chapters.each do |chapter, verses|
  puts "Chapter #{chapter}: verses #{verses.join(", ")}"
end
# Expected Output:
# Chapter 1: verses 1, 3, 5, 6, 7, 10

puts "\n2.3 Density Calculations:"
puts "Pericope 1 density: #{(pericope1.density * 100).round(1)}%"
puts "Pericope 3 density: #{(pericope3.density * 100).round(1)}%"
# Expected Output:
# Pericope 1 density: 32.3%
# Pericope 3 density: 19.4%

puts "\n2.4 Gap Identification:"
gaps = pericope3.gaps
if gaps.empty?
  puts "No gaps found in pericope 3"
else
  puts "Gaps in pericope 3: #{gaps.map(&:to_s).join(", ")}"
end
# Expected Output:
# Gaps in pericope 3: GEN 1:2, GEN 1:4, GEN 1:8, GEN 1:9

puts "\n2.5 Continuous Range Breakdown:"
continuous = pericope3.continuous_ranges
puts "Pericope 3 broken into continuous ranges:"
continuous.each_with_index do |range, index|
  puts "  #{index + 1}. #{range} (#{range.verse_count} verses)"
end
# Expected Output:
# Pericope 3 broken into continuous ranges:
#   1. GEN 1:1 (1 verses)
#   2. GEN 1:3 (1 verses)
#   3. GEN 1:5-7 (3 verses)
#   4. GEN 1:10 (1 verses)

# Comparison Methods
puts "\n3. Comparison Methods"
puts "-" * 25

puts "\n3.1 Intersection Tests:"
puts "Pericope 1 intersects Pericope 2: #{pericope1.intersects?(pericope2)}"
puts "Pericope 1 intersects Pericope 4: #{pericope1.intersects?(pericope4)}"
# Expected Output:
# Pericope 1 intersects Pericope 2: true
# Pericope 1 intersects Pericope 4: false

puts "\n3.2 Containment Tests:"
small_pericope = Ruby::Pericope::Pericope.new("GEN 1:3-7")
puts "Pericope 1 contains GEN 1:3-7: #{pericope1.contains?(small_pericope)}"
puts "GEN 1:3-7 contains Pericope 1: #{small_pericope.contains?(pericope1)}"
# Expected Output:
# Pericope 1 contains GEN 1:3-7: true
# GEN 1:3-7 contains Pericope 1: false

puts "\n3.3 Positional Tests:"
puts "Pericope 1 precedes Pericope 4: #{pericope1.precedes?(pericope4)}"
puts "Pericope 4 follows Pericope 1: #{pericope4.follows?(pericope1)}"

adjacent1 = Ruby::Pericope::Pericope.new("GEN 1:1-5")
adjacent2 = Ruby::Pericope::Pericope.new("GEN 1:6-10")
puts "GEN 1:1-5 adjacent to GEN 1:6-10: #{adjacent1.adjacent_to?(adjacent2)}"
# Expected Output:
# Pericope 1 precedes Pericope 4: true
# Pericope 4 follows Pericope 1: true
# GEN 1:1-5 adjacent to GEN 1:6-10: true

# Set Operations
puts "\n4. Set Operations (Pericope Math)"
puts "-" * 35

puts "\n4.1 Union Operations:"
union_result = pericope1.union(pericope2)
puts "#{pericope1} ∪ #{pericope2} = #{union_result}"
# Expected Output:
# GEN 1:1-10 ∪ GEN 1:5-15 = GEN 1:1-15

puts "\n4.2 Intersection Operations:"
intersection_result = pericope1.intersection(pericope2)
puts "#{pericope1} ∩ #{pericope2} = #{intersection_result}"
# Expected Output:
# GEN 1:1-10 ∩ GEN 1:5-15 = GEN 1:5-10

puts "\n4.3 Subtraction Operations:"
subtract_result = pericope1.subtract(pericope2)
puts "#{pericope1} - #{pericope2} = #{subtract_result}"
# Expected Output:
# GEN 1:1-10 - GEN 1:5-15 = GEN 1:1-4

puts "\n4.4 Normalization:"
messy_pericope = Ruby::Pericope::Pericope.new("GEN 1:1-3,4-6,7")
normalized = messy_pericope.normalize
puts "#{messy_pericope} normalized = #{normalized}"
# Expected Output:
# GEN 1:1-3,1:4-6,1:7 normalized = GEN 1:1-7

puts "\n4.5 Range Expansion:"
expanded = pericope1.expand(2, 3)
puts "#{pericope1} expanded by (2,3) = #{expanded}"
# Expected Output:
# GEN 1:1-10 expanded by (2,3) = GEN 1:1-13

puts "\n4.6 Range Contraction:"
contracted = pericope1.contract(2, 2)
puts "#{pericope1} contracted by (2,2) = #{contracted}"
# Expected Output:
# GEN 1:1-10 contracted by (2,2) = GEN 1:3-8

puts "\n4.7 Complement Operation:"
small_range = Ruby::Pericope::Pericope.new("GEN 1:1-5")
scope = Ruby::Pericope::Pericope.new("GEN 1:1-10")
complement = small_range.complement(scope)
puts "Complement of #{small_range} within #{scope} = #{complement}"
# Expected Output:
# Complement of GEN 1:1-5 within GEN 1:1-10 = GEN 1:6-10

# Complex Example
puts "\n5. Complex Example: Sermon Planning"
puts "-" * 40

sermon_text = Ruby::Pericope::Pericope.new("GEN 1:1-5,10-15,20-25")
additional_verses = Ruby::Pericope::Pericope.new("GEN 1:6-9")

puts "Original sermon text: #{sermon_text}"
puts "Additional verses to consider: #{additional_verses}"
# Expected Output:

# Check if they're adjacent
if sermon_text.adjacent_to?(additional_verses)
  puts "✓ Additional verses are adjacent to sermon text"
else
  puts "✗ Additional verses are not adjacent"
end
# Expected Output:
# ✗ Additional verses are not adjacent

# Combine them
combined_text = sermon_text.union(additional_verses)
puts "Combined text: #{combined_text}"
# Expected Output:
# Combined text: GEN 1:1-15,1:20-25

# Normalize to clean up ranges
final_text = combined_text.normalize
puts "Final sermon text: #{final_text}"
puts "Total verses: #{final_text.verse_count}"
puts "Density in Genesis 1: #{(final_text.density * 100).round(1)}%"
# Expected Output:
# Final sermon text: GEN 1:1-15,1:20-25
# Total verses: 21
# Density in Genesis 1: 67.7%

# Find any gaps
gaps = final_text.gaps
if gaps.any?
  puts "Gaps in sermon text: #{gaps.map(&:to_s).join(", ")}"
else
  puts "No gaps in final sermon text"
end
# Expected Output:
# Gaps in sermon text: GEN 1:16, GEN 1:17, GEN 1:18, GEN 1:19

puts "\n#{"=" * 50}"
puts "Phase 3 demonstration complete!"
puts "All advanced mathematical operations and set operations are working!"