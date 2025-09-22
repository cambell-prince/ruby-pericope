# frozen_string_literal: true

module Ruby
  module Pericope
    # Base error class for all pericope-related errors
    class PericopeError < StandardError; end

    # Raised when an invalid book code or name is provided
    class InvalidBookError < PericopeError
      def initialize(book_input)
        super("Invalid book: '#{book_input}'")
      end
    end

    # Raised when an invalid chapter number is provided
    class InvalidChapterError < PericopeError
      def initialize(book, chapter)
        super("Invalid chapter #{chapter} for book #{book}")
      end
    end

    # Raised when an invalid verse number is provided
    class InvalidVerseError < PericopeError
      def initialize(book, chapter, verse)
        super("Invalid verse #{chapter}:#{verse} for book #{book}")
      end
    end

    # Raised when an invalid range is provided
    class InvalidRangeError < PericopeError
      def initialize(range_text)
        super("Invalid range: '#{range_text}'")
      end
    end

    # Raised when parsing fails
    class ParseError < PericopeError
      def initialize(text, reason = nil)
        message = "Failed to parse: '#{text}'"
        message += " - #{reason}" if reason
        super(message)
      end
    end
  end
end
