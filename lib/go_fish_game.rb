# frozen_string_literal: true

require_relative 'go_fish_player'
require_relative 'card_deck'

# GoFishGame is a class based off the rules of https://gamerules.com/rules/go_fish-card-game/
class GoFishGame
  class NotEnoughPlayers < StandardError; end
  DEAL_SIZE = {
    2 => 7,
    3 => 5,
    4 => 5
  }

  attr_accessor :players, :deck, :cards_in_play, :winner

  def initialize(
    players: [
      GoFishPlayer.new('Player 1'),
      GoFishPlayer.new('Player 2')
    ],
    deck: CardDeck.new
  )
    raise NotEnoughPlayers if (players.compact.length != players.length) || players.length < 2

    @players = players
    @deck = deck || CardDeck.new
    @dealt = false
    @winner = nil
  end

  def dealt?
    @dealt
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
end
