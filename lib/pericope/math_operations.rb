# frozen_string_literal: true

require "set"

module Pericope
  # Handles mathematical and set operations for Pericope objects
  # This class delegates operations from the main Pericope class to keep it focused
  class MathOperations
    def initialize(pericope)
      @pericope = pericope
    end

    # Advanced mathematical operations
    def verses_in_chapter(chapter)
      return 0 unless chapter.positive? && chapter <= @pericope.book.chapter_count

      count = 0
      @pericope.ranges.each do |range|
        next unless chapter.between?(range[:start_chapter], range[:end_chapter])

        start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
        end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @pericope.book.verse_count(chapter)

        count += (end_verse - start_verse + 1)
      end
      count
    end

    def chapters_in_range
      result = {}
      @pericope.ranges.each do |range|
        (range[:start_chapter]..range[:end_chapter]).each do |chapter|
          result[chapter] ||= []
          start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
          end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @pericope.book.verse_count(chapter)

          (start_verse..end_verse).each do |verse|
            result[chapter] << verse unless result[chapter].include?(verse)
          end
        end
      end
      result.each_value(&:sort!)
      result
    end

    def density
      return 0.0 if @pericope.ranges.empty?

      total_possible = 0
      included_verses = @pericope.verse_count

      @pericope.chapter_list.each do |chapter|
        total_possible += @pericope.book.verse_count(chapter)
      end

      return 0.0 if total_possible.zero?

      included_verses.to_f / total_possible
    end

    def gaps
      return [] if @pericope.ranges.empty? || @pericope.single_verse?

      all_verses = collect_all_verses
      first = @pericope.first_verse
      last = @pericope.last_verse
      return [] unless first && last

      possible_verses = generate_possible_verses(first, last)
      possible_verses.reject { |verse| all_verses.include?(verse) }
    end

    def continuous_ranges
      return [] if @pericope.ranges.empty?

      verses = @pericope.to_a.sort
      return [@pericope] if verses.length <= 1

      continuous_groups = group_consecutive_verses(verses)
      continuous_groups.map { |group| create_pericope_from_group(group) }
    end

    # Comparison methods
    def intersects?(other)
      return false unless valid_comparison_target?(other)

      my_verses = Set.new(@pericope.to_a)
      other_verses = Set.new(other.to_a)
      !(my_verses & other_verses).empty?
    end

    def contains?(other)
      return false unless valid_comparison_target?(other)

      my_verses = Set.new(@pericope.to_a)
      other_verses = Set.new(other.to_a)
      other_verses.subset?(my_verses)
    end

    def adjacent_to?(other)
      return false unless valid_comparison_target?(other)

      my_last = @pericope.last_verse
      other_first = other.first_verse
      my_first = @pericope.first_verse
      other_last = other.last_verse

      return false unless my_last && other_first && my_first && other_last

      (my_last.next_verse == other_first) || (other_last.next_verse == my_first)
    end

    def precedes?(other)
      return false unless valid_comparison_target?(other)

      my_last = @pericope.last_verse
      other_first = other.first_verse

      return false unless my_last && other_first

      my_last < other_first
    end

    def follows?(other)
      return false unless valid_comparison_target?(other)

      my_first = @pericope.first_verse
      other_last = other.last_verse

      return false unless my_first && other_last

      my_first > other_last
    end

    # Set operations
    def union(other)
      return @pericope unless valid_set_operation_target?(other)

      combined_verses = Set.new(@pericope.to_a) | Set.new(other.to_a)
      verses_to_pericope(combined_verses.to_a.sort)
    end

    def intersection(other)
      return create_empty_pericope unless valid_set_operation_target?(other)

      common_verses = Set.new(@pericope.to_a) & Set.new(other.to_a)
      return create_empty_pericope if common_verses.empty?

      verses_to_pericope(common_verses.to_a.sort)
    end

    def subtract(other)
      return @pericope unless valid_set_operation_target?(other)

      remaining_verses = Set.new(@pericope.to_a) - Set.new(other.to_a)
      return create_empty_pericope if remaining_verses.empty?

      verses_to_pericope(remaining_verses.to_a.sort)
    end

    def complement(scope = nil)
      scope_verses = determine_scope_verses(scope)
      my_verses = Set.new(@pericope.to_a)
      complement_verses = scope_verses - my_verses
      return create_empty_pericope if complement_verses.empty?

      verses_to_pericope(complement_verses.to_a.sort)
    end

    def normalize
      return @pericope if @pericope.ranges.empty?

      verses = @pericope.to_a.uniq.sort
      verses_to_pericope(verses)
    end

    def expand(verses_before = 0, verses_after = 0)
      return @pericope if verses_before.zero? && verses_after.zero?

      expanded_verses = Set.new(@pericope.to_a)
      add_verses_before(expanded_verses, verses_before)
      add_verses_after(expanded_verses, verses_after)

      verses_to_pericope(expanded_verses.to_a.sort)
    end

    def contract(verses_from_start = 0, verses_from_end = 0)
      verses = @pericope.to_a.sort
      return create_empty_pericope if verses.length <= (verses_from_start + verses_from_end)

      start_index = verses_from_start
      end_index = verses.length - verses_from_end - 1

      return create_empty_pericope if start_index > end_index

      contracted_verses = verses[start_index..end_index]
      verses_to_pericope(contracted_verses)
    end

    private

    def valid_comparison_target?(other)
      other.is_a?(Pericope) && @pericope.book == other.book
    end

    def valid_set_operation_target?(other)
      other.is_a?(Pericope) && @pericope.book == other.book
    end

    def collect_all_verses
      all_verses = Set.new
      @pericope.ranges.each do |range|
        (range[:start_chapter]..range[:end_chapter]).each do |chapter|
          start_verse = chapter == range[:start_chapter] ? range[:start_verse] : 1
          end_verse = chapter == range[:end_chapter] ? range[:end_verse] : @pericope.book.verse_count(chapter)

          (start_verse..end_verse).each do |verse|
            all_verses << VerseRef.new(@pericope.book, chapter, verse)
          end
        end
      end
      all_verses
    end

    def generate_possible_verses(first, last)
      possible_verses = []
      current = first
      while current <= last
        possible_verses << current
        current = current.next_verse
        break if current.nil? || current > last
      end
      possible_verses
    end

    def group_consecutive_verses(verses)
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
      continuous_groups
    end

    def create_pericope_from_group(group)
      return create_single_verse_pericope(group.first) if group.length == 1

      create_range_pericope(group.first, group.last)
    end

    def create_single_verse_pericope(verse)
      Pericope.new("#{@pericope.book.code} #{verse.chapter}:#{verse.verse}")
    end

    def create_range_pericope(first_verse, last_verse)
      if first_verse.chapter == last_verse.chapter
        Pericope.new("#{@pericope.book.code} #{first_verse.chapter}:#{first_verse.verse}-#{last_verse.verse}")
      else
        range_str = "#{first_verse.chapter}:#{first_verse.verse}-#{last_verse.chapter}:#{last_verse.verse}"
        Pericope.new("#{@pericope.book.code} #{range_str}")
      end
    end

    def determine_scope_verses(scope)
      if scope.is_a?(Pericope) && scope.book == @pericope.book
        Set.new(scope.to_a)
      else
        generate_all_book_verses
      end
    end

    def generate_all_book_verses
      all_verses = []
      (1..@pericope.book.chapter_count).each do |chapter|
        (1..@pericope.book.verse_count(chapter)).each do |verse|
          all_verses << VerseRef.new(@pericope.book, chapter, verse)
        end
      end
      Set.new(all_verses)
    end

    def add_verses_before(expanded_verses, verses_before)
      return unless verses_before.positive?

      first = @pericope.first_verse
      current = first
      verses_before.times do
        prev = current&.previous_verse
        break unless prev

        expanded_verses << prev
        current = prev
      end
    end

    def add_verses_after(expanded_verses, verses_after)
      return unless verses_after.positive?

      last = @pericope.last_verse
      current = last
      verses_after.times do
        next_v = current&.next_verse
        break unless next_v

        expanded_verses << next_v
        current = next_v
      end
    end

    def create_empty_pericope
      empty_pericope = Pericope.new("#{@pericope.book.code} 1:1")
      empty_pericope.instance_variable_set(:@ranges, [])
      empty_pericope
    end

    def verses_to_pericope(verses)
      return create_empty_pericope if verses.empty?

      ranges = build_ranges_from_verses(verses)
      new_pericope = Pericope.new("#{@pericope.book.code} 1:1")
      new_pericope.instance_variable_set(:@ranges, ranges)
      new_pericope
    end

    def build_ranges_from_verses(verses)
      ranges = []
      current_start = verses.first
      current_end = verses.first

      verses[1..].each do |verse|
        if current_end.next_verse == verse
          current_end = verse
        else
          ranges << build_range_hash(current_start, current_end)
          current_start = verse
          current_end = verse
        end
      end

      ranges << build_range_hash(current_start, current_end)
      ranges
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
