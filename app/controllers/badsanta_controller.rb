class BadSantaController < ApplicationController
    get '/' do
        status 400
    end

    post '/register_server' do 
        content_type :json
        b = BadSanta.new
        status 200
        return b.register_server(params["name"], params["hostname"]).to_json
    end

    post '/update_db' do
        content_type :json
        b = BadSanta.new
        status 200
        return b.update_db(params).to_json
    end

    get '/servers' do 
        content_type :json
        b = BadSanta.new
        status 200
        return b.servers.to_json
    end

    get '/toplist' do 
        content_type :json
        b = BadSanta.new
        status 200
        return b.toplist.to_json
    end

    get '/auth_user/:id' do
        content_type :json
        b = BadSanta.new
        status 200
        return b.auth_user(params["id"]).to_json
    end

    post '/login' do 
        content_type :json
        b = BadSanta.new
        status 200
        return b.login(params["user"], params["pass"]).to_json
    end
end
