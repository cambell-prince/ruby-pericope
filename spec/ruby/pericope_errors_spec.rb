# frozen_string_literal: true

RSpec.describe Ruby::Pericope do
  describe "error classes" do
    describe Ruby::Pericope::PericopeError do
      it "is a StandardError" do
        expect(described_class.new).to be_a(StandardError)
      end
    end

    describe Ruby::Pericope::InvalidBookError do
      it "inherits from PericopeError" do
        expect(described_class.new("GEN")).to be_a(Ruby::Pericope::PericopeError)
      end

      it "includes the book input in the message" do
        error = described_class.new("INVALID")
        expect(error.message).to eq("Invalid book: 'INVALID'")
      end
    end

    describe Ruby::Pericope::InvalidChapterError do
      it "inherits from PericopeError" do
        expect(described_class.new("GEN", 99)).to be_a(Ruby::Pericope::PericopeError)
      end

      it "includes book and chapter in the message" do
        error = described_class.new("GEN", 99)
        expect(error.message).to eq("Invalid chapter 99 for book GEN")
      end
    end

    describe Ruby::Pericope::InvalidVerseError do
      it "inherits from PericopeError" do
        expect(described_class.new("GEN", 1, 99)).to be_a(Ruby::Pericope::PericopeError)
      end

      it "includes book, chapter, and verse in the message" do
        error = described_class.new("GEN", 1, 99)
        expect(error.message).to eq("Invalid verse 1:99 for book GEN")
      end
    end

    describe Ruby::Pericope::InvalidRangeError do
      it "inherits from PericopeError" do
        expect(described_class.new("1:1-")).to be_a(Ruby::Pericope::PericopeError)
      end

      it "includes the range text in the message" do
        error = described_class.new("1:1-")
        expect(error.message).to eq("Invalid range: '1:1-'")
      end
    end

    describe Ruby::Pericope::ParseError do
      it "inherits from PericopeError" do
        expect(described_class.new("invalid")).to be_a(Ruby::Pericope::PericopeError)
      end

      it "includes the text in the message" do
        error = described_class.new("invalid text")
        expect(error.message).to eq("Failed to parse: 'invalid text'")
      end

      it "includes reason when provided" do
        error = described_class.new("invalid text", "no book found")
        expect(error.message).to eq("Failed to parse: 'invalid text' - no book found")
      end
    end
  end
end
