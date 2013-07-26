require 'sinatra'
require 'haml'
require 'coffee-script'
require 'json'

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
require 'wnp'

if ! $data_store
  $data_store = Wnp::Data.new "./.app_data"
end

enable :sessions

get '/' do
  if current_user
    user_pages = Wnp::Services::UserPages.new(current_user)
    page_ids_and_names = user_pages.page_ids_and_names_sorted_by_name
    haml :index, :locals => {:user => current_user,
      :page_ids_and_names => page_ids_and_names}
  else
    redirect to('/login')
  end
end

get '/application.js' do
  coffee :application
end

get '/login' do
  haml :login
end

post '/login' do
  user = Wnp::Models::User.authenticate params[:email], params[:password]
  if user
    session[:access_token] = user.access_token
  end
  redirect to('/')
end

get '/p/:name' do |page_name|
  authorize!
  user_pages = Wnp::Services::UserPages.new(current_user)
  page = user_pages.find_page_with_name page_name
  if page
    viewmodel = Wnp::Viewmodels::Page.new(current_user, page)
    haml :page, :locals => {:viewmodel => viewmodel}
  else
    error "could not find that page"
  end
end

get '/p/:name/edit' do |page_name|
  authorize!
  user_pages = Wnp::Services::UserPages.new(current_user)
  page = user_pages.find_page_with_name page_name
  if page
    haml :page_edit, :locals => {:page => page}
  end
end

get '/p/:name/tags' do |page_name|
  authorize!
  user_pages = Wnp::Services::UserPages.new(current_user)
  page = user_pages.find_page_with_name page_name
  if page
    object_tags = Wnp::Services::ObjectTags.new(page)
    return object_tags.sorted_tag_names().map{|tag| {:text => tag} }.to_json
  else
    return {:error => "could not find that page"}.to_json
  end
end

post '/p/:name/tags' do |page_name|
  authorize!
  user_pages = Wnp::Services::UserPages.new(current_user)
  page = user_pages.find_page_with_name page_name
  if page
    request.body.rewind
    request_payload = JSON.parse request.body.read
    tag = request_payload["text"]
    Wnp::Services::ObjectTags.new(page).add_tag tag
    Wnp::Services::UserPageTags.new(current_user, page).add_tag tag
    return {:success => "added tag #{tag}"}.to_json
  else
    return {:error => "could not find that page"}.to_json
  end
end

post '/p/:name/update' do |page_name|
  authorize!
  user_pages = Wnp::Services::UserPages.new(current_user)
  page = user_pages.find_page_with_name page_name
  if page
    page.text = params[:text]
    page.save
    redirect to("/p/#{page.name}")
  else
    error "that page does not exist"
  end
end

get '/page/add' do
  authorize!
  haml :page_add
end

post '/page/add' do
  authorize!
  user_pages = Wnp::Services::UserPages.new(current_user)
  page = user_pages.create_page name:params["name"], text:""
  if page
    redirect to("/p/#{page.name}")
  else
    redirect to("/page/add")
  end
end

def current_user
  if session[:access_token]
    if user = Wnp::Models::User.find_by_index(:access_token,
      session[:access_token])
      return user
    else
      session.delete :access_token
    end
  end
  nil
end

def authorize!
  redirect '/login' unless current_user
end
