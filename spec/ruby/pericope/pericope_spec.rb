# frozen_string_literal: true

RSpec.describe Ruby::Pericope::Pericope do
  describe "#initialize" do
    it "parses a simple verse reference" do
      pericope = described_class.new("GEN 1:1")
      expect(pericope.book.code).to eq("GEN")
      expect(pericope.to_s).to eq("GEN 1:1")
    end

    it "parses a verse range" do
      pericope = described_class.new("GEN 1:1-3")
      expect(pericope.to_s).to eq("GEN 1:1-3")
    end

    it "parses a cross-chapter range" do
      pericope = described_class.new("GEN 1:1-2:3")
      expect(pericope.to_s).to eq("GEN 1:1-2:3")
    end

    it "parses multiple ranges" do
      pericope = described_class.new("GEN 1:1,3,5")
      expect(pericope.range_count).to eq(3)
    end

    it "raises ParseError for empty reference" do
      expect { described_class.new("") }.to raise_error(Ruby::Pericope::ParseError)
      expect { described_class.new(nil) }.to raise_error(Ruby::Pericope::ParseError)
    end

    it "raises InvalidBookError for invalid book" do
      expect { described_class.new("INVALID 1:1") }.to raise_error(Ruby::Pericope::InvalidBookError)
    end

    it "handles book names with flexible matching" do
      pericope = described_class.new("Genesis 1:1")
      expect(pericope.book.code).to eq("GEN")
    end

    it "defaults to chapter 1 verse 1 if no range provided" do
      pericope = described_class.new("GEN")
      expect(pericope.to_s).to eq("GEN 1:1")
    end
  end

  describe ".parse" do
    it "extracts pericopes from text" do
      text = "See GEN 1:1 and MAT 5:3-12 for examples"
      pericopes = described_class.parse(text)

      expect(pericopes.length).to eq(2)
      expect(pericopes[0].to_s).to eq("GEN 1:1")
      expect(pericopes[1].to_s).to eq("MAT 5:3-12")
    end

    it "returns empty array for text with no pericopes" do
      text = "This text has no biblical references"
      pericopes = described_class.parse(text)
      expect(pericopes).to be_empty
    end

    it "skips invalid references" do
      text = "See GEN 1:1 and INVALID 1:1"
      pericopes = described_class.parse(text)

      expect(pericopes.length).to eq(1)
      expect(pericopes[0].to_s).to eq("GEN 1:1")
    end
  end

  describe "#to_s" do
    let(:pericope) { described_class.new("GEN 1:1-3") }

    it "returns canonical format by default" do
      expect(pericope.to_s).to eq("GEN 1:1-3")
    end

    it "returns canonical format when specified" do
      expect(pericope.to_s(:canonical)).to eq("GEN 1:1-3")
    end

    it "returns full name format when specified" do
      expect(pericope.to_s(:full_name)).to eq("Genesis 1:1-3")
    end

    it "returns abbreviated format when specified" do
      expect(pericope.to_s(:abbreviated)).to eq("GEN 1:1-3")
    end

    it "returns empty string for empty pericope" do
      pericope = described_class.new("GEN 1:1")
      pericope.instance_variable_set(:@ranges, [])
      expect(pericope.to_s).to eq("")
    end
  end

  describe "#to_a" do
    it "returns array of VerseRef objects for single verse" do
      pericope = described_class.new("GEN 1:1")
      verses = pericope.to_a

      expect(verses.length).to eq(1)
      expect(verses[0]).to be_a(Ruby::Pericope::VerseRef)
      expect(verses[0].to_s).to eq("GEN 1:1")
    end

    it "returns array of VerseRef objects for verse range" do
      pericope = described_class.new("GEN 1:1-3")
      verses = pericope.to_a

      expect(verses.length).to eq(3)
      expect(verses.map(&:to_s)).to eq(["GEN 1:1", "GEN 1:2", "GEN 1:3"])
    end

    it "handles cross-chapter ranges" do
      pericope = described_class.new("GEN 1:30-2:2")
      verses = pericope.to_a

      expect(verses.length).to be > 3 # Should include verses from both chapters
      expect(verses.first.to_s).to eq("GEN 1:30")
      expect(verses.last.to_s).to eq("GEN 2:2")
    end
  end

  describe "validation methods" do
    let(:valid_pericope) { described_class.new("GEN 1:1") }
    let(:empty_pericope) do
      pericope = described_class.new("GEN 1:1")
      pericope.instance_variable_set(:@ranges, [])
      pericope
    end

    describe "#valid?" do
      it "returns true for valid pericope" do
        expect(valid_pericope.valid?).to be true
      end

      it "returns false for empty pericope" do
        expect(empty_pericope.valid?).to be false
      end
    end

    describe "#empty?" do
      it "returns false for non-empty pericope" do
        expect(valid_pericope.empty?).to be false
      end

      it "returns true for empty pericope" do
        expect(empty_pericope.empty?).to be true
      end
    end

    describe "#single_verse?" do
      it "returns true for single verse" do
        pericope = described_class.new("GEN 1:1")
        expect(pericope.single_verse?).to be true
      end

      it "returns false for verse range" do
        pericope = described_class.new("GEN 1:1-3")
        expect(pericope.single_verse?).to be false
      end
    end

    describe "#single_chapter?" do
      it "returns true for single chapter" do
        pericope = described_class.new("GEN 1:1-3")
        expect(pericope.single_chapter?).to be true
      end

      it "returns false for cross-chapter range" do
        pericope = described_class.new("GEN 1:1-2:3")
        expect(pericope.single_chapter?).to be false
      end
    end

    describe "#spans_chapters?" do
      it "returns false for single chapter" do
        pericope = described_class.new("GEN 1:1-3")
        expect(pericope.spans_chapters?).to be false
      end

      it "returns true for cross-chapter range" do
        pericope = described_class.new("GEN 1:1-2:3")
        expect(pericope.spans_chapters?).to be true
      end
    end

    describe "#spans_books?" do
      it "returns false (single book implementation)" do
        pericope = described_class.new("GEN 1:1")
        expect(pericope.spans_books?).to be false
      end
    end
  end

  describe "counting methods" do
    describe "#verse_count" do
      it "returns 1 for single verse" do
        pericope = described_class.new("GEN 1:1")
        expect(pericope.verse_count).to eq(1)
      end

      it "returns correct count for verse range" do
        pericope = described_class.new("GEN 1:1-3")
        expect(pericope.verse_count).to eq(3)
      end
    end

    describe "#chapter_count" do
      it "returns 1 for single chapter" do
        pericope = described_class.new("GEN 1:1-3")
        expect(pericope.chapter_count).to eq(1)
      end

      it "returns correct count for cross-chapter range" do
        pericope = described_class.new("GEN 1:1-3:1")
        expect(pericope.chapter_count).to eq(3)
      end
    end

    describe "#chapter_list" do
      it "returns array of chapters" do
        pericope = described_class.new("GEN 1:1-3:1")
        expect(pericope.chapter_list).to eq([1, 2, 3])
      end
    end

    describe "#range_count" do
      it "returns number of ranges" do
        pericope = described_class.new("GEN 1:1,3,5")
        expect(pericope.range_count).to eq(3)
      end
    end
  end

  describe "verse access methods" do
    describe "#first_verse" do
      it "returns first verse" do
        pericope = described_class.new("GEN 2:5-10")
        first = pericope.first_verse
        expect(first.to_s).to eq("GEN 2:5")
      end

      it "returns nil for empty pericope" do
        pericope = described_class.new("GEN 1:1")
        pericope.instance_variable_set(:@ranges, [])
        expect(pericope.first_verse).to be_nil
      end
    end

    describe "#last_verse" do
      it "returns last verse" do
        pericope = described_class.new("GEN 2:5-10")
        last = pericope.last_verse
        expect(last.to_s).to eq("GEN 2:10")
      end

      it "returns nil for empty pericope" do
        pericope = described_class.new("GEN 1:1")
        pericope.instance_variable_set(:@ranges, [])
        expect(pericope.last_verse).to be_nil
      end
    end
  end

  describe "#==" do
    it "returns true for identical pericopes" do
      pericope1 = described_class.new("GEN 1:1-3")
      pericope2 = described_class.new("GEN 1:1-3")
      expect(pericope1).to eq(pericope2)
    end

    it "returns false for different pericopes" do
      pericope1 = described_class.new("GEN 1:1-3")
      pericope2 = described_class.new("GEN 1:4-6")
      expect(pericope1).not_to eq(pericope2)
    end

    it "returns false for different books" do
      pericope1 = described_class.new("GEN 1:1")
      pericope2 = described_class.new("MAT 1:1")
      expect(pericope1).not_to eq(pericope2)
    end

    it "returns false for non-Pericope objects" do
      pericope = described_class.new("GEN 1:1")
      expect(pericope).not_to eq("GEN 1:1")
    end
  end
end
