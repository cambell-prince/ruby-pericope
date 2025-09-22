# frozen_string_literal: true

require "set"
require_relative "book"
require_relative "verse_ref"
require_relative "errors"
require_relative "text_processor"
require_relative "math_operations"
require_relative "set_operations"

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
      TextProcessor.parse(text, versification)
    end

    # Split text on pericopes
    def self.split(text, versification = nil)
      TextProcessor.split(text, versification)
    end

    # String representation
    def to_s(format = :canonical)
      TextProcessor.format_pericope(self, format)
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
      chapters = ::Set.new
      @ranges.each do |range|
        (range[:start_chapter]..range[:end_chapter]).each { |ch| chapters << ch }
      end
      chapters.size
    end

    def chapter_list
      chapters = ::Set.new
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

    # Advanced mathematical operations (Phase 3.3) - delegated to MathOperations module
    def verses_in_chapter(chapter)
      MathOperations.verses_in_chapter(self, chapter)
    end

    def chapters_in_range
      MathOperations.chapters_in_range(self)
    end

    def density
      MathOperations.density(self)
    end

    def gaps
      MathOperations.gaps(self)
    end

    def continuous_ranges
      MathOperations.continuous_ranges(self)
    end

    # Comparison methods (Phase 3.4)
    def ==(other)
      return false unless other.is_a?(Pericope)

      @book == other.book && @ranges == other.ranges
    end

    def intersects?(other)
      MathOperations.intersects?(self, other)
    end

    def contains?(other)
      MathOperations.contains?(self, other)
    end

    def overlaps?(other)
      intersects?(other)
    end

    def adjacent_to?(other)
      MathOperations.adjacent_to?(self, other)
    end

    def precedes?(other)
      MathOperations.precedes?(self, other)
    end

    def follows?(other)
      MathOperations.follows?(self, other)
    end

    # Set operations (Pericope MathOperations) - delegated to SetOperations module
    def union(other)
      SetOperations.union(self, other)
    end

    def intersection(other)
      SetOperations.intersection(self, other)
    end

    def subtract(other)
      SetOperations.subtract(self, other)
    end

    def complement(scope = nil)
      SetOperations.complement(self, scope)
    end

    def normalize
      SetOperations.normalize(self)
    end

    def expand(verses_before = 0, verses_after = 0)
      SetOperations.expand(self, verses_before, verses_after)
    end

    def contract(verses_from_start = 0, verses_from_end = 0)
      SetOperations.contract(self, verses_from_start, verses_from_end)
    end

    private

    def parse_reference(reference_string)
      result = TextProcessor.parse_reference(reference_string, @versification)
      @book = result[:book]
      @ranges = result[:ranges]
    end
  end
end
