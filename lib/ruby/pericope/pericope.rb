# frozen_string_literal: true

require "set"
require_relative "book"
require_relative "verse_ref"
require_relative "errors"

module Ruby
  module Pericope
    # Main class for parsing and manipulating pericopes
    class Pericope
      attr_reader :book, :ranges, :versification

      def initialize(reference_string, versification = nil)
        @versification = versification
        @ranges = []
        parse_reference(reference_string)
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

      # Advanced mathematical operations (Phase 3.3)
      def verses_in_chapter(chapter)
        return 0 unless chapter.positive? && chapter <= @book.chapter_count

        count = 0
        @ranges.each do |range|
          next unless chapter.between?(range[:start_chapter], range[:end_chapter])

          start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
          end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @book.verse_count(chapter)

          count += (end_verse - start_verse + 1)
        end
        count
      end

      def chapters_in_range
        result = {}
        @ranges.each do |range|
          (range[:start_chapter]..range[:end_chapter]).each do |chapter|
            result[chapter] ||= []
            start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
            end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @book.verse_count(chapter)

            (start_verse..end_verse).each do |verse|
              result[chapter] << verse unless result[chapter].include?(verse)
            end
          end
        end
        result.each_value(&:sort!)
        result
      end

      def density
        return 0.0 if @ranges.empty?

        total_possible = 0
        included_verses = verse_count

        chapter_list.each do |chapter|
          total_possible += @book.verse_count(chapter)
        end

        return 0.0 if total_possible.zero?

        included_verses.to_f / total_possible
      end

      def gaps
        return [] if @ranges.empty? || single_verse?

        all_verses = Set.new
        @ranges.each do |range|
          (range[:start_chapter]..range[:end_chapter]).each do |chapter|
            start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
            end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @book.verse_count(chapter)

            (start_verse..end_verse).each do |verse|
              all_verses << VerseRef.new(@book, chapter, verse)
            end
          end
        end

        # Find the overall range
        first = first_verse
        last = last_verse
        return [] unless first && last

        # Generate all possible verses in the range
        possible_verses = []
        current = first
        while current <= last
          possible_verses << current
          current = current.next_verse
          break if current.nil? || current > last
        end

        # Find missing verses
        possible_verses.reject { |verse| all_verses.include?(verse) }
      end

      def continuous_ranges
        return [] if @ranges.empty?

        # Convert ranges to individual verses and sort them
        verses = to_a.sort
        return [self] if verses.length <= 1

        continuous_groups = []
        current_group = [verses.first]

        verses[1..].each do |verse|
          if current_group.last.next_verse == verse
            current_group << verse
          else
            continuous_groups << current_group
            current_group = [verse]
          end
        end
        continuous_groups << current_group

        # Convert back to Pericope objects
        continuous_groups.map do |group|
          if group.length == 1
            Pericope.new("#{@book.code} #{group.first.chapter}:#{group.first.verse}")
          else
            first_verse = group.first
            last_verse = group.last
            if first_verse.chapter == last_verse.chapter
              Pericope.new("#{@book.code} #{first_verse.chapter}:#{first_verse.verse}-#{last_verse.verse}")
            else
              range_str = "#{first_verse.chapter}:#{first_verse.verse}-#{last_verse.chapter}:#{last_verse.verse}"
              Pericope.new("#{@book.code} #{range_str}")
            end
          end
        end
      end

      # Comparison methods (Phase 3.4)
      def ==(other)
        return false unless other.is_a?(Pericope)

        @book == other.book && @ranges == other.ranges
      end

      def intersects?(other)
        return false unless other.is_a?(Pericope) && @book == other.book

        my_verses = Set.new(to_a)
        other_verses = Set.new(other.to_a)
        !(my_verses & other_verses).empty?
      end

      def contains?(other)
        return false unless other.is_a?(Pericope) && @book == other.book

        my_verses = Set.new(to_a)
        other_verses = Set.new(other.to_a)
        other_verses.subset?(my_verses)
      end

      def overlaps?(other)
        intersects?(other)
      end

      def adjacent_to?(other)
        return false unless other.is_a?(Pericope) && @book == other.book

        my_last = last_verse
        other_first = other.first_verse
        my_first = first_verse
        other_last = other.last_verse

        return false unless my_last && other_first && my_first && other_last

        # Check if my last verse is immediately before other's first verse
        # or other's last verse is immediately before my first verse
        (my_last.next_verse == other_first) || (other_last.next_verse == my_first)
      end

      def precedes?(other)
        return false unless other.is_a?(Pericope) && @book == other.book

        my_last = last_verse
        other_first = other.first_verse

        return false unless my_last && other_first

        my_last < other_first
      end

      def follows?(other)
        return false unless other.is_a?(Pericope) && @book == other.book

        my_first = first_verse
        other_last = other.last_verse

        return false unless my_first && other_last

        my_first > other_last
      end

      # Set operations (Pericope Math)
      def union(other)
        return self unless other.is_a?(Pericope) && @book == other.book

        combined_verses = Set.new(to_a) | Set.new(other.to_a)
        verses_to_pericope(combined_verses.to_a.sort)
      end

      def intersection(other)
        return create_empty_pericope unless other.is_a?(Pericope) && @book == other.book

        common_verses = Set.new(to_a) & Set.new(other.to_a)
        return create_empty_pericope if common_verses.empty?

        verses_to_pericope(common_verses.to_a.sort)
      end

      def subtract(other)
        return self unless other.is_a?(Pericope) && @book == other.book

        remaining_verses = Set.new(to_a) - Set.new(other.to_a)
        return create_empty_pericope if remaining_verses.empty?

        verses_to_pericope(remaining_verses.to_a.sort)
      end

      def complement(scope = nil)
        # Default scope is the entire book
        scope_verses = if scope.is_a?(Pericope) && scope.book == @book
                         Set.new(scope.to_a)
                       else
                         # Generate all verses in the book
                         all_verses = []
                         (1..@book.chapter_count).each do |chapter|
                           (1..@book.verse_count(chapter)).each do |verse|
                             all_verses << VerseRef.new(@book, chapter, verse)
                           end
                         end
                         Set.new(all_verses)
                       end

        my_verses = Set.new(to_a)
        complement_verses = scope_verses - my_verses
        return create_empty_pericope if complement_verses.empty?

        verses_to_pericope(complement_verses.to_a.sort)
      end

      def normalize
        return self if @ranges.empty?

        # Convert to verses, deduplicate, sort, and rebuild ranges
        verses = to_a.uniq.sort
        verses_to_pericope(verses)
      end

      def expand(verses_before = 0, verses_after = 0)
        return self if verses_before.zero? && verses_after.zero?

        expanded_verses = Set.new(to_a)

        # Add verses before
        if verses_before.positive?
          first = first_verse
          current = first
          verses_before.times do
            prev = current&.previous_verse
            break unless prev

            expanded_verses << prev
            current = prev
          end
        end

        # Add verses after
        if verses_after.positive?
          last = last_verse
          current = last
          verses_after.times do
            next_v = current&.next_verse
            break unless next_v

            expanded_verses << next_v
            current = next_v
          end
        end

        verses_to_pericope(expanded_verses.to_a.sort)
      end

      def contract(verses_from_start = 0, verses_from_end = 0)
        verses = to_a.sort
        return create_empty_pericope if verses.length <= (verses_from_start + verses_from_end)

        start_index = verses_from_start
        end_index = verses.length - verses_from_end - 1

        return create_empty_pericope if start_index > end_index

        contracted_verses = verses[start_index..end_index]
        verses_to_pericope(contracted_verses)
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

      # Helper method to create an empty pericope
      def create_empty_pericope
        empty_pericope = Pericope.new("#{@book.code} 1:1")
        empty_pericope.instance_variable_set(:@ranges, [])
        empty_pericope
      end

      # Helper method to convert sorted verses back to a Pericope
      def verses_to_pericope(verses)
        return create_empty_pericope if verses.empty?

        # Group consecutive verses into ranges
        ranges = []
        current_start = verses.first
        current_end = verses.first

        verses[1..].each do |verse|
          if current_end.next_verse == verse
            current_end = verse
          else
            # End current range and start new one
            ranges << build_range_hash(current_start, current_end)
            current_start = verse
            current_end = verse
          end
        end

        # Add the final range
        ranges << build_range_hash(current_start, current_end)

        # Create new Pericope with these ranges
        new_pericope = Pericope.new("#{@book.code} 1:1")
        new_pericope.instance_variable_set(:@ranges, ranges)
        new_pericope
      end

      def build_range_hash(start_verse, end_verse)
        {
          start_chapter: start_verse.chapter,
          start_verse: start_verse.verse,
          end_chapter: end_verse.chapter,
          end_verse: end_verse.verse
        }
      end
    end
  end
end
