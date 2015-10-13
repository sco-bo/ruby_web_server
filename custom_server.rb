require 'socket'
require 'json'

class Server
  attr_accessor :client, :request, :split_request, :request_type, :filename, :server

  def initialize
    @server = TCPServer.new('localhost', 2000)
    @client = client
    @request = request
    @split_request = split_request
    @request_type = request_type.to_s
    @filename = filename.to_s
    server_loop
  end

  def server_loop
    loop do
      client = server.accept
      request = client.gets
      STDERR.puts request #for troubleshooting
      split_request = request.split(" ")
      request_type = split_request[0]
      filename = split_request[1]
      
      if request_type == "GET"
        filename[0] = ''
        begin
          display_file = File.open(filename, 'r')
          content = display_file.read
          client.print "\r\nHTTP/1.1 200 OK\r\n" +
                      "Content-Type: text/html\r\n " +
                      "Content-Length: #{content.to_s.bytesize}\r\n" +
                      "Connection: close\r\n"
          client.print "\r\n"
          client.print content 
          client.print "\r\n"
        rescue Errno::ENOENT
          error_message = "404 File Not Found\r\n"
          client.print error_message
          client.print "HTTP/1.1 404 Not Found\r\n" +
                       "Content-Type: text/html\r\n" + 
                       "Content-Length: #{error_message.bytesize}\r\n" +
                       "Connection: close\r\n"
          client.print "\r\n"
        end
      else
        begin
          params = Hash.new 
          params = JSON.parse(filename)
          template_letter = File.read "thanks.html"
          content = "<li>Name: #{params['viking']['name']}</li><li>Email: #{params['viking']['email']}</li>"
          client.print template_letter.gsub("<%= yield %>", content)
        rescue Errno::ENOENT
          client.print error_message
          client.print "HTTP/1.1 404 Not Found\r\n" +
                       "Content-Type: text/html\r\n" + 
                       "Content-Length: #{error_message.bytesize}\r\n" +
                       "Connection: close\r\n"
          client.print "\r\n"
        end
      end    
      client.close
    end
  end

end

Server.new