Gem::Specification.new do |s|
  s.name        = "tree_delta"
  s.version     = "1.0.0"
  s.summary     = "Tree Delta"
  s.description = "Calculates the minimum set of operations that transform one tree into another."
  s.authors     = ["Chris Patuzzo", "Jason Pernthaller"]
  s.email       = ["chris@patuzzo.co.uk", "jason.pernthaller@which.co.uk"]
  s.homepage    = "https://github.com/whichdigital/tree_delta"
  s.files       = ["README.md"] + Dir["lib/**/*.*"]

  s.add_development_dependency "rspec"
end
