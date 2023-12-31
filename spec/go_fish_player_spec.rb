# frozen_string_literal: true

require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe 'GoFishPlayer' do
  let(:card1) { PlayingCard.new('A', 'S') }
  let(:card2) { PlayingCard.new('2', 'S') }
  let(:card3) { PlayingCard.new('3', 'S') }
  let(:card4) { PlayingCard.new('2', 'H') }
  let(:player) { GoFishPlayer.new('Pancy Nelosi') }
  let(:ace_book) do
    [
      PlayingCard.new('A', 'S'), PlayingCard.new('A', 'H'),
       PlayingCard.new('A', 'C'), PlayingCard.new('A', 'D')
    ]
  end

  it 'has name, empty hand, and empty books' do
    expect(player.name).to eq 'Pancy Nelosi'
    expect(player.hand.length).to eq 0
    expect(player.books.length).to eq 0
  end

  it 'takes hand' do
    player = GoFishPlayer.new('Ced Truz', hand: ['card'])
    expect(player.hand).to eq ['card']
  end

  context '#take' do
    it 'adds a card' do
      player.take(card: card1)
      card = player.hand.first
      expect(card).to eq card1
    end

    it 'adds cards' do
      player.take(cards: [card1, card2])
      card = player.hand.first
      expect(card).to eq card1
    end

    it 'throws error if given a single card and multiple cards' do
      expect { player.take(cards: [card1, card2], card: card3) }.to raise_error GoFishPlayer::TakeReceivedCardsAndCard
    end

    it 'throws error if given no cards' do
      expect { player.take }.to raise_error GoFishPlayer::TakeReceivedNothing
    end

    it 'adds one book when found and removes cards from hand' do
      player.take(cards: ace_book)
      player.take(card: card2)
      expect(player.books).to eq [ace_book]
      expect(player.books.length).to eq 1
      expect(player.hand.length).to be 1
    end

    it 'adds multiple books as they are found and removes all the cards from hand' do
      player.take(cards: [
        PlayingCard.new('3', 'H'), PlayingCard.new('3', 'S'), PlayingCard.new('3', 'D')
      ] + ace_book)
      player.take(card: card3)
      expect(player.books.length).to eq 2
      expect(player.hand.length).to be 0
    end
  end

  # context '#give' do
  #   it 'gives card' do
  #     player.take(cards: [card1, card2, card3])
  #     expect(player.give).to eq card1
  #     expect(player.hand.length).to eq 2
  #     expect(player.give).to eq card2
  #     expect(player.hand.length).to eq 1
  #   end
  # end

  context '#give_cards_of_rank' do
    before do
      player.take(cards: [card1, card2, card3, card4])
    end

    it 'throws error if given invalid rank' do
      expect { player.give_cards_of_rank('') }.to raise_error GoFishPlayer::InvalidRank
      expect { player.give_cards_of_rank('L') }.to raise_error GoFishPlayer::InvalidRank
      expect { player.give_cards_of_rank('Ace') }.to raise_error GoFishPlayer::InvalidRank
    end

    it 'returns one card if it matches the rank' do
      expect(player.give_cards_of_rank(card1.rank)).to eq [card1]
    end

    it 'returns cards if they match the rank' do
      expect(player.give_cards_of_rank(card2.rank)).to eq [card2, card4]
      expect(player.hand).to eq [card1, card3]
    end

    it 'returns nothing if no cards match the rank' do
      sample_rank_not_in_hand = '5'
      expect(player.give_cards_of_rank(sample_rank_not_in_hand)).to eq []
    end
  end

  context '#rank_in_hand?' do
    it 'returns true if player has the rank' do
      player.take(card: card1)
      expect(player.rank_in_hand?(card1.rank)).to be_truthy
    end

    it 'returns false if player does not have the rank' do
      expect(player.rank_in_hand?(card2.rank)).to be_falsey
    end
  end
end
