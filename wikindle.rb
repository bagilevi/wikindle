require 'sinatra'

get %r{(.*)} do
  path = params[:captures].first
  retriever = WikipediaGetter.new('en', path)
  original_content = retriever.content
  @content = Transformer.new(original_content).tap(&:execute).content
  @title = original_content[%r{<title>(.*)<\/title>}, 1]
  @original_url = retriever.url
  @smartphone_url = retriever.smartphone_url
  @mobile_url = retriever.mobile_url
  erb :article
end

require 'open-uri'
class WikipediaGetter
  def initialize(lang, path)
    @lang = lang
    @path = path
  end

  attr_reader :lang, :path

  def url
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
    open(url).read
  end
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
  end

  private

  def cut_main_content
    cut_content = cut_string content,
                             '<!-- firstHeading -->',
                             '<!-- /bodyContent -->'
    self.content = cut_content unless cut_content.nil?
  end

  def cut_string str, a, b
    i1 = str.index(a) or return
    i2 = str.index(b) or return
    str[i1 .. (i2 + b.length - 1)]
  end

  def remove_edit_links
    content.gsub!(
      %r{<span class="editsection">.*>edit</a>]</span>},
      ''
    )
  end
end
