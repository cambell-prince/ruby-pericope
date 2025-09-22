# frozen_string_literal: true

require "set"
require_relative "book"
require_relative "verse_ref"
require_relative "errors"
require_relative "math_operations"

module Ruby
  module Pericope
    # Main class for parsing and manipulating pericopes
    class Pericope
      attr_reader :book, :ranges, :versification

      def initialize(reference_string, versification = nil)
        @versification = versification
        @ranges = []
        parse_reference(reference_string)
        @math_operations = MathOperations.new(self)
      end

      # Parse pericopes from text
      def self.parse(text, versification = nil)
        # Simple implementation - look for book codes followed by ranges
        pericopes = []

        # Pattern to match book codes and ranges
        pattern = /\b([A-Z]{3}|[1-3][A-Z]{2})\s+([0-9:,-]+)/i

        text.scan(pattern) do |book_code, range_text|
          pericope = new("#{book_code} #{range_text}", versification)
          pericopes << pericope
        rescue PericopeError
          # Skip invalid pericopes
          next
        end

        pericopes
      end

      # Split text on pericopes
      def self.split(text, versification = nil)
        pericopes = parse(text, versification)
        return [text] if pericopes.empty?

        # Simple implementation - just return the text as is for now
        [text]
      end

      # String representation
      def to_s(format = :canonical)
        return "" if @ranges.empty?

        case format
        when :full_name
          "#{@book.name} #{ranges_to_string}"
        else # :canonical, :abbreviated, or any other format
          "#{@book.code} #{ranges_to_string}"
        end
      end

      # Convert to array of VerseRef objects
      def to_a
        verses = []
        @ranges.each do |range|
          if range[:start_verse] == range[:end_verse] && range[:start_chapter] == range[:end_chapter]
            # Single verse
            verses << VerseRef.new(@book, range[:start_chapter], range[:start_verse])
          else
            # Range of verses
            (range[:start_chapter]..range[:end_chapter]).each do |chapter|
              start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
              end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @book.verse_count(chapter)

              (start_verse..end_verse).each do |verse|
                verses << VerseRef.new(@book, chapter, verse)
              end
            end
          end
        end
        verses
      end

      # Validation
      def valid?
        return false unless @book&.valid?
        return false if @ranges.empty?

        @ranges.all? do |range|
          range[:start_chapter].positive? && range[:end_chapter].positive? &&
            range[:start_verse].positive? && range[:end_verse].positive? &&
            range[:start_chapter] <= @book.chapter_count &&
            range[:end_chapter] <= @book.chapter_count
        end
      end

      def empty?
        @ranges.empty?
      end

      def single_verse?
        @ranges.length == 1 &&
          @ranges.first[:start_chapter] == @ranges.first[:end_chapter] &&
          @ranges.first[:start_verse] == @ranges.first[:end_verse]
      end

      def single_chapter?
        @ranges.all? { |range| range[:start_chapter] == range[:end_chapter] }
      end

      def spans_chapters?
        @ranges.any? { |range| range[:start_chapter] != range[:end_chapter] }
      end

      def spans_books?
        false # Single book implementation for now
      end

      # Basic counting operations
      def verse_count
        to_a.length
      end

      def chapter_count
        chapters = Set.new
        @ranges.each do |range|
          (range[:start_chapter]..range[:end_chapter]).each { |ch| chapters << ch }
        end
        chapters.size
      end

      def chapter_list
        chapters = Set.new
        @ranges.each do |range|
          (range[:start_chapter]..range[:end_chapter]).each { |ch| chapters << ch }
        end
        chapters.to_a.sort
      end

      def verse_list
        to_a
      end

      def first_verse
        return nil if @ranges.empty?

        first_range = @ranges.min_by { |r| [r[:start_chapter], r[:start_verse]] }
        VerseRef.new(@book, first_range[:start_chapter], first_range[:start_verse])
      end

      def last_verse
        return nil if @ranges.empty?

        last_range = @ranges.max_by { |r| [r[:end_chapter], r[:end_verse]] }
        VerseRef.new(@book, last_range[:end_chapter], last_range[:end_verse])
      end

      def range_count
        @ranges.length
      end

      # Advanced mathematical operations (Phase 3.3) - delegated to MathOperations
      def verses_in_chapter(chapter)
        @math_operations.verses_in_chapter(chapter)
      end

      def chapters_in_range
        @math_operations.chapters_in_range
      end

      def density
        @math_operations.density
      end

      def gaps
        @math_operations.gaps
      end

      def continuous_ranges
        @math_operations.continuous_ranges
      end

      # Comparison methods (Phase 3.4)
      def ==(other)
        return false unless other.is_a?(Pericope)

        @book == other.book && @ranges == other.ranges
      end

      def intersects?(other)
        @math_operations.intersects?(other)
      end

      def contains?(other)
        @math_operations.contains?(other)
      end

      def overlaps?(other)
        intersects?(other)
      end

      def adjacent_to?(other)
        @math_operations.adjacent_to?(other)
      end

      def precedes?(other)
        @math_operations.precedes?(other)
      end

      def follows?(other)
        @math_operations.follows?(other)
      end

      # Set operations (Pericope Math) - delegated to MathOperations
      def union(other)
        @math_operations.union(other)
      end

      def intersection(other)
        @math_operations.intersection(other)
      end

      def subtract(other)
        @math_operations.subtract(other)
      end

      def complement(scope = nil)
        @math_operations.complement(scope)
      end

      def normalize
        @math_operations.normalize
      end

      def expand(verses_before = 0, verses_after = 0)
        @math_operations.expand(verses_before, verses_after)
      end

      def contract(verses_from_start = 0, verses_from_end = 0)
        @math_operations.contract(verses_from_start, verses_from_end)
      end

      private

      def parse_reference(reference_string)
        if reference_string.nil? || reference_string.strip.empty?
          raise ParseError.new(reference_string,
                               "empty reference")
        end

        # Split book from ranges
        parts = reference_string.strip.split(/\s+/, 2)
        raise ParseError.new(reference_string, "no book found") if parts.empty?

        book_part = parts[0]
        range_part = parts[1] || "1:1"

        # Find book
        @book = Book.find_by_name(book_part)
        raise InvalidBookError, book_part unless @book

        # Parse ranges
        parse_ranges(range_part)
      end

      def parse_ranges(range_text)
        # Split on commas for multiple ranges
        range_parts = range_text.split(",").map(&:strip)
        current_chapter = nil

        range_parts.each do |part|
          current_chapter = parse_single_range(part, current_chapter)
        end
      end

      def parse_single_range(range_text, current_chapter = nil)
        # Handle different range formats:
        # "1:1" - single verse
        # "1:1-5" - verse range in same chapter
        # "1:1-2:5" - cross-chapter range
        # "3" - verse in current chapter (when current_chapter is set)

        if range_text.include?("-")
          # Range
          start_part, end_part = range_text.split("-", 2).map(&:strip)
          start_chapter, start_verse = parse_verse_reference(start_part, current_chapter)

          if end_part.include?(":")
            # Cross-chapter range like "1:1-2:5"
            end_chapter, end_verse = parse_verse_reference(end_part, start_chapter)
          else
            # Same chapter range like "1:1-5" or "5-7" (in current chapter)
            end_chapter = start_chapter
            end_verse = end_part.to_i
          end
        else
          # Single verse
          start_chapter, start_verse = parse_verse_reference(range_text, current_chapter)
          end_chapter = start_chapter
          end_verse = start_verse
        end

        @ranges << {
          start_chapter: start_chapter,
          start_verse: start_verse,
          end_chapter: end_chapter,
          end_verse: end_verse
        }

        # Return the chapter for context in next iteration
        start_chapter
      end

      def parse_verse_reference(verse_text, current_chapter = nil)
        if verse_text.include?(":")
          chapter, verse = verse_text.split(":", 2).map(&:to_i)
        elsif current_chapter
          # If we have a current chapter context, treat this as a verse in that chapter
          chapter = current_chapter
          verse = verse_text.to_i
        else
          # Assume it's just a chapter
          chapter = verse_text.to_i
          verse = 1
        end

        [chapter, verse]
      end

      def ranges_to_string
        @ranges.map do |range|
          if range[:start_chapter] == range[:end_chapter] && range[:start_verse] == range[:end_verse]
            # Single verse
            "#{range[:start_chapter]}:#{range[:start_verse]}"
          elsif range[:start_chapter] == range[:end_chapter]
            # Same chapter range
            "#{range[:start_chapter]}:#{range[:start_verse]}-#{range[:end_verse]}"
          else
            # Cross-chapter range
            "#{range[:start_chapter]}:#{range[:start_verse]}-#{range[:end_chapter]}:#{range[:end_verse]}"
          end
        end.join(",")
      end
    end
  end
end
