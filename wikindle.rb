require 'sinatra'
require 'cgi'

$: << './lib'
require 'article'

get '/about' do
  erb :about
end

get '/' do
  article = Article.get '/'
  set_template_params_from_article(article)
  @title = "wikindle.org - Wikipedia optimized for Kindle"
  @content = erb(:homepage_head, :layout => false) + @content
  erb :article
end

get '/wiki/:article' do |article_slug|
  article = Article.get "/wiki/#{CGI.escape(article_slug)}"
  set_template_params_from_article(article)
  erb :article
end

def set_template_params_from_article article
  @content        = article.optimized_content
  @title          = article.title
  @original_url   = article.original_url
  @smartphone_url = article.smartphone_url
  @mobile_url     = article.mobile_url
end

not_found do
  'This is nowhere to be found.'
end

error do
  'Sorry there was a nasty error'
end


