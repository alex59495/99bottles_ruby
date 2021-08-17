require 'pry-byebug'

class CountDownSong
  attr_reader :verse_template, :min, :max

  def initialize(verse_template:, min: 0, max: 9999999)
    @verse_template = verse_template
    @min = min
    @max = max
  end

  def song
    verses(max, min)
  end

  def verses(upper, lower)
    upper.downto(lower).map {|i| verse(i)}.join("\n")
  end

  def verse(number)
    verse_template.lyrics(number)
  end
end

class BottlesVerse
  attr_reader :bottle_number

  def initialize(bottle_number)
    @bottle_number = bottle_number
  end

  def self.for(number)
    new(BottlesNumber.for(number))
  end

  def self.lyrics(number)
    self.for(number).lyrics
  end

  def lyrics
    "#{bottle_number} of beer on the wall, ".capitalize +
    "#{bottle_number} of beer.\n" +
    "#{bottle_number.action}, " +
    "#{bottle_number.successor} of beer on the wall.\n"
  end
end

class BottlesNumber
  attr_reader :number

  def initialize(number)
    @number = number
  end

  # Too abstract
  # def self.for(number)
  #   begin
  #     const_get("BottlesNumber#{number}")
  #   rescue NameError
  #     BottlesNumber
  #   end.new(number)
  # end

  # def self.for(number)
  #   Hash.new(BottlesNumber).merge(
  #     0 => BottlesNumber0,
  #     1 => BottlesNumber1,
  #     6 => BottlesNumber6
  #   )[number].new(number)
  # end

  def self.registry
    @registry ||= [BottlesNumber]
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  def self.for(number)
    registry.find { |candidate| candidate.handles?(number) }.new(number)
  end

  def self.handles?(number)
    true
  end

  def self.inherited(candidate)
    super
    register(candidate)
  end

  def to_s
    "#{quantity} #{container}"
  end

  def action
    "Take #{pronoun} down and pass it around"
  end

  def container
    "bottles"
  end

  def pronoun
    'one'
  end

  def quantity
    "#{number}"
  end

  def successor
    BottlesNumber.for(number - 1)
  end
end


class BottlesNumber0 < BottlesNumber
  def self.handles?(number)
    number == 0
  end

  def quantity
    "no more"
  end

  def action
    "Go to the store and buy some more"
  end

  def successor
    BottlesNumber.for(99)
  end
end

class BottlesNumber1 < BottlesNumber
  def self.handles?(number)
    number == 1
  end

  def container
    "bottle"
  end

  def pronoun
    'it'
  end
end

class BottlesNumber6 < BottlesNumber
  def self.handles?(number)
    number == 6
  end

  def container
    "six-pack"
  end

  def quantity
    "#{1}"
  end
end