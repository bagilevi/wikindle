require 'net/http'
class Retriever
  def initialize(lang, path)
    @lang = lang
    @path = path
  end

  attr_reader :lang, :path

  def url
    smartphone_url
  end

  def original_url
    "http://#{lang}.wikipedia.org#{path}"
  end

  def smartphone_url
    "http://#{lang}.m.wikipedia.org#{path}"
  end

  def mobile_url
    if path =~ %r{^/wiki/(.*)}
      "http://mobile.wikipedia.org/transcode.php?go=#{$1}"
    else
      "http://mobile.wikipedia.org"
    end
  end

  def content
    retrieve_content
  end

  def retrieve_content
    @response = fetch(url)
    @response.body.to_s
  end

  def fetch(uri_str, limit = 10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess     then response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else response
    end
  end

  attr_reader :response
end
