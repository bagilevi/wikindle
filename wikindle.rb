require 'sinatra'

$: << './lib'
require 'retriever'
require 'transformer'

get '/about' do
  erb :about
end

get %r{^(\/|\/wiki\/.*)$} do
  path = params[:captures].first
  retriever = Retriever.new('en', path)
  original_content = retriever.content
  @content = Transformer.new(original_content).tap(&:execute).content
  @title = original_content[%r{<title>(.*)<\/title>}, 1]
  @original_url = retriever.original_url
  @smartphone_url = retriever.smartphone_url
  @mobile_url = retriever.mobile_url

  if path == '/'
    @content = erb(:homepage_head, :layout => false) + @content
    @title = 'wikindle.org'
  end

  erb :article
end

not_found do
  'This is nowhere to be found.'
end

error do
  'Sorry there was a nasty error'
end


