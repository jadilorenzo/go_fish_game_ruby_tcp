# frozen_string_literal: true

require_relative '../lib/go_fish_client'
require 'socket'

class MockGoFishServer
  def initialize
    @server = nil
    @clients = []
  end

  def port_number
    3335
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client
    client = @server.accept_nonblock
    client.puts 'What is your name?'
  rescue IO::WaitReadable, Errno::EINTR
    puts 'No client to accept'
  end

  def stop
    @server&.close
  end
end

describe 'GoFishSocketClient' do
  let(:server) { MockGoFishServer.new }

  before do
    server.start
  end

  after do
    server.stop
  end

  it 'captures output' do
    client = GoFishSocketClient.new(3335)
    server.accept_new_client

    client.capture_output
    expect(client.output).to eq 'What is your name?'
  end
end
