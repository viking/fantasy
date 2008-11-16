class Fantasy
  class Fetcher
    def initialize(host)
      uri = URI.parse(host)
      @host    = uri.host
      @scheme  = uri.scheme
      @port    = uri.port
      @threads = []
    end

    def fetch(url, &callback)
      uri = URI.parse(url)
      uri.host = @host; uri.scheme = @scheme; uri.port = @port

      @threads << Thread.new(uri.to_s) do |url|
        body = Curl::Easy.perform(url).body_str
        puts "Done fetching: #{url}"  if $DEBUG
        callback.(body)
      end
    end

    def join
      @threads.each { |t| t.join }
    end
  end
end
