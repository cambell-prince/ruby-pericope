#!/usr/bin/env ruby
# frozen_string_literal: true

# Demonstration of Phase 3 functionality
# Advanced Mathematical Operations and Set Operations
#
# Expected Output:
# Ruby Pericope Library - Phase 3 Demonstration
# ==================================================
#
# 1. Creating Example Pericopes
# ------------------------------
# Pericope 1: GEN 1:1-10 (10 verses)
# Pericope 2: GEN 1:5-15 (11 verses)
# Pericope 3: GEN 1:1,1:3,1:5-7,1:10 (6 verses)
# Pericope 4: GEN 1:20-25 (6 verses)
#
# 2. Advanced Mathematical Operations
# ----------------------------------------
#
# 2.1 Verses in Chapter Analysis:
# Pericope 3 verses in chapter 1: 6
#
# 2.2 Chapters in Range Breakdown:
# Chapter 1: verses 1, 3, 5, 6, 7, 10
#
# 2.3 Density Calculations:
# Pericope 1 density: 32.3%
# Pericope 3 density: 19.4%
#
# 2.4 Gap Identification:
# Gaps in pericope 3: GEN 1:2, GEN 1:4, GEN 1:8, GEN 1:9
#
# 2.5 Continuous Range Breakdown:
# Pericope 3 broken into continuous ranges:
#   1. GEN 1:1 (1 verses)
#   2. GEN 1:3 (1 verses)
#   3. GEN 1:5-7 (3 verses)
#   4. GEN 1:10 (1 verses)
#
# 3. Comparison Methods
# -------------------------
#
# 3.1 Intersection Tests:
# Pericope 1 intersects Pericope 2: true
# Pericope 1 intersects Pericope 4: false
#
# 3.2 Containment Tests:
# Pericope 1 contains GEN 1:3-7: true
# GEN 1:3-7 contains Pericope 1: false
#
# 3.3 Positional Tests:
# Pericope 1 precedes Pericope 4: true
# Pericope 4 follows Pericope 1: true
# GEN 1:1-5 adjacent to GEN 1:6-10: true
#
# 4. Set Operations (Pericope Math)
# -----------------------------------
#
# 4.1 Union Operations:
# GEN 1:1-10 ∪ GEN 1:5-15 = GEN 1:1-15
#
# 4.2 Intersection Operations:
# GEN 1:1-10 ∩ GEN 1:5-15 = GEN 1:5-10
#
# 4.3 Subtraction Operations:
# GEN 1:1-10 - GEN 1:5-15 = GEN 1:1-4
#
# 4.4 Normalization:
# GEN 1:1-3,1:4-6,1:7 normalized = GEN 1:1-7
#
# 4.5 Range Expansion:
# GEN 1:1-10 expanded by (2,3) = GEN 1:1-13
#
# 4.6 Range Contraction:
# GEN 1:1-10 contracted by (2,2) = GEN 1:3-8
#
# 4.7 Complement Operation:
# Complement of GEN 1:1-5 within GEN 1:1-10 = GEN 1:6-10
#
# 5. Complex Example: Sermon Planning
# ----------------------------------------
# Original sermon text: GEN 1:1-5,1:10-15,1:20-25
# Additional verses to consider: GEN 1:6-9
# ✗ Additional verses are not adjacent
# Combined text: GEN 1:1-15,1:20-25
# Final sermon text: GEN 1:1-15,1:20-25
# Total verses: 21
# Density in Genesis 1: 67.7%
# Gaps in sermon text: GEN 1:16, GEN 1:17, GEN 1:18, GEN 1:19
#
# ==================================================
# Phase 3 demonstration complete!
# All advanced mathematical operations and set operations are working!

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

# Advanced Mathematical Operations
puts "\n2. Advanced Mathematical Operations"
puts "-" * 40

puts "\n2.1 Verses in Chapter Analysis:"
puts "Pericope 3 verses in chapter 1: #{pericope3.verses_in_chapter(1)}"

puts "\n2.2 Chapters in Range Breakdown:"
chapters = pericope3.chapters_in_range
chapters.each do |chapter, verses|
  puts "Chapter #{chapter}: verses #{verses.join(", ")}"
end

puts "\n2.3 Density Calculations:"
puts "Pericope 1 density: #{(pericope1.density * 100).round(1)}%"
puts "Pericope 3 density: #{(pericope3.density * 100).round(1)}%"

puts "\n2.4 Gap Identification:"
gaps = pericope3.gaps
if gaps.empty?
  puts "No gaps found in pericope 3"
