require "rspec"
require "pry"
require "ascii_tree"
require "tree_delta"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.color = true
  config.formatter = :documentation
end

class AsciiTree::Node
  alias :identity :id
end
