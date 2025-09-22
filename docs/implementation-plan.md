# Ruby Pericope Library Implementation Plan

## Overview

This implementation plan provides a structured approach for AI-assisted development of the Ruby Pericope library based on the specification. The plan is organized into phases with clear dependencies and deliverables.

## Phase 1: Foundation Setup

### 1.1 Project Structure Setup
- [ ] Create basic gem structure with proper directories
- [ ] Set up Gemfile with development dependencies (RSpec, RuboCop, etc.)
- [ ] Configure RuboCop with Ruby 3.4 compatibility
- [ ] Set up RSpec testing framework
- [ ] Create basic README and documentation structure
- [ ] Initialize git repository with proper .gitignore

**Files to create:**
- `lib/ruby/pericope.rb` (main entry point)
- `lib/ruby/pericope/version.rb`
- `spec/spec_helper.rb`
- `spec/support/` directory for test helpers

### 1.2 Error Handling Foundation
- [ ] Implement custom exception hierarchy
- [ ] Create `PericopeError` base class
- [ ] Implement specific error classes: `InvalidBookError`, `InvalidChapterError`, `InvalidVerseError`, `InvalidRangeError`, `ParseError`

**Files to create:**
- `lib/ruby/pericope/errors.rb`
- `spec/ruby/pericope/errors_spec.rb`

### 1.3 Basic Constants and Enums
- [ ] Define book testament constants (:old, :new, :deuterocanonical)
- [ ] Define versification type constants
- [ ] Create basic module structure

## Phase 2: Book Management System

### 2.1 Book Data Structure
- [ ] Create comprehensive book data with USFM codes
- [ ] Implement book aliases and alternative names lookup tables
- [ ] Include testament classification and book numbers
- [ ] Add chapter/verse count data for English versification

**Files to create:**
- `lib/ruby/pericope/book_data.rb` (static book information)
- `data/book_aliases.yml` (comprehensive book name mappings)
- `spec/ruby/pericope/book_data_spec.rb`

### 2.2 Book Class Implementation
- [ ] Implement Book class with all specified methods
- [ ] Add flexible name recognition (canonical, full names, abbreviations)
- [ ] Implement fuzzy matching with Levenshtein distance
- [ ] Add case-insensitive matching
- [ ] Create book lookup and validation methods

**Files to create:**
- `lib/ruby/pericope/book.rb`
- `spec/ruby/pericope/book_spec.rb`

### 2.3 Book Name Recognition Engine
- [ ] Implement comprehensive alias matching
- [ ] Add support for common misspellings and OCR errors
- [ ] Create suggestion system for unrecognized names
- [ ] Add partial matching with disambiguation

**Dependencies:** Levenshtein gem for fuzzy matching

## Phase 3: Versification System

### 3.1 Versification Data Management
- [ ] Download and integrate .vrs files from SIL libpalaso
- [ ] Create .vrs file parser
- [ ] Implement versification data loading and caching
- [ ] Add support for multiple versification systems

**Files to create:**
- `lib/ruby/pericope/versification_parser.rb`
- `data/versifications/` directory with .vrs files
- `spec/ruby/pericope/versification_parser_spec.rb`

### 3.2 Versification Class Implementation
- [ ] Implement Versification class with all specified methods
- [ ] Add verse counting and chapter counting methods
- [ ] Implement verse mapping between versifications
- [ ] Add book support validation

**Files to create:**
- `lib/ruby/pericope/versification.rb`
- `spec/ruby/pericope/versification_spec.rb`

### 3.3 Default Versification Setup
- [ ] Set up English versification as default
- [ ] Create versification registry and discovery
- [ ] Implement versification validation

## Phase 4: Core Reference Classes

### 4.1 VerseRef Class Implementation
- [ ] Implement VerseRef class for single verse references
- [ ] Add BBBCCCVVV integer format support
- [ ] Implement comparison operators (==, <=>)
- [ ] Add validation methods
- [ ] Create string representation methods

**Files to create:**
- `lib/ruby/pericope/verse_ref.rb`
- `spec/ruby/pericope/verse_ref_spec.rb`

### 4.2 Range Parsing Engine
- [ ] Implement complex range syntax parser
- [ ] Handle comma-separated sequences with proper precedence
- [ ] Add context-aware colon parsing
- [ ] Implement dash range parsing within context
- [ ] Add validation against versification data

**Files to create:**
- `lib/ruby/pericope/range_parser.rb`
- `spec/ruby/pericope/range_parser_spec.rb`

