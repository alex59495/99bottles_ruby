gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/bottles'

module VerseRoleTest
  def test_plays_verse_role
    assert_respond_to @role_player, :lyrics
  end
end

class BottlesVerseTest < Minitest::Test
  include VerseRoleTest

  def setup
    @role_player = BottlesVerse
  end

  def test_verse_general_rule_upper_bound
    expected =
    "99 bottles of beer on the wall, " +
    "99 bottles of beer.\n" +
    "Take one down and pass it around, " +
    "98 bottles of beer on the wall.\n"
    assert_equal expected, BottlesVerse.lyrics(99)
  end

  def test_verse_general_rule_lower_bound
    expected =
      "3 bottles of beer on the wall, " +
      "3 bottles of beer.\n" +
      "Take one down and pass it around, " +
      "2 bottles of beer on the wall.\n"
    assert_equal expected, BottlesVerse.lyrics(3)
  end

  def test_verse_7
    expected =
    "7 bottles of beer on the wall, " +
    "7 bottles of beer.\n" +
    "Take one down and pass it around, " +
    "1 six-pack of beer on the wall.\n"
    assert_equal expected, BottlesVerse.lyrics(7)
  end

  def test_verse_6
    expected =
    "1 six-pack of beer on the wall, " +
    "1 six-pack of beer.\n" +
    "Take one down and pass it around, " +
    "5 bottles of beer on the wall.\n"
    assert_equal expected, BottlesVerse.lyrics(6)
  end

  def test_verse_2
    expected =
      "2 bottles of beer on the wall, " +
      "2 bottles of beer.\n" +
      "Take one down and pass it around, " +
      "1 bottle of beer on the wall.\n"
    assert_equal expected, BottlesVerse.lyrics(2)
  end

  def test_verse_1
    expected =
      "1 bottle of beer on the wall, " +
      "1 bottle of beer.\n" +
      "Take it down and pass it around, " +
      "no more bottles of beer on the wall.\n"
     assert_equal expected, BottlesVerse.lyrics(1)
  end

  def test_verse_0
    expected =
      "No more bottles of beer on the wall, " +
      "no more bottles of beer.\n" +
      "Go to the store and buy some more, " +
      "99 bottles of beer on the wall.\n"
    assert_equal expected, BottlesVerse.lyrics(0)
  end
end

class BottlesNumberTest < Minitest::Test
  def test_returns_correct_class_for_given_number
  # 0,1,6 are special
  assert_equal BottlesNumber0, BottlesNumber.for(0).class
  assert_equal BottlesNumber1, BottlesNumber.for(1).class
  assert_equal BottlesNumber6, BottlesNumber.for(6).class
  # Other numbers get the default
  assert_equal BottlesNumber, BottlesNumber.for(3).class
  assert_equal BottlesNumber, BottlesNumber.for(7).class
  assert_equal BottlesNumber, BottlesNumber.for(43).class
  end
end

class VerseFake
  def self.lyrics(number)
    "This is verse #{number}.\n"
  end
end

class VerseFakeTest < Minitest::Test
  include VerseRoleTest

  def setup
    @role_player = VerseFake
  end
end

class CountDownSongTest < Minitest::Test
  def test_verse
    expected = "This is verse 500.\n"
    assert_equal(
      expected,
      CountDownSong.new(verse_template: VerseFake)
      .verse(500)
    )
  end

  def test_verses
    expected =
      "This is verse 99.\n" +
      "\n" +
      "This is verse 98.\n" +
      "\n" +
      "This is verse 97.\n"
    assert_equal expected, CountDownSong.new(verse_template: VerseFake).verses(99, 97)
  end

  def test_song
    expected =
      "This is verse 47.\n" +
      "\n" +
      "This is verse 46.\n" +
      "\n" +
      "This is verse 45.\n" +
      "\n" +
      "This is verse 44.\n" +
      "\n" +
      "This is verse 43.\n"
    assert_equal(
      expected,
      CountDownSong.new(verse_template: VerseFake,
      max: 47,
      min: 43)
      .song
    )
  end
end
