# Ruby Pericope Library Specification

## Overview

A Ruby library for parsing, validating, and manipulating biblical pericopes (Scripture references). This library should follow the Paratext format specification and be compatible with existing SIL Scripture libraries while providing a clean Ruby API.

## Core Concepts

### Pericope Definition
A pericope is a biblical reference that can represent:
- A single verse: `GEN 1:1`
- A verse range: `GEN 1:1-3`
- A chapter range: `GEN 1:1-2:2`
- Multiple verses/ranges: `GEN 1:1,3,5,9,2:1-23,25`
- Cross-chapter sequences: `MAT 28:19-20, MRK 1:1-8`

### Format Specification
Following the Paratext standard: `<PARATEXT_CODE> <RANGE>`

#### Paratext Codes
Based on USFM 3.0 specification, supporting all standard 3-character book identifiers:

**Old Testament (39 books):**
- GEN, EXO, LEV, NUM, DEU
- JOS, JDG, RUT, 1SA, 2SA, 1KI, 2KI
- 1CH, 2CH, EZR, NEH, EST
- JOB, PSA, PRO, ECC, SNG
- ISA, JER, LAM, EZK, DAN
- HOS, JOL, AMO, OBA, JON, MIC, NAM, HAB, ZEP, HAG, ZEC, MAL

**New Testament (27 books):**
- MAT, MRK, LUK, JHN, ACT
- ROM, 1CO, 2CO, GAL, EPH, PHP, COL, 1TH, 2TH, 1TI, 2TI, TIT, PHM
- HEB, JAS, 1PE, 2PE, 1JN, 2JN, 3JN, JUD, REV

**Deuterocanonical/Apocryphal books:**
- TOB, JDT, ESG, WIS, SIR, BAR, LJE, S3Y, SUS, BEL
- 1MA, 2MA, 3MA, 4MA, 1ES, 2ES, MAN, PS2, ODA, PSS
- Additional books: EZA, 5EZ, 6EZ, DAG, PS3, 2BA, LBA, JUB, ENO, etc.

#### Range Syntax
- **Single verse:** `1:1`
- **Verse range:** `1:1-23` (verses 1 through 23 in chapter 1)
- **Cross-chapter range:** `1:1-2:2` (chapter 1 verse 1 through chapter 2 verse 2)
- **Verse sequence:** `1:1,3,5,9` (specific verses in chapter 1)
- **Mixed ranges:** `1:1-23,25` (verses 1-23 and verse 25)
- **Complex sequence:** `1:1,3,5,9,2:1-23,25` (verses from multiple chapters)

**Parsing Challenges:**
- Ambiguity in sequences like `1:1,5,7:1-10` vs `1:1,5,7` 
- The colon (`:`) changes meaning of subsequent numbers
- Sequential parsing may not work; need context-aware parsing

## Core Classes

### 1. Book Class
Manages book information and validation with flexible name recognition.

```ruby
class Book
  # Book identification
  attr_reader :code, :number, :name, :testament, :aliases

  # Class methods
  def self.find_by_code(code) # Exact Paratext code match
  def self.find_by_number(number)
  def self.find_by_name(name) # Flexible name matching
  def self.find_by_alias(alias_name) # Common abbreviations/variations
  def self.all_books
  def self.testament_books(testament) # :old, :new, :deuterocanonical
  def self.normalize_name(input) # Convert any format to canonical code

  # Instance methods
  def valid?
  def canonical?
  def deuterocanonical?
  def old_testament?
  def new_testament?
  def chapter_count(versification = nil)
  def verse_count(chapter, versification = nil)
  def matches?(input) # Check if input matches this book
  def aliases # Return all known aliases/abbreviations
end
```

#### Book Name Recognition
The library supports multiple input formats for book names:

**Canonical Form (Paratext):** `MAT`, `GEN`, `1CO`, etc.
**Full Names:** `Matthew`, `Genesis`, `1 Corinthians`
**Common Abbreviations:** `Matt`, `Gen`, `1Cor`, `1 Cor`
**Alternative Spellings:** `Mathew`, `Genisis`, `Corinthians`
**Numeric Variations:** `1st Corinthians`, `First Corinthians`

```ruby
# All of these should resolve to MAT:
Book.find_by_name("Matthew")     # => Book(MAT)
Book.find_by_name("Matt")        # => Book(MAT)
Book.find_by_name("Mt")          # => Book(MAT)
Book.find_by_name("MAT")         # => Book(MAT)
Book.find_by_name("matthew")     # => Book(MAT) (case insensitive)
```

### 2. VerseRef Class
Represents a single verse reference.

