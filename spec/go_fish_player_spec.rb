# frozen_string_literal: true

require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  it 'has name and empty hand' do
    player = WarPlayer.new('Pancy Nelosi')
    expect(player.name).to eq 'Pancy Nelosi'
    expect(player.hand.length).to eq 0
  end

  it 'takes hand' do
    player = WarPlayer.new('Ced Truz', hand: ['card'])
    expect(player.hand).to eq ['card']
  end

  context '#take' do
    it 'adds a card' do
      player = WarPlayer.new('Dacob Ji Lorenzo')
      player.take([PlayingCard.new('A', 'S')])
      card = player.play
      expect(card).to eq PlayingCard.new('A', 'S')
    end
  end

  context '#play' do
    it 'plays card' do
      player = WarPlayer.new('Kunter Hendall')
      player.take([PlayingCard.new('A', 'S')])
      player.take([PlayingCard.new('2', 'S'), PlayingCard.new('3', 'S')])
      card = player.play
      expect(card).to eq PlayingCard.new('A', 'S')
      expect(player.hand.length).to eq 2
      card2 = player.play
      expect(card2).to eq PlayingCard.new('2', 'S')
      expect(player.hand.length).to eq 1
    end
  end
end
