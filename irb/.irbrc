begin
  # load wirble
  require 'wirble'

  # start wirble (with color)
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end


#require 'rubygems'
#require 'wirble'
#
## custom colors hash
#colors = wirble::colorize.colors.merge({
#  :object_class   => :black,
#  :class          => :dark_gray,
#  :symbol         => :red,
#  :symbol_prefix  => :blue,
#})
#wirble::Colorize.colors = colors # apply colors
#
## go colors
#wirble.init
#wirble.colorize
