# frozen_string_literal: true

require_relative 'go_fish_player'
require_relative 'card_deck'

# GoFishGame is a class based off the rules of https://gamerules.com/rules/go_fish-card-game/
class GoFishGame
  class NotEnoughPlayers < StandardError; end
  class InvalidRank < StandardError; end
  class PlayerDoesNotHaveRequestedRank < StandardError; end
  class PlayerAskedForHimself < StandardError; end
  class TooManyPlayers < StandardError; end

  DEAL_SIZE = {
    2 => 7,
    3 => 5,
    4 => 5
  }

  attr_reader :players, :deck, :cards_in_play, :winner, :turn, :dealt

  def initialize(
    players: [
      GoFishPlayer.new('Player 1'),
      GoFishPlayer.new('Player 2')
    ],
    deck: CardDeck.new
  )
    raise NotEnoughPlayers if (players.compact.length != players.length) || players.length < 2
    raise TooManyPlayers if players.length > 4

    @players = players
    @deck = deck || CardDeck.new
    @dealt = false
    @winner = nil
    @turn = 0
  end

  def dealt?
    dealt
  end

  def start
    deck.shuffle
    deal
  end

  def deal
    @dealt = true
    DEAL_SIZE[@players.length].times do
      players.each { |player| player.take(card: deck.draw) }
    end
  end

  def go_fish
    current_player.take(card: deck.draw)
  end

  def take_turn(rank:, player:)
    raise InvalidRank unless PlayingCard.valid_rank? rank
    raise PlayerDoesNotHaveRequestedRank unless current_player.rank_in_hand? rank
    raise PlayerAskedForHimself if current_player == player

    recieved_cards = ask_for_rank(player: player, rank: rank)
    return give_cards_to_player recieved_cards unless recieved_cards.empty?

    @turn += 1
    go_fish
  end

  def current_player
    players[turn_index]
  end

  private

  def turn_index
    turn % players.length
  end

  # TODO: named params are probably not needed here
  # Especially for a private method that doesn't have
  # complex arguments. They don't really buy much in terms of
  # being intention revealing. Could change name to
  # `ask_player_for_rank` and it would infer the order of arguments
  # through the method name.
  def ask_for_rank(player:, rank:)
    player.give_cards_of_rank rank
  end

  def give_cards_to_player(cards)
    player = current_player
    @turn += 1
    player.take cards: cards
  end
end
