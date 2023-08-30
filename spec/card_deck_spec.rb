# frozen_string_literal: true

require_relative '../lib/card_deck'
require_relative '../lib/playing_card'

describe 'CardDeck' do
  let(:card1) { PlayingCard.new('A', 'S') }
  let(:card2) { PlayingCard.new('3', 'C') }
  let(:card3) { PlayingCard.new('J', 'H') }
  let(:cards) { [card1, card2, card3] }

  let(:deck) { CardDeck.new }
  let(:deck_with_cards) { CardDeck.new(cards: cards) }
  let(:deck_with_top_cards) { CardDeck.new(cards: [card1, card3]) }

  it 'should have a default 52 cards' do
    expect(deck.cards_left).to eq 52
    expect(deck.draw_cards(52).first.suit).to_not be_nil
    expect(deck.shuffled?).to_not be_truthy
  end

  it 'should take cards' do
    expect(deck_with_cards.cards_left).to eq cards.length
  end

  context '#draw_cards' do
    it 'should draw the first top card' do
      card = deck_with_cards.draw_cards(1).first
      expect(card).to eq card1
      expect(deck_with_cards.cards_left).to eq 2
    end

    it 'should draw unique cards' do
      cards = deck.draw_cards(2)
      expect(cards.first).to_not eq cards[1]
    end

    it 'should draw the two top cards' do
      cards = deck_with_top_cards.draw_cards(2)
      expect(cards.first).to eq card1
      expect(cards.last).to eq card3
      expect(deck_with_top_cards.cards_left).to eq 0
    end
  end

  context '#draw' do
    it 'should draw the first top card' do
      card = deck_with_cards.draw
      expect(card).to eq card1
      expect(deck_with_cards.cards_left).to eq 2
    end
  end

  context '#shuffle' do
    it 'should shuffle the deck' do
      deck1 = CardDeck.new
      deck1.shuffle(1)
      card1 = deck1.draw
      deck2 = CardDeck.new
      deck2.shuffle(2)
      card2 = deck2.draw
      expect(card1).not_to eq card2
    end

    it 'can call shuffle without arguments' do
      expect do
        deck1 = CardDeck.new
        deck1.shuffle
      end.not_to raise_error
    end

    it 'changes shuffled state' do
      deck1 = CardDeck.new
      expect(deck1.shuffled?).to_not be_truthy
      deck1.shuffle
      expect(deck1.shuffled?).to be_truthy
    end
  end

  context '#empty?' do
    it 'should return false when not empty' do
      deck = CardDeck.new
      expect(deck.empty?).to_not be_truthy
    end

    it 'should return true when empty' do
      deck = CardDeck.new(cards: [])
      expect(deck.empty?).to be_truthy
    end
  end
end
