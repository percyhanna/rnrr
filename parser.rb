require './player_state'
require 'json'

loop do
  code = gets

  break unless code && !code.empty?

  p = PlayerState.parse(code)
  puts JSON.pretty_generate(p.attributes)
  puts p.to_s
end
