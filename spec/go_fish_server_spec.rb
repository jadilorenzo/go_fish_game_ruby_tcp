# frozen_string_literal: true

require 'socket'
require_relative '../lib/go_fish_server'

class MockGoFishSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 1.0)
    sleep(delay)
    @output = @socket.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket&.close
  end
end

describe GoFishSocketServer do
  let(:server) { GoFishSocketServer.new }
  let(:clients) { [] }

  def create_client
    client = MockGoFishSocketClient.new(server.port_number)
    sleep 1
    clients.push client
    client
  end

  context '#accept_new_client' do
    before(:each) do
      server.start
    end

    after(:each) do
      clients.each(&:close)
      server.stop
    end

    around(:each) do |example|
      example.run
    rescue GoFishGame::NotEnoughPlayers
      binding.irb
    end

    # TODO: refactor these tests to not break 7 line rule.
    it 'accepts one client and asks for their name' do
      client1 = create_client
      server.accept_new_client
      output = client1.capture_output
      expect(output).to match 'Name?'
    end

    it 'client provides name' do
      client1 = create_client
      server.accept_new_client
      expect(client1.capture_output).to match 'Name?' # Name question
      client1.provide_input('Jacob')
      server.create_game_if_possible
      expect(client1.capture_output).to match 'Waiting for 1 more player'
    end

    it 'starts a game once 2 players join' do
      client1 = create_client
      server.accept_new_client
      client1.capture_output # Name question
      client1.provide_input('Jacob')
      server.create_game_if_possible
      expect(client1.capture_output).to match 'Waiting for 1 more player'

      client2 = create_client
      server.accept_new_client
      client2.capture_output # Name question
      client2.provide_input('Hunter')
      game = server.create_game_if_possible
      expect(client2.capture_output).to match 'Game is starting'
      expect(client1.capture_output).to match 'Game is starting'
      expect(game.players.map(&:name)).to match_array %w[Jacob Hunter]
    end

    it 'shows each player their hand, prompt player 1 for turn' do
      # Given
      client1 = create_client
      server.accept_new_client
      client1.capture_output # Name question
      client1.provide_input('Jacob')
      server.create_game_if_possible
      expect(client1.capture_output).to match 'Waiting for 1 more player'

      # And
      client2 = create_client
      server.accept_new_client
      client2.capture_output # Name question
      client2.provide_input('Hunter')
      game = server.create_game_if_possible
      expect(client2.capture_output).to match 'Game is starting'
      expect(client1.capture_output).to match 'Game is starting'
      expect(game.players.map(&:name)).to match_array %w[Jacob Hunter]

      # When
      server.run_game(game)

      # Then
      prompt = client1.capture_output
      expect(prompt).to match "It's your turn. Here is your hand"
      expect(prompt).to match 'players'
      expect(client2.capture_output).to match "It's Jacob's turn. Here is your hand"
    end

    it 'allows a player to take a turn and see results' do
      # Given
      client1 = create_client
      server.accept_new_client
      client1.capture_output # Name question
      client1.provide_input('Jacob')
      server.create_game_if_possible
      expect(client1.capture_output).to match 'Waiting for 1 more player'

      # And
      client2 = create_client
      server.accept_new_client
      client2.capture_output # Name question
      client2.provide_input('Hunter')
      game = server.create_game_if_possible
      expect(client2.capture_output).to match 'Game is starting'
      expect(client1.capture_output).to match 'Game is starting'
      expect(game.players.map(&:name)).to match_array %w[Jacob Hunter]

      # When
      server.run_game(game)

      # And
      prompt = client1.capture_output
      expect(prompt).to match "It's your turn. Here is your hand"
      expect(prompt).to match 'players'
      expect(client2.capture_output).to match "It's Jacob's turn. Here is your hand"

      # Then
      request = { player_index: 1, rank: game.players.first.hand.first.rank }.to_json
      client1.provide_input(request)
      server.run_round(game)
      expect(client1.capture_output).to match 'Result was'
      expect(client2.capture_output).to match 'Result was'
    end
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end

# Next Steps:
# - Commit before moving forward!
# - Reduce or investigate to understand intermittent falures
# - Make tests pass the 7 line rule
# - Use CRC to understand the difference between the server and the game runner
# - Split the GoFishGameRunner out of server
# - Refactor go fish server to pass the 7 line rule
