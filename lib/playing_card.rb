# frozen_string_literal: true

class PlayingCard
  class InvalidRankOrSuitError < StandardError; end

  SUITS = %w[H D C S].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUIT_NAMES = %w[Hearts Diamonds Clubs Spades].freeze
  RANK_NAMES = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze

  attr_accessor :rank, :suit

  def initialize(rank, suit)
    validate(rank, suit)
    @rank = rank
    @suit = suit
  end

  def validate(rank, suit)
    return if PlayingCard.valid_rank?(rank) && SUITS.include?(suit)

    raise InvalidRankOrSuitError, "Invalid rank or suit: #{rank} and #{suit}"
  end

  def value
    RANKS.index(rank) + 2
  end

  def ==(other)
    other.is_a?(PlayingCard) && other.rank == rank && other.suit == suit
  end

  def to_s
    "#{RANK_NAMES[RANKS.index(rank)]} of #{SUIT_NAMES[SUITS.index(suit)]}"
  end

  def self.valid_rank?(rank)
    RANKS.include?(rank)
  end
end