### 4.3 Text Extraction Engine
- [ ] Implement pericope extraction from natural text
- [ ] Add support for multiple book name formats
- [ ] Create context-aware parsing for ambiguous abbreviations
- [ ] Implement multiple pericope extraction from single text

**Files to create:**
- `lib/ruby/pericope/text_extractor.rb`
- `spec/ruby/pericope/text_extractor_spec.rb`

## Phase 5: Main Pericope Class

### 5.1 Basic Pericope Implementation
- [ ] Implement Pericope class constructor and basic methods
- [ ] Add string parsing and validation
- [ ] Implement to_s and to_a methods
- [ ] Add basic property methods (valid?, empty?, single_verse?, etc.)

**Files to create:**
- `lib/ruby/pericope/pericope.rb`
- `spec/ruby/pericope/pericope_spec.rb`

### 5.2 Pericope Mathematics - Counting Operations
- [ ] Implement verse counting methods
- [ ] Add chapter counting and listing
- [ ] Create verse listing and range analysis
- [ ] Add first/last verse identification
- [ ] Implement chapter-specific verse counting

### 5.3 Advanced Mathematical Operations
- [ ] Implement density calculations
- [ ] Add gap identification within ranges
- [ ] Create continuous range breakdown
- [ ] Add detailed chapter analysis methods

### 5.4 Comparison and Set Operations
- [ ] Implement comparison methods (intersects?, contains?, overlaps?)
- [ ] Add positional methods (adjacent_to?, precedes?, follows?)
- [ ] Create set operations (union, intersection, subtract)
- [ ] Implement range manipulation (expand, contract)
- [ ] Add normalization and simplification

## Phase 6: Integration and Testing

### 6.1 Comprehensive Testing Suite
- [ ] Create comprehensive unit tests for all classes
- [ ] Add integration tests for complex scenarios
- [ ] Implement performance benchmarks
- [ ] Add edge case testing for parsing
- [ ] Create versification compatibility tests

### 6.2 Documentation and Examples
- [ ] Generate comprehensive API documentation
- [ ] Create usage examples for all major features
- [ ] Add performance characteristics documentation
- [ ] Create migration guide from existing gems

### 6.3 Compatibility Testing
- [ ] Test against SIL.Scripture results where possible
- [ ] Validate mathematical operations accuracy
- [ ] Test book name recognition comprehensiveness
- [ ] Verify versification mapping correctness

## Phase 7: Polish and Release

### 7.1 Performance Optimization
- [ ] Optimize parsing performance for complex ranges
- [ ] Implement efficient versification data caching
- [ ] Optimize comparison operations
- [ ] Add memory-efficient range storage

### 7.2 Final Integration
- [ ] Ensure all components work together seamlessly
- [ ] Add configuration options for customization
- [ ] Implement plugin system foundation
- [ ] Create extensibility points

### 7.3 Release Preparation
- [ ] Final testing and bug fixes
- [ ] Complete documentation review
- [ ] Prepare gem for publication
- [ ] Create release notes and changelog

## Implementation Guidelines for AI

### Code Quality Standards
- Follow Ruby style guide and RuboCop rules
- Maintain 100% test coverage for core functionality
- Use descriptive method and variable names
- Add comprehensive inline documentation
- Follow SOLID principles and clean code practices

### Testing Strategy
- Write tests first (TDD approach) for complex logic
- Use RSpec with descriptive test names
- Create test fixtures for versification data
- Mock external dependencies appropriately
- Test edge cases and error conditions thoroughly

### Performance Considerations
- Pre-load and cache versification data
- Use efficient data structures for book lookups
- Optimize string parsing operations
- Consider memory usage for large range operations
- Profile and benchmark critical paths

### Error Handling
- Provide clear, actionable error messages
- Use appropriate exception types for different errors
- Include context information in error messages
- Handle edge cases gracefully
- Validate inputs early and thoroughly

## Dependencies and External Resources

### Required Gems
- `rspec` - Testing framework
- `rubocop` - Code style enforcement
- `levenshtein` - Fuzzy string matching
- `yaml` - Configuration file parsing

### External Data Sources
- SIL libpalaso .vrs files for versification data
- USFM 3.0 specification for book codes
- Existing Ruby pericope gem for compatibility testing

### Development Tools
- Ruby 3.4.1 or compatible
- Bundler for dependency management
- Git for version control
- YARD for documentation generation

This implementation plan provides a structured approach to building the Ruby Pericope library with clear milestones, dependencies, and quality standards suitable for AI-assisted development.
