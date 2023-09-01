# frozen_string_literal: true

# Go Fish Player
class GoFishPlayer
  class TakeReceivedCardsAndCard < StandardError; end
  class TakeReceivedNothing < StandardError; end
  class InvalidRank < StandardError; end

  attr_accessor :name, :hand, :books

  def initialize(name:, hand: [])
    @name = name
    @hand = hand
    @books = []
  end

  def take(cards: nil, card: nil)
    new_cards = add cards: cards, card: card
    check_for_books
    new_cards
  end

  def give_cards_of_rank(rank)
    raise InvalidRank unless PlayingCard.valid_rank?(rank)

    matching_cards = cards_of_rank rank
    @hand -= matching_cards
    matching_cards
  end

  def rank_in_hand?(rank)
    hand.any? { |card| card.rank == rank }
  end

  # TODO: test me
  def to_s
    "#{name} has #{hand.count} cards and #{books.count} books"
  end

  private

  def add(card: nil, cards: nil)
    raise TakeReceivedCardsAndCard if card && cards
    raise TakeReceivedNothing if card.nil? && cards.nil?

    return @hand.push card if card

    @hand += cards
  end

  def cards_of_rank(rank)
    hand.filter { |card| card.rank == rank }
  end

  def check_for_books
    ranks_in_hand = hand.map(&:rank)
    book_ranks = ranks_in_hand.select { |rank| ranks_in_hand.count(rank) == 4 }.uniq
    @books += book_ranks.map { |rank| hand.filter { |card| card.rank == rank } }
    @hand = @hand.reject { |card| book_ranks.include?(card.rank) }
    @books
  end
end
