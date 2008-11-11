class Fantasy
  class Fetcher
    def initialize(host)
      uri = URI.parse(host)
      @host   = uri.host
      @scheme = uri.scheme
      @port   = uri.port
    end

    def fetch(urls, &callback)
      threads = []
      urls.each do |url|
        uri = URI.parse(url)
        uri.host = @host; uri.scheme = @scheme; uri.port = @port

        threads << Thread.new(uri.to_s) do |url|
          body = Curl::Easy.perform(url).body_str
          puts "Done fetching: #{url}"  if $DEBUG
          callback.(url, body)
        end
      end
      threads.each { |t| t.join }
    end
  end
end
