Gem::Specification.new do |s|
  s.name = "cyclopedio-compound"
  s.version = "0.1.0"
  s.date = "#{Time.now.strftime("%Y-%m-%d")}"
  s.required_ruby_version = '>= 2.0.0'
  s.authors = ['Aleksander Smywiński-Pohl']
  s.email   = ["apohllo@o2.pl"]
  s.summary = "Processing of Wikipedia compound categories"
  s.description = "This gem is used to extract various data from compound (relational) Wikipedia categories"

  s.rubyforge_project = "cyclpedio-compound"
  s.rdoc_options = ["--main", "Readme.md"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path = "lib"

  s.add_dependency("rod", [">= 0.7.4.1","< 0.7.5.0"])
  s.add_dependency("rod-rest")
  s.add_dependency("slop", [">= 3.6.0","< 4.0.0"])
  s.add_dependency("colors")
  s.add_dependency("htmlentities")
  s.add_dependency("progress")
  s.add_dependency("rdf")

  s.add_development_dependency("rspec")
  s.add_development_dependency("rake")
  s.add_development_dependency("rr", '~> 1.1.2')
end
