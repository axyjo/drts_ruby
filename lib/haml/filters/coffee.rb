require 'coffee-script'
require 'haml'

module Haml::Filters::Coffee
  include Haml::Filters::Base

  def render_with_options(text, options)
    <<END
#{CoffeeScript.compile(text)}
END
  end
end
