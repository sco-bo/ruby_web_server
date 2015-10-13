### Command Line Server/Browser

This is a simple server to process GET/POST requests and send responses, and a simple browser to issue requests. 

To view this in action, open two terminals. In the first, run `ruby custom_server.rb`. In the second, run `ruby custom_client.rb`. In the client window, you will be prompted for the type of request you'd like to issue (GET/POST). 

# GET requests
If a GET request is issued, the server looks in the current directory for the file requested. It then displays those file contents back to the client

# Post requests
If a a POST request is issued, the client generates a JSON string with the relevant information, which it then sends to the server. The server parses the JSON string and sends the client a mini view of the HTML content with the new user supplied conenent incorporated. 

***Be sure to enter CTRL-C to shut down the web server.*** 