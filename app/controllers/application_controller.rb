class ApplicationController < Sinatra::Base
   # before do
   #     puts request.env.inspect
   #     puts request.env.get_header("Authorization").to_s
   #     puts request.header("Authorization")
   #     token = headers['Authorization'].split('=')[1]
   #     if token == "secretpass"
   #         puts "AUTHED!"
   #     else
   #         puts "YOU ARE NOT ALLOWED HERE!"
   #     end
   # end
end
