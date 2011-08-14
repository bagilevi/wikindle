require 'sinatra'
require 'cgi'

$: << './lib'
require 'article'
require 'settings'

before do
  @settings = Settings.new(self)
  @path = request.path
end

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

get '/wiki' do
  if params['search']
    article = Article.get "/wiki?search=#{CGI.escape(params['search'])}"
    set_template_params_from_article(article)
    erb :article
  else
    raise Sinatra::NotFound
  end
end

def set_template_params_from_article article
  @content        = article.optimized_content
  @title          = article.title
  @original_url   = article.original_url
  @smartphone_url = article.smartphone_url
  @mobile_url     = article.mobile_url
end

get '/settings' do
  @title = "Settings - wikindle.org"
  @size_options = Settings::SIZE_OPTIONS
  @current_size = @settings.size
  haml :settings, :layout_engine => :erb
end

post '/settings' do
  @settings.save_from_input
  redirect '/settings'
end


not_found do
  haml :not_found, :layout_engine => :erb
end

error do
  haml :error, :layout_engine => :erb
end


