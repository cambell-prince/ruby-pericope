# frozen_string_literal: true

module Ruby
  module Pericope
    # Static book data and information
    module BookData
      # Book information structure
      BookInfo = Struct.new(:code, :number, :name, :testament, :chapter_count, :aliases, keyword_init: true)

      # Old Testament books (39 books)
      OLD_TESTAMENT_BOOKS = [
        BookInfo.new(code: "GEN", number: 1, name: "Genesis", testament: :old, chapter_count: 50,
                     aliases: ["Genesis", "Gen", "GEN", "Ge", "Genisis", "Geneses", "Book of Genesis"]),
        BookInfo.new(code: "EXO", number: 2, name: "Exodus", testament: :old, chapter_count: 40,
                     aliases: ["Exodus", "Exod", "Exo", "EXO", "Ex", "Book of Exodus"]),
        BookInfo.new(code: "LEV", number: 3, name: "Leviticus", testament: :old, chapter_count: 27,
                     aliases: ["Leviticus", "Lev", "LEV", "Le", "Book of Leviticus"]),
        BookInfo.new(code: "NUM", number: 4, name: "Numbers", testament: :old, chapter_count: 36,
                     aliases: ["Numbers", "Num", "NUM", "Nu", "Nb", "Book of Numbers"]),
        BookInfo.new(code: "DEU", number: 5, name: "Deuteronomy", testament: :old, chapter_count: 34,
                     aliases: ["Deuteronomy", "Deut", "DEU", "De", "Dt", "Book of Deuteronomy"]),
        BookInfo.new(code: "JOS", number: 6, name: "Joshua", testament: :old, chapter_count: 24,
                     aliases: ["Joshua", "Josh", "JOS", "Jos", "Book of Joshua"]),
        BookInfo.new(code: "JDG", number: 7, name: "Judges", testament: :old, chapter_count: 21,
                     aliases: ["Judges", "Judg", "JDG", "Jdg", "Book of Judges"]),
        BookInfo.new(code: "RUT", number: 8, name: "Ruth", testament: :old, chapter_count: 4,
                     aliases: ["Ruth", "RUT", "Ru", "Book of Ruth"]),
        BookInfo.new(code: "1SA", number: 9, name: "1 Samuel", testament: :old, chapter_count: 31,
                     aliases: ["1 Samuel", "1Sam", "1SA", "1 Sam", "First Samuel", "1st Samuel", "I Samuel"]),
        BookInfo.new(code: "2SA", number: 10, name: "2 Samuel", testament: :old, chapter_count: 24,
                     aliases: ["2 Samuel", "2Sam", "2SA", "2 Sam", "Second Samuel", "2nd Samuel", "II Samuel"]),
        BookInfo.new(code: "1KI", number: 11, name: "1 Kings", testament: :old, chapter_count: 22,
                     aliases: ["1 Kings", "1Kgs", "1KI", "1 Kgs", "First Kings", "1st Kings", "I Kings"]),
        BookInfo.new(code: "2KI", number: 12, name: "2 Kings", testament: :old, chapter_count: 25,
                     aliases: ["2 Kings", "2Kgs", "2KI", "2 Kgs", "Second Kings", "2nd Kings", "II Kings"]),
        BookInfo.new(code: "1CH", number: 13, name: "1 Chronicles", testament: :old, chapter_count: 29,
                     aliases: ["1 Chronicles", "1Chr", "1CH", "1 Chr", "First Chronicles",
                               "1st Chronicles", "I Chronicles"]),
        BookInfo.new(code: "2CH", number: 14, name: "2 Chronicles", testament: :old, chapter_count: 36,
                     aliases: ["2 Chronicles", "2Chr", "2CH", "2 Chr", "Second Chronicles",
                               "2nd Chronicles", "II Chronicles"]),
        BookInfo.new(code: "EZR", number: 15, name: "Ezra", testament: :old, chapter_count: 10,
                     aliases: ["Ezra", "EZR", "Ezr", "Book of Ezra"]),
        BookInfo.new(code: "NEH", number: 16, name: "Nehemiah", testament: :old, chapter_count: 13,
                     aliases: ["Nehemiah", "Neh", "NEH", "Ne", "Book of Nehemiah"]),
        BookInfo.new(code: "EST", number: 17, name: "Esther", testament: :old, chapter_count: 10,
                     aliases: ["Esther", "Esth", "EST", "Es", "Book of Esther"]),
        BookInfo.new(code: "JOB", number: 18, name: "Job", testament: :old, chapter_count: 42,
                     aliases: ["Job", "JOB", "Jb", "Book of Job"]),
        BookInfo.new(code: "PSA", number: 19, name: "Psalms", testament: :old, chapter_count: 150,
                     aliases: ["Psalms", "Psalm", "Ps", "PSA", "Psa", "Pss", "Book of Psalms"]),
        BookInfo.new(code: "PRO", number: 20, name: "Proverbs", testament: :old, chapter_count: 31,
                     aliases: ["Proverbs", "Prov", "PRO", "Pr", "Book of Proverbs"]),
        BookInfo.new(code: "ECC", number: 21, name: "Ecclesiastes", testament: :old, chapter_count: 12,
                     aliases: ["Ecclesiastes", "Eccl", "ECC", "Ec", "Ecc", "Book of Ecclesiastes"]),
        BookInfo.new(code: "SNG", number: 22, name: "Song of Songs", testament: :old, chapter_count: 8,
                     aliases: ["Song of Songs", "Song", "SNG", "SS", "Song of Solomon", "Canticles"]),
        BookInfo.new(code: "ISA", number: 23, name: "Isaiah", testament: :old, chapter_count: 66,
                     aliases: ["Isaiah", "Isa", "ISA", "Is", "Book of Isaiah"]),
        BookInfo.new(code: "JER", number: 24, name: "Jeremiah", testament: :old, chapter_count: 52,
                     aliases: ["Jeremiah", "Jer", "JER", "Je", "Book of Jeremiah"]),
        BookInfo.new(code: "LAM", number: 25, name: "Lamentations", testament: :old, chapter_count: 5,
                     aliases: ["Lamentations", "Lam", "LAM", "La", "Book of Lamentations"]),
        BookInfo.new(code: "EZK", number: 26, name: "Ezekiel", testament: :old, chapter_count: 48,
                     aliases: ["Ezekiel", "Ezek", "EZK", "Eze", "Book of Ezekiel"]),
        BookInfo.new(code: "DAN", number: 27, name: "Daniel", testament: :old, chapter_count: 12,
                     aliases: ["Daniel", "Dan", "DAN", "Da", "Book of Daniel"]),
        BookInfo.new(code: "HOS", number: 28, name: "Hosea", testament: :old, chapter_count: 14,
                     aliases: ["Hosea", "Hos", "HOS", "Ho", "Book of Hosea"]),
        BookInfo.new(code: "JOL", number: 29, name: "Joel", testament: :old, chapter_count: 3,
                     aliases: ["Joel", "JOL", "Joe", "Book of Joel"]),
        BookInfo.new(code: "AMO", number: 30, name: "Amos", testament: :old, chapter_count: 9,
                     aliases: ["Amos", "AMO", "Am", "Book of Amos"]),
        BookInfo.new(code: "OBA", number: 31, name: "Obadiah", testament: :old, chapter_count: 1,
                     aliases: ["Obadiah", "Obad", "OBA", "Ob", "Book of Obadiah"]),
        BookInfo.new(code: "JON", number: 32, name: "Jonah", testament: :old, chapter_count: 4,
                     aliases: ["Jonah", "JON", "Jon", "Book of Jonah"]),
        BookInfo.new(code: "MIC", number: 33, name: "Micah", testament: :old, chapter_count: 7,
                     aliases: ["Micah", "Mic", "MIC", "Mi", "Book of Micah"]),
        BookInfo.new(code: "NAM", number: 34, name: "Nahum", testament: :old, chapter_count: 3,
                     aliases: ["Nahum", "Nah", "NAM", "Na", "Book of Nahum"]),
        BookInfo.new(code: "HAB", number: 35, name: "Habakkuk", testament: :old, chapter_count: 3,
                     aliases: ["Habakkuk", "Hab", "HAB", "Hb", "Book of Habakkuk"]),
        BookInfo.new(code: "ZEP", number: 36, name: "Zephaniah", testament: :old, chapter_count: 3,
                     aliases: ["Zephaniah", "Zeph", "ZEP", "Zp", "Book of Zephaniah"]),
        BookInfo.new(code: "HAG", number: 37, name: "Haggai", testament: :old, chapter_count: 2,
                     aliases: ["Haggai", "Hag", "HAG", "Hg", "Book of Haggai"]),
        BookInfo.new(code: "ZEC", number: 38, name: "Zechariah", testament: :old, chapter_count: 14,
                     aliases: ["Zechariah", "Zech", "ZEC", "Zc", "Book of Zechariah"]),
        BookInfo.new(code: "MAL", number: 39, name: "Malachi", testament: :old, chapter_count: 4,
                     aliases: ["Malachi", "Mal", "MAL", "Ml", "Book of Malachi"])
      ].freeze

      # New Testament books (27 books) - continuing from number 40
      NEW_TESTAMENT_BOOKS = [
        BookInfo.new(code: "MAT", number: 40, name: "Matthew", testament: :new, chapter_count: 28,
                     aliases: ["Matthew", "Matt", "MAT", "Mt", "Mathew", "Mattew",
                               "Gospel of Matthew", "St Matthew", "Saint Matthew"]),
        BookInfo.new(code: "MRK", number: 41, name: "Mark", testament: :new, chapter_count: 16,
                     aliases: ["Mark", "MRK", "Mk", "Gospel of Mark", "St Mark", "Saint Mark"]),
        BookInfo.new(code: "LUK", number: 42, name: "Luke", testament: :new, chapter_count: 24,
                     aliases: ["Luke", "LUK", "Lk", "Gospel of Luke", "St Luke", "Saint Luke"]),
        BookInfo.new(code: "JHN", number: 43, name: "John", testament: :new, chapter_count: 21,
                     aliases: ["John", "JHN", "Jn", "Gospel of John", "St John", "Saint John"]),
        BookInfo.new(code: "ACT", number: 44, name: "Acts", testament: :new, chapter_count: 28,
                     aliases: ["Acts", "ACT", "Ac", "Acts of the Apostles", "Book of Acts"]),
        BookInfo.new(code: "ROM", number: 45, name: "Romans", testament: :new, chapter_count: 16,
                     aliases: ["Romans", "Rom", "ROM", "Ro", "Rm", "Letter to the Romans"]),
        BookInfo.new(code: "1CO", number: 46, name: "1 Corinthians", testament: :new, chapter_count: 16,
                     aliases: ["1 Corinthians", "1Corinthians", "1Cor", "1 Cor", "First Corinthians",
                               "1st Corinthians", "I Corinthians", "1CO", "ICO", "I CO"]),
        BookInfo.new(code: "2CO", number: 47, name: "2 Corinthians", testament: :new, chapter_count: 13,
                     aliases: ["2 Corinthians", "2Corinthians", "2Cor", "2 Cor", "Second Corinthians",
                               "2nd Corinthians", "II Corinthians", "2CO", "IICO", "II CO"]),
        BookInfo.new(code: "GAL", number: 48, name: "Galatians", testament: :new, chapter_count: 6,
                     aliases: ["Galatians", "Gal", "GAL", "Ga", "Letter to the Galatians"]),
        BookInfo.new(code: "EPH", number: 49, name: "Ephesians", testament: :new, chapter_count: 6,
                     aliases: ["Ephesians", "Eph", "EPH", "Ep", "Letter to the Ephesians"]),
        BookInfo.new(code: "PHP", number: 50, name: "Philippians", testament: :new, chapter_count: 4,
                     aliases: ["Philippians", "Phil", "PHP", "Php", "Ph", "Letter to the Philippians"]),
        BookInfo.new(code: "COL", number: 51, name: "Colossians", testament: :new, chapter_count: 4,
                     aliases: ["Colossians", "Col", "COL", "Co", "Letter to the Colossians"]),
        BookInfo.new(code: "1TH", number: 52, name: "1 Thessalonians", testament: :new, chapter_count: 5,
                     aliases: ["1 Thessalonians", "1Thess", "1TH", "1 Thess", "First Thessalonians",
                               "1st Thessalonians", "I Thessalonians"]),
        BookInfo.new(code: "2TH", number: 53, name: "2 Thessalonians", testament: :new, chapter_count: 3,
                     aliases: ["2 Thessalonians", "2Thess", "2TH", "2 Thess", "Second Thessalonians",
                               "2nd Thessalonians", "II Thessalonians"]),
        BookInfo.new(code: "1TI", number: 54, name: "1 Timothy", testament: :new, chapter_count: 6,
                     aliases: ["1 Timothy", "1Tim", "1TI", "1 Tim", "First Timothy", "1st Timothy", "I Timothy"]),
        BookInfo.new(code: "2TI", number: 55, name: "2 Timothy", testament: :new, chapter_count: 4,
                     aliases: ["2 Timothy", "2Tim", "2TI", "2 Tim", "Second Timothy", "2nd Timothy", "II Timothy"]),
        BookInfo.new(code: "TIT", number: 56, name: "Titus", testament: :new, chapter_count: 3,
                     aliases: ["Titus", "Tit", "TIT", "Ti", "Letter to Titus"]),
        BookInfo.new(code: "PHM", number: 57, name: "Philemon", testament: :new, chapter_count: 1,
                     aliases: ["Philemon", "Phlm", "PHM", "Phm", "Letter to Philemon"]),
        BookInfo.new(code: "HEB", number: 58, name: "Hebrews", testament: :new, chapter_count: 13,
                     aliases: ["Hebrews", "Heb", "HEB", "He", "Letter to the Hebrews"]),
        BookInfo.new(code: "JAS", number: 59, name: "James", testament: :new, chapter_count: 5,
                     aliases: ["James", "Jas", "JAS", "Jm", "Letter of James"]),
        BookInfo.new(code: "1PE", number: 60, name: "1 Peter", testament: :new, chapter_count: 5,
                     aliases: ["1 Peter", "1Pet", "1PE", "1 Pet", "First Peter", "1st Peter", "I Peter"]),
        BookInfo.new(code: "2PE", number: 61, name: "2 Peter", testament: :new, chapter_count: 3,
                     aliases: ["2 Peter", "2Pet", "2PE", "2 Pet", "Second Peter", "2nd Peter", "II Peter"]),
        BookInfo.new(code: "1JN", number: 62, name: "1 John", testament: :new, chapter_count: 5,
                     aliases: ["1 John", "1Jn", "1JN", "1 Jn", "First John", "1st John", "I John"]),
        BookInfo.new(code: "2JN", number: 63, name: "2 John", testament: :new, chapter_count: 1,
                     aliases: ["2 John", "2Jn", "2JN", "2 Jn", "Second John", "2nd John", "II John"]),
        BookInfo.new(code: "3JN", number: 64, name: "3 John", testament: :new, chapter_count: 1,
                     aliases: ["3 John", "3Jn", "3JN", "3 Jn", "Third John", "3rd John", "III John"]),
        BookInfo.new(code: "JUD", number: 65, name: "Jude", testament: :new, chapter_count: 1,
                     aliases: ["Jude", "JUD", "Jd", "Letter of Jude"]),
        BookInfo.new(code: "REV", number: 66, name: "Revelation", testament: :new, chapter_count: 22,
                     aliases: ["Revelation", "Rev", "REV", "Re", "Apocalypse", "Book of Revelation"])
      ].freeze

      # All canonical books
      ALL_BOOKS = (OLD_TESTAMENT_BOOKS + NEW_TESTAMENT_BOOKS).freeze

      # Create lookup tables for efficient searching
      BOOKS_BY_CODE = ALL_BOOKS.each_with_object({}) { |book, hash| hash[book.code] = book }.freeze
      BOOKS_BY_NUMBER = ALL_BOOKS.each_with_object({}) { |book, hash| hash[book.number] = book }.freeze

      # Create alias lookup table
      ALIAS_TO_BOOK = ALL_BOOKS.each_with_object({}) do |book, hash|
        book.aliases.each do |alias_name|
          hash[alias_name.downcase] = book
        end
      end.freeze
    end
  end
end
