require 'socket'
require 'json'

require_relative 'go_fish_game'

class GoFishSocketServer
  # attr_reader :clients_to_players
  # attr_accessor :server, :pending_clients, :games, :clients

  attr_accessor :server, :pending_clients, :clients_to_players

  def initialize
    @clients_to_players = {}
    # @games = []
    @pending_clients = []
  end

  def port_number
    3332
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    server&.close
  end

  def accept_new_client
    client = @server.accept_nonblock
    client.puts 'Name?'
    pending_clients.push client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def create_game_if_possible
    # capture input of the name
    pending_clients.each do |client|
      next if clients_to_players[client]

      begin
        name = client.read_nonblock(1000)
        clients_to_players[client] = GoFishPlayer.new(name: name.chomp)
        client.puts 'Waiting for 1 more player' if pending_clients.size.odd?
      rescue IO::WaitReadable, Errno::EINTR
      end
    end

    return unless pending_clients.size.even?

    # start a game if possible
    pending_clients.each do |client|
      client.puts 'Game is starting...'
    end
    GoFishGame.new(players: clients_to_players.values.last(2))
  end

  # TODO: Consider offloading these running methods into a separate class
  # like GoFishGameRunner
  def run_game(game)
    game.start
    game.current_player
    other_players = game.players - [game.current_player]
    current_client = players_to_clients[game.current_player]
    current_client.puts "It's your turn. Here is your hand ..."
    current_client.puts({ prompt: { players: other_players.map(&:name) } }.to_json)
    other_players.each do |player|
      client = players_to_clients[player]
      client.puts "It's #{game.current_player.name}'s turn. Here is your hand ..."
    end
  end

  def run_round(game)
    current_player = game.current_player
    other_players = game.players - [game.current_player]
    current_client = players_to_clients[game.current_player]
    begin
      request = current_client.read_nonblock(1000)
    rescue IO::WaitReadable, Errno::EINTR
    end

    return unless request

    parsed_request = JSON.parse(request)
    requested_player = game.players[parsed_request['player_index']]
    game.take_turn(player: requested_player, rank: parsed_request['rank'])

    if game.current_player == current_player
      current_client.puts 'Nope, try harder'
    else
      current_client.puts "It's still your turn. Here is your hand ..."
    end
    other_players.each do |player|
      client = players_to_clients[player]
      client.puts 'Round result was ...'
    end
  end

  private

  def players_to_clients
    clients_to_players.invert
  end
end
