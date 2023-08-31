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

  def capture_output(delay = 0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
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

  context 'game started' do
    def connect_client(name, welcome_message)
      client = MockGoFishSocketClient.new(server.port_number)
      server.accept_new_client(name)
      expect(client.capture_output).to eq welcome_message

      server.create_game_if_possible
      client
    end

    it 'Tells each player how many cards they have left' do
      server.start

      client1 = connect_client('Player 1', "Welcome.  Waiting for another player to join.\n")
      client2 = connect_client('Player 2', "Welcome.  You are about to go fishing.\n")

      expect(client1.capture_output).to eq "Player 1 has 7 cards and 0 books\n"
      expect(client2.capture_output).to eq "Player 2 has 7 cards and 0 books\n"
    end
  end

  # context '#accept_new_client' do
  #   after(:each) do
  #     server.stop
  #     server.clients.each(&:close)
  #   end

  #   it 'accepts one client' do
  #     server.start
  #     client1 = MockGoFishSocketClient.new(server.port_number)
  #     server.accept_new_client
  #     client1.provide_input('Jacob')

  #     binding.irb

  #     expect(server.clients.first.last).to eql client1.socket
  #   end

  #   # it 'asks for name' do
  #   #   server.start
  #   #   client1 = MockGoFishSocketClient.new(server.port_number)
  #   #   server.accept_new_client
  #   #   expect(server.clients.first.socket).to_not eql client1
  #   # end

  #   # it 'accepts two clients' do
  #   #   server.start
  #   #   MockGoFishSocketClient.new(server.port_number)
  #   #   MockGoFishSocketClient.new(server.port_number)
  #   #   server.accept_new_client
  #   #   server.accept_new_client
  #   #   expect(server.clients).to have_length 2
  #   # end
  # end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
