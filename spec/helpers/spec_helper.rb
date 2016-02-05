require 'rspec'
require_relative 'helpers'

class SpecHelper
  RSpec.configure do |c|
    c.include Helpers
  end
end
