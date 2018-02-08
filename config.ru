#\ -p 3000
require './app'
use Rack::Static, :urls => ['/img'], :root => 'public'
run BadSantaServer 
