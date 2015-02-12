Gem::Specification.new do |s|
  s.name        = "tree_delta"
  s.version     = "1.0.0"
  s.summary     = "Tree Delta"
  s.description = "Calculates the minimum set of operations that transform one tree into another."
  s.authors     = ["Chris Patuzzo", "Nick Haworth", "Jason Pernthaller"]
  s.email       = ["chris@patuzzo.co.uk", "nick.haworth@which.co.uk", "jason.pernthaller@which.co.uk"]
  s.homepage    = "https://github.com/whichdigital/tree_delta"
  s.files       = ["README.md"] + Dir["lib/**/*.*"]
  s.licenses    = ["MIT"]

  s.add_development_dependency "rake", "~> 10.4"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "pry", "~> 0.10"
  s.add_development_dependency "ascii_tree", "~> 1.0.3"
end
