# frozen_string_literal: true

require_relative '../lib/go_fish_game'
require_relative '../lib/playing_card'
require_relative '../lib/go_fish_player'

describe 'GoFishGame' do
  let(:player1) { GoFishPlayer.new('Muffin') }
  let(:player2) { GoFishPlayer.new('Potato') }
  let(:game) { GoFishGame.new(players: [player1, player2]) }
  let(:card_deck) { CardDeck.new }
  let(:players) { game.players }

  context '#initialize' do
    it 'has players, card deck, no winner, and has not been dealt' do
      expect(players[0].name).to eq('Muffin')
      expect(players[1].name).to eq('Potato')
      expect(game.deck).to_not be_nil
      expect(game.winner).to be_nil
      expect(game.dealt?).to be_falsey
    end

    it 'throws error if not enough players' do
      expect do
        GoFishGame.new(players: [GoFishPlayer.new('Bobby Big Boy')])
      end.to raise_error(GoFishGame::NotEnoughPlayers)
      expect { GoFishGame.new players: [] }.to raise_error(GoFishGame::NotEnoughPlayers)
    end

    it 'takes a deck and doesn\'t shuffle it' do
      game = GoFishGame.new(deck: card_deck)
      expect(game.deck).to eq card_deck
      expect(game.deck.shuffled?).to be false
    end
  end

  context '#start' do
    it 'shuffles the deck and deals the cards' do
      game.start
      expect(game.deck.shuffled?).to be_truthy
      expect(game.dealt?).to be_truthy
    end
  end

  context '#deal' do
    it 'should deal the cards' do
      game.deal
      expect(players[0].hand.length).to eq(GoFishGame::DEAL_SIZE[2])
      expect(players[1].hand.length).to eq(GoFishGame::DEAL_SIZE[2])
    end
  end
end
