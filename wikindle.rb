require 'sinatra'

get '/about' do
  erb :about
end

get %r{(.*)} do
  path = params[:captures].first
  retriever = WikipediaGetter.new('en', path)
  original_content = retriever.content
  @content = Transformer.new(original_content).tap(&:execute).content
  @title = original_content[%r{<title>(.*)<\/title>}, 1]
  @original_url = retriever.original_url
  @smartphone_url = retriever.smartphone_url
  @mobile_url = retriever.mobile_url

  if path == '/'
    @content = erb(:homepage_head, :layout => false) + @content
  end

  erb :article
end

not_found do
  'This is nowhere to be found.'
end

error do
  'Sorry there was a nasty error'
end

require 'net/http'
require 'open-uri'
class WikipediaGetter
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


require 'erb'
class Transformer
  def initialize(content)
    @content = content
  end

  attr_accessor :content
  private :content=

  def execute
    cut_main_content
    remove_edit_links
    remove_section 'jumpto'
    insert_after "From Wikipedia, the free encyclopedia", ', <a href="/about">optimized for Kindle</a>'
  end

  private

  def cut_main_content
    # Cut from original version
    cut_content = cut_string content,
                             '<!-- firstHeading -->',
                             '<!-- /bodyContent -->'
    self.content = cut_content unless cut_content.nil?

    # Cut from smartphone version
    cut_content = cut_string_inside content,
                             '<body>',
                             '</body>'
    self.content = cut_content unless cut_content.nil?
  end

  def cut_string_inside str, a, b
    i1 = str.index(a) or return
    i2 = str.index(b) or return
    str[(i1 + a.length) .. (i2 - 1)]
  end

  def cut_string str, a, b
    i1 = str.index(a) or return
    i2 = str.index(b) or return
    str[i1 .. (i2 + b.length - 1)]
  end

  def remove_edit_links
    content.gsub!(
      %r{<span class="editsection">.*>edit</a>\]</span>},
      ''
    )
  end

  def remove_section name
    content.gsub!(
      %r{<!-- #{name} -->.*<!-- /#{name} -->}m,
      ''
    )
  end

  def insert_after needle, insertee
    pos = content.index(needle) or return
    content.insert(pos + needle.length, insertee)
  end
end