```ruby
class VerseRef
  attr_reader :book, :chapter, :verse
  
  def initialize(book, chapter, verse)
  def to_s
  def to_i # BBBCCCVVV format
  def valid?
  def ==(other)
  def <=>(other)
end
```

### 3. Pericope Class
Main class for parsing and manipulating pericopes with comprehensive mathematical operations.

```ruby
class Pericope
  attr_reader :book, :ranges, :versification

  # Constructors
  def initialize(reference_string, versification = nil)
  def self.parse(text, versification = nil) # Extract pericopes from text
  def self.split(text, versification = nil) # Split text on pericopes

  # Core methods
  def to_s(format = :canonical) # :canonical, :full_name, :abbreviated
  def to_a # Array of VerseRef objects
  def valid?
  def empty?
  def single_verse?
  def single_chapter?
  def spans_chapters?
  def spans_books?

  # Pericope Mathematics - Core counting operations
  def verse_count # Total verses in this pericope
  def chapter_count # Number of chapters spanned
  def chapter_list # Array of chapter numbers included
  def verse_list # Array of all individual verse references
  def first_verse # First VerseRef in the pericope
  def last_verse # Last VerseRef in the pericope
  def range_count # Number of separate ranges

  # Advanced mathematical operations
  def verses_in_chapter(chapter) # Count verses in specific chapter
  def chapters_in_range # Detailed breakdown by chapter
  def density # Percentage of verses included vs. total possible
  def gaps # Identify missing verses within the range
  def continuous_ranges # Break into continuous sub-ranges

  # Comparison methods
  def ==(other)
  def intersects?(other)
  def contains?(other)
  def overlaps?(other)
  def adjacent_to?(other)
  def precedes?(other)
  def follows?(other)

  # Set operations (Pericope Math)
  def union(other) # Combine two pericopes
  def intersection(other) # Common verses
  def subtract(other) # Remove verses
  def complement(scope = nil) # Inverse within book/chapter
  def normalize # Simplify ranges
  def expand(verses_before = 0, verses_after = 0) # Extend range
  def contract(verses_from_start = 0, verses_from_end = 0) # Shrink range
end
```

### 4. Versification Class
Handles different versification systems and verse mappings with .vrs file support.

```ruby
class Versification
  # Standard versification types
  ENGLISH = 'English'
  SEPTUAGINT = 'Septuagint'
  VULGATE = 'Vulgate'
  ORIGINAL = 'Original'
  RUSSIAN_SYNODAL = 'RussianSynodal'
  RUSSIAN_ORTHODOX = 'RussianOrthodox'

  # Class methods
  def self.load_from_file(vrs_file_path)
  def self.available_versifications
  def self.default

  # Instance methods
  def initialize(type = ENGLISH, vrs_file = nil)
  def verse_count(book, chapter)
  def chapter_count(book)
  def map_verse(verse_ref, target_versification)
  def supports_book?(book_code)
  def verse_mappings(book_code) # Get all verse mappings for a book
  def name
  def description
end
```

## Parsing Engine

### Range Parser
Handle complex range syntax with proper precedence:

1. **Split on commas** first to identify separate ranges
2. **Parse each range** individually:
   - Detect chapter:verse pattern
   - Handle dash ranges within context
   - Validate verse numbers against versification

### Text Extraction
Support parsing pericopes from natural text with flexible book name recognition:
- Recognize canonical Paratext codes (MAT, GEN, 1CO)
- Handle full book names (Matthew, Genesis, 1 Corinthians)
- Support common abbreviations (Matt, Gen, 1Cor, 1 Cor)
- Recognize alternative spellings and variations
- Handle numeric variations (1st Corinthians, First Corinthians)
- Case-insensitive matching
- Extract multiple pericopes from a single text block
- Maintain context for ambiguous abbreviations

## Validation System

### Reference Validation
- Book code exists in versification
- Chapter exists in book
- Verse exists in chapter
- Range endpoints are valid
- Cross-chapter ranges are logical

### Versification Support
- Default to English versification
- Support multiple versification systems
- Handle verse mapping between systems
- Load versification data from .vrs files

#### Versification File Sources (.vrs files)

**Primary Sources:**
- **SIL libpalaso Repository**: https://github.com/sillsdev/libpalaso/tree/master/SIL.Scripture/Resources
  - `eng.vrs` - English versification (most common)
  - `lxx.vrs` - Septuagint versification
  - `org.vrs` - Original language versification
  - `rsc.vrs` - Russian Synodal versification
  - `rso.vrs` - Russian Orthodox versification
  - `vul.vrs` - Vulgate versification

**Additional Sources:**
- **Digital Bible Library**: Provides versification files for various Bible translations
- **Paratext Resources**: Official Paratext installation includes standard versification files
- **UBS Scripture Resources**: https://github.com/ubsicap (United Bible Societies)
- **BibleMultiConverter**: https://github.com/schierlm/BibleMultiConverter (includes versification handling)
- **eBible Repository**: https://github.com/BibleNLP/ebible (curated parallel Bible data)

