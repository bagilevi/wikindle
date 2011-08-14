require 'retriever'
require 'transformer'

class Article
  def self.get path
    Article.new(:path => path).tap(&:retrieve)
  end

  attr_accessor :path, :lang, :content
  private :path=, :lang=, :content=

  def initialize(params)
    @path = params[:path]
    @lang = 'en'
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
    end
  end

  def retrieve
    self.content = Retriever.new(smartphone_url).content
  end

  def optimized_content
    Transformer.new(content).tap(&:execute).content
  end

  def title
    content[%r{<title>(.*)<\/title>}, 1]
  end
end

