# frozen_string_literal: true

require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe 'GoFishPlayer' do
  let(:card1) { PlayingCard.new('A', 'S') }
  let(:card2) { PlayingCard.new('2', 'S') }
  let(:card3) { PlayingCard.new('3', 'S') }
  let(:card4) { PlayingCard.new('2', 'H') }
  let(:player) { GoFishPlayer.new('Pancy Nelosi') }

  it 'has name and empty hand' do
    expect(player.name).to eq 'Pancy Nelosi'
    expect(player.hand.length).to eq 0
  end

  it 'takes hand' do
    player = GoFishPlayer.new('Ced Truz', hand: ['card'])
    expect(player.hand).to eq ['card']
  end

  context '#take' do
    it 'adds a card' do
      player.take(card: card1)
      card = player.give
      expect(card).to eq card1
    end

    it 'adds cards' do
      player.take(cards: [card1, card2])
      card = player.give
      expect(card).to eq card1
    end

    it 'throws error if given a single card and multiple cards' do
      expect { player.take(cards: [card1, card2], card: card3) }.to raise_error GoFishPlayer::TakeReceivedCardsAndCard
    end

    it 'throws error if given no cards' do
      expect { player.take }.to raise_error GoFishPlayer::TakeReceivedNothing
    end
  end

  context '#play' do
    it 'plays card' do
      player.take(cards: [card1, card2, card3])
      expect(player.give).to eq card1
      expect(player.hand.length).to eq 2
      expect(player.give).to eq card2
      expect(player.hand.length).to eq 1
    end
  end

  context '#ask' do
    before do
      player.take(cards: [card1, card2, card3, card4])
    end

    it 'throws error if given invalid rank' do
      expect { player.ask('') }.to raise_error GoFishPlayer::InvalidRank
      expect { player.ask('L') }.to raise_error GoFishPlayer::InvalidRank
      expect { player.ask('Ace') }.to raise_error GoFishPlayer::InvalidRank
    end

    it 'returns one card if it matches the rank' do
      expect(player.ask(card1.rank)).to eq [card1]
    end

    it 'returns cards if they match the rank' do
      expect(player.ask(card2.rank)).to eq [card2, card4]
    end

    it 'returns nothing if no cards match the rank' do
      sample_rank_not_in_hand = '5'
      expect(player.ask(sample_rank_not_in_hand)).to eq []
    end
  end
end
