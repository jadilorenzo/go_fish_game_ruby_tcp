require 'socket'

require_relative 'go_fish_game'

class GoFishSocketServer
  # attr_reader :pending_clients, :server

  def initialize; end

  def port_number
    3336
  end

  def games
    @games ||= []
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(_player_name = 'Random Player')
    client = @server.accept_nonblock
    pending_clients.push(client)
    client.puts(pending_clients.count.odd? ? 'Welcome.  Waiting for another player to join.' : 'Welcome.  You are about to go fishing.')
    # associate player and client
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def create_game_if_possible
    return unless pending_clients.count > 1

    game = GoFishGame.new
    games.push(game)
    games_to_humans[game] = pending_clients.shift(2)
    game.start
    inform_players_of_hand(game)
  end

  def stop
    return unless server

    server.close
    @clients = []
  end

  private

  def inform_players_of_hand(game)
    humans = games_to_humans[game]
    humans[0].puts(game.players[0])
    humans[1].puts(game.players[1])
  end

  def pending_clients
    @pending_clients ||= []
  end

  def games_to_humans
    @games_to_humans ||= {}
  end
end
