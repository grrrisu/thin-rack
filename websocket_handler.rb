class WebSocketHandler

  def initialize
    Faye::WebSocket.load_adapter('thin')
    @clients = []
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      puts "go websocket go!!!"

      ws = Faye::WebSocket.new(env)

      ws.on :open do |event|
        puts "websocket opened"
        @clients.push ws
      end

      ws.on :message do |event|
        @clients.each { |c| c.send(event.data) if c }
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end

      ws.on :error do |event|
        p "websocket error: #{event.inspect}"
      end

      # Return async Rack response
      ws.rack_response

    else
      [200, {'Content-Type' => 'text/plain'}, ['Did you expect a websocket connection?']]
    end
  end

end