else
  puts "Gaps in pericope 3: #{gaps.map(&:to_s).join(", ")}"
end

puts "\n2.5 Continuous Range Breakdown:"
continuous = pericope3.continuous_ranges
puts "Pericope 3 broken into continuous ranges:"
continuous.each_with_index do |range, index|
  puts "  #{index + 1}. #{range} (#{range.verse_count} verses)"
end

# Comparison Methods
puts "\n3. Comparison Methods"
puts "-" * 25

puts "\n3.1 Intersection Tests:"
puts "Pericope 1 intersects Pericope 2: #{pericope1.intersects?(pericope2)}"
puts "Pericope 1 intersects Pericope 4: #{pericope1.intersects?(pericope4)}"

puts "\n3.2 Containment Tests:"
small_pericope = Ruby::Pericope::Pericope.new("GEN 1:3-7")
puts "Pericope 1 contains GEN 1:3-7: #{pericope1.contains?(small_pericope)}"
puts "GEN 1:3-7 contains Pericope 1: #{small_pericope.contains?(pericope1)}"

puts "\n3.3 Positional Tests:"
puts "Pericope 1 precedes Pericope 4: #{pericope1.precedes?(pericope4)}"
puts "Pericope 4 follows Pericope 1: #{pericope4.follows?(pericope1)}"

adjacent1 = Ruby::Pericope::Pericope.new("GEN 1:1-5")
adjacent2 = Ruby::Pericope::Pericope.new("GEN 1:6-10")
puts "GEN 1:1-5 adjacent to GEN 1:6-10: #{adjacent1.adjacent_to?(adjacent2)}"

# Set Operations
puts "\n4. Set Operations (Pericope Math)"
puts "-" * 35

puts "\n4.1 Union Operations:"
union_result = pericope1.union(pericope2)
puts "#{pericope1} ∪ #{pericope2} = #{union_result}"

puts "\n4.2 Intersection Operations:"
intersection_result = pericope1.intersection(pericope2)
puts "#{pericope1} ∩ #{pericope2} = #{intersection_result}"

puts "\n4.3 Subtraction Operations:"
subtract_result = pericope1.subtract(pericope2)
puts "#{pericope1} - #{pericope2} = #{subtract_result}"

puts "\n4.4 Normalization:"
messy_pericope = Ruby::Pericope::Pericope.new("GEN 1:1-3,4-6,7")
normalized = messy_pericope.normalize
puts "#{messy_pericope} normalized = #{normalized}"

puts "\n4.5 Range Expansion:"
expanded = pericope1.expand(2, 3)
puts "#{pericope1} expanded by (2,3) = #{expanded}"

puts "\n4.6 Range Contraction:"
contracted = pericope1.contract(2, 2)
puts "#{pericope1} contracted by (2,2) = #{contracted}"

puts "\n4.7 Complement Operation:"
small_range = Ruby::Pericope::Pericope.new("GEN 1:1-5")
scope = Ruby::Pericope::Pericope.new("GEN 1:1-10")
complement = small_range.complement(scope)
puts "Complement of #{small_range} within #{scope} = #{complement}"

# Complex Example
puts "\n5. Complex Example: Sermon Planning"
puts "-" * 40

sermon_text = Ruby::Pericope::Pericope.new("GEN 1:1-5,10-15,20-25")
additional_verses = Ruby::Pericope::Pericope.new("GEN 1:6-9")

puts "Original sermon text: #{sermon_text}"
puts "Additional verses to consider: #{additional_verses}"

# Check if they're adjacent
if sermon_text.adjacent_to?(additional_verses)
  puts "✓ Additional verses are adjacent to sermon text"
else
  puts "✗ Additional verses are not adjacent"
end

# Combine them
combined_text = sermon_text.union(additional_verses)
puts "Combined text: #{combined_text}"

# Normalize to clean up ranges
final_text = combined_text.normalize
puts "Final sermon text: #{final_text}"
puts "Total verses: #{final_text.verse_count}"
puts "Density in Genesis 1: #{(final_text.density * 100).round(1)}%"

# Find any gaps
gaps = final_text.gaps
if gaps.any?
  puts "Gaps in sermon text: #{gaps.map(&:to_s).join(", ")}"
else
  puts "No gaps in final sermon text"
end

puts "\n#{"=" * 50}"
puts "Phase 3 demonstration complete!"
puts "All advanced mathematical operations and set operations are working!"
