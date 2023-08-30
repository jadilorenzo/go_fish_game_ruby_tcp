# frozen_string_literal: true

# Go Fish Player
class GoFishPlayer
  class TakeReceivedCardsAndCard < StandardError; end
  class TakeReceivedNothing < StandardError; end
  class InvalidRank < StandardError; end

  attr_accessor :name, :hand

  def initialize(name, hand: [])
    @name = name
    @hand = hand
  end

  def take(cards: nil, card: nil)
    raise TakeReceivedCardsAndCard if card && cards
    raise TakeReceivedNothing if card.nil? && cards.nil?
    return @hand.push card if card

    @hand += cards
  end

  def give
    @hand.shift
  end

  def ask(rank)
    raise InvalidRank unless PlayingCard.valid_rank?(rank)

    hand.filter { |card| card.rank == rank }
  end
end
