# frozen_string_literal: true

require_relative 'playing_card'

class CardDeck
  attr_accessor :shuffled

  DECK_SIZE = PlayingCard::SUITS.length * PlayingCard::RANKS.length

  def initialize(cards: generate_full_deck)
    @cards = cards || []
    @shuffled = false
  end

  def cards_left
    @cards.length
  end

  def draw_cards(number_of_cards)
    @cards.slice!(0, number_of_cards)
  end

  def draw
    draw_cards(1).first
  end

  def shuffle(seed = nil)
    @shuffled = true
    seed ? @cards.shuffle!(random: Random.new(seed)) : @cards.shuffle!
  end

  def shuffled?
    @shuffled
  end

  def empty?
    cards_left.zero?
  end

  private

  def generate_full_deck
    PlayingCard::SUITS.flat_map do |suit|
      PlayingCard::RANKS.map do |rank|
        PlayingCard.new(rank, suit)
      end
    end
  end
end
