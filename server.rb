require 'bundler/setup'
Bundler.require(:default)

require 'rack/lobster'

require_relative 'websocket_handler'

Thin::Server.start('0.0.0.0', 4567) do

  map '/' do
    webroot = File.join(__dir__, 'public')
    use Rack::Deflater
    use Rack::Static, :urls => [''], :root => 'public', :index => 'index.html'
    run Rack::File.new webroot
  end

  map '/websocket' do
    run WebSocketHandler.new
  end

end