**Custom Versification:**
- Support for custom .vrs files for specific translation projects
- Utility to generate custom versification files (as referenced in Paratext documentation)
- Validation tools for versification file integrity

## Error Handling

### Custom Exceptions
```ruby
class PericopeError < StandardError; end
class InvalidBookError < PericopeError; end
class InvalidChapterError < PericopeError; end
class InvalidVerseError < PericopeError; end
class InvalidRangeError < PericopeError; end
class ParseError < PericopeError; end
```

## Integration Requirements

### Compatibility
- Follow SIL.Scripture patterns where applicable
- Support standard versification files (.vrs format) from multiple sources
- Maintain compatibility with Paratext conventions and Digital Bible Library
- Provide migration path from existing Ruby pericope gems
- Compatible with USFM/USX file formats

### Performance
- Efficient parsing of complex ranges
- Fast validation using pre-loaded versification data
- Optimized comparison operations
- Memory-efficient storage of verse ranges

### Extensibility
- Plugin system for custom versifications
- Configurable book name recognition
- Extensible parsing rules
- Custom output formatting

## Pericope Mathematics Examples

### Basic Counting Operations
```ruby
pericope = Pericope.new("MAT 5:3-12")
pericope.verse_count        # => 10
pericope.chapter_count      # => 1
pericope.single_chapter?    # => true

pericope = Pericope.new("MAT 5:3-6:4")
pericope.verse_count        # => 50 (depends on versification)
pericope.chapter_count      # => 2
pericope.spans_chapters?    # => true
```

### Advanced Mathematical Operations
```ruby
pericope = Pericope.new("MAT 5:1,3,5-10,12")
pericope.verse_count        # => 8 (1 + 1 + 6 + 1)
pericope.range_count        # => 4
pericope.gaps               # => [2, 4, 11] (missing verses)
pericope.density            # => 0.32 (8 out of 25 possible verses)

# Chapter-specific operations
pericope.verses_in_chapter(5)  # => 8
pericope.chapters_in_range     # => {5 => [1,3,5,6,7,8,9,10,12]}
```

### Set Operations (Pericope Math)
```ruby
a = Pericope.new("MAT 5:1-10")
b = Pericope.new("MAT 5:5-15")

union = a.union(b)           # => "MAT 5:1-15"
intersection = a.intersection(b)  # => "MAT 5:5-10"
difference = a.subtract(b)   # => "MAT 5:1-4"

# Range manipulation
expanded = a.expand(2, 3)    # => "MAT 4:23-5:13" (2 before, 3 after)
contracted = a.contract(1, 2) # => "MAT 5:2-8" (remove 1 from start, 2 from end)
```

## Testing Requirements

### Unit Tests
- Comprehensive book name recognition (canonical, full names, abbreviations)
- Range parsing edge cases and complex sequences
- Pericope mathematics accuracy across versifications
- Versification mapping accuracy
- Error condition handling
- Set operations correctness

## Documentation

### API Documentation
- Complete method documentation
- Usage examples for all classes
- Performance characteristics
- Migration guides

### Format Documentation
- Paratext format specification
- Versification system explanations
- Supported book codes reference (canonical and all recognized variations)
- Range syntax examples
- Pericope mathematics operation reference
- Book name recognition patterns and examples

## Book Name Recognition Patterns

### Implementation Strategy
The library should maintain comprehensive lookup tables for book name recognition:

```ruby
BOOK_ALIASES = {
  'MAT' => [
    'Matthew', 'Matt', 'Mt', 'MAT',
    'Mathew', 'Mattew', # common misspellings
    'Gospel of Matthew', 'St Matthew', 'Saint Matthew'
  ],
  'GEN' => [
    'Genesis', 'Gen', 'GEN', 'Ge',
    'Genisis', 'Geneses', # common misspellings
    'Book of Genesis'
  ],
  '1CO' => [
    '1 Corinthians', '1Corinthians', '1Cor', '1 Cor',
    'First Corinthians', '1st Corinthians', 'I Corinthians',
    '1CO', 'ICO', 'I CO'
  ]
  # ... comprehensive mappings for all books
}
```

### Fuzzy Matching
- Implement Levenshtein distance for close matches
- Handle common OCR errors and typos
- Provide suggestions for unrecognized book names
- Support partial matching with disambiguation

This specification provides the foundation for a robust, standards-compliant Ruby pericope library that can handle the complexity of biblical reference parsing, comprehensive book name recognition, and full pericope mathematical operations while maintaining compatibility with existing tools and standards.
