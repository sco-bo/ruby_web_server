require 'socket'
require 'json'

class Client
  attr_accessor :host, :port, :path, :hash, :expanded_hash
  
  def initialize
    @host = 'localhost'
    @port = 2000
    @path = "/index.html" 
    @hash = Hash.new
    @expanded_hash = Hash.new
    server_action
  end

  def request_type
    puts "What type of request would you like to send? (GET or POST)"
    type = gets.chomp.upcase
  end

  def server_action
    if request_type == "POST"
      puts "YOU'RE GOING ON A RAID!"
      puts "What is the Viking's name?"
      name = gets.chomp
      puts "What is the Viking's email?"
      email = gets.chomp
      hash[:name] = name
      hash[:email] = email
      expanded_hash[:viking] = hash
      server_post(expanded_hash.to_json)
    else
      server_get
    end
  end

  def server_get
    request = "GET #{path} HTTP/1.1\r\n\r\n" 
    socket_do(request)
  end

  def socket_do(request)
    socket = TCPSocket.open(host,port)
    socket.print(request)
    while line = socket.gets
     puts line.chop
    end
    socket.close
  end

  def server_post(expanded_hash)
    request = "POST #{expanded_hash} HTTP/1.1\r\n\r\n" 
    socket_do(request)
  end
end

Client.new