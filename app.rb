
require 'bundler/setup'
Bundler.require(:default)
$:.unshift File.dirname(__FILE__)
require 'singleton'
require 'mysql2'
require 'logger'
require 'awesome_print'
require 'app/controllers/application_controller'

Dir.glob('./app/controllers/*.rb').each { |file| require file }
Dir.glob('./lib/**/*.rb').each { |file| require file }

BadSantaServer = Rack::Builder.app do
    use Rack::ShowExceptions
    use Rack::PostBodyContentTypeParser

    ap "Environment: #{(ENV['RACK_ENV'])}"
    map('/') { run BadSantaController }
    map "/img" do
        run Rack::Directory.new("./public/img/")
    end
end

if __FILE__ == $0
  Rack::Handler::WEBrick.run(BadSantaServer)
end
