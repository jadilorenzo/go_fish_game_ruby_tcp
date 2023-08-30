# frozen_string_literal: true

require_relative '../lib/playing_card'

describe 'PlayingCard' do
  let(:ace_of_spades) { PlayingCard.new('A', 'S') }
  let(:two_of_hearts) { PlayingCard.new('2', 'H') }
  let(:queen_of_diamonds) { PlayingCard.new('Q', 'D') }
  let(:king_of_clubs) { PlayingCard.new('K', 'C') }

  it 'has rank and suit' do
    expect(ace_of_spades.rank).to eq 'A'
    expect(ace_of_spades.suit).to eq 'S'
  end

  it 'only takes a valid rank and suit' do
    expect do
      PlayingCard.new('3', 'Geese')
    end.to raise_error(PlayingCard::InvalidRankOrSuitError, 'Invalid rank or suit: 3 and Geese')
    expect do
      PlayingCard.new('34', 'C')
    end.to raise_error(PlayingCard::InvalidRankOrSuitError, 'Invalid rank or suit: 34 and C')
  end

  context '#==' do
    it 'returns true for equal cards' do
      expect(ace_of_spades).to eq ace_of_spades
    end

    it 'returns false for unequal cards' do
      expect(ace_of_spades).not_to eq two_of_hearts
      expect(queen_of_diamonds).not_to eq ace_of_spades
    end

    it 'returns false for non-card' do
      expect(ace_of_spades).not_to eq 'A S'
    end
  end

  context '#to_s' do
    it 'returns a string representation of the playing card' do
      expect(ace_of_spades.to_s).to eq 'Ace of Spades'
      expect(two_of_hearts.to_s).to eq '2 of Hearts'
      expect(queen_of_diamonds.to_s).to eq 'Queen of Diamonds'
      expect(king_of_clubs.to_s).to eq 'King of Clubs'
    end
  end
end
