require_relative 'simple_framework0'

use Rack::Reloader, 0 
use Rack::Session::Cookie, key: 'rack.session', path: '/', expire_after: 604_800, secret: 'secret1'
run SimpleFramework