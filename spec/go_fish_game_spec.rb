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
      expect(game.turn).to eq 0
    end

    it 'throws error if not enough players' do
      expect do
        GoFishGame.new(players: [GoFishPlayer.new('Bobby Big Boy')])
      end.to raise_error(GoFishGame::NotEnoughPlayers)
      expect { GoFishGame.new players: [] }.to raise_error(GoFishGame::NotEnoughPlayers)
    end

    it 'throws error if too many players' do
      expect do
        GoFishGame.new(
          players:
            8.times.map { GoFishPlayer.new('Bobby Big Boy') }.to_a
        )
      end.to raise_error(GoFishGame::TooManyPlayers)
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

  context '#current_player' do
    it 'should return the first player before the first turn,
        should return the second player after the first turn,
        and should go back to the first player after the second turn
    ' do
      game.start
      expect(game.current_player).to eq player1
      game.take_turn(rank: player1.hand.first.rank, player: player2)
      expect(game.current_player).to eq player2
      game.take_turn(rank: player2.hand.first.rank, player: player1)
      expect(game.current_player).to eq player1
    end
  end

  context '#go_fish' do
    it 'should give a player a card from the deck' do
      game.go_fish
      expect(game.deck.cards_left).to eq CardDeck::DECK_SIZE - 1
      expect(game.current_player.hand.length).to eq 1
    end
  end

  context '#take_turn' do
    it 'should not result in a go fish if the player asks for a card from a player that exists' do
      # player 1 hand starts with 2 which player 2 hand also has
      game.deal
      expect(game.deck.shuffled?).to be_falsey
      allow(game).to receive(:go_fish)
      game.take_turn(rank: player1.hand.first.rank, player: player2)
      expect(game).to_not have_received(:go_fish)
    end

    it 'should result in a go fish if the player asks for a card from a player that does not exist' do
      # player 1 hand starts with 2 which player 2 hand also has
      game.deal
      expect(game.deck.shuffled?).to be_falsey
      allow(game).to receive(:go_fish)
      game.take_turn(rank: player1.hand.last.rank, player: player2)
      expect(game).to have_received(:go_fish)
    end

    it 'should move cards from one player to the other on a successful query' do
      game.deal
      expect(game.deck.shuffled?).to be_falsey
      game.take_turn(rank: player1.hand.first.rank, player: player2)
      expect(player1.hand.length).to eq 8
      expect(player2.hand.length).to eq 6
    end

    it 'should raise PlayerDoesNotHaveRequestedRank if the player does not have the requested card' do
      game.deal
      expect { game.take_turn(rank: '5', player: player2) }.to raise_error(GoFishGame::PlayerDoesNotHaveRequestedRank)
    end

    it 'should raise PlayerAskedForHimself if the player asks for a card from themselves' do
      game.deal
      expect do
        game.take_turn(rank: player1.hand.first.rank, player: player1)
      end.to raise_error(GoFishGame::PlayerAskedForHimself)
    end

    it 'determines the winner' do
      game.deal
      expect(game.winner).to be_nil
    end
  end
end
