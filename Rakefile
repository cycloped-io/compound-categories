def get_params
  data = ENV['WIKI_DATA']
  db = ENV['WIKI_DB']
  if data.nil?
    puts "WIKI_DATA has to be set"
    exit
  end
  if db.nil?
    puts "WIKI_DB has to be set"
    exit
  end
  `mkdir -p #{data}/patterns`
  [data,db]
end

desc "Run all tests"
task :test do
  puts `rspec test/spec/pattern_builder.rb`
  puts `rspec test/spec/proper_name_extractor.rb`
  puts `rspec test/spec/proper_name_finder.rb`
end


namespace :pattern do
  desc "Detect proper names in category names"
  task :entities do
    data,db = get_params
    puts `./utils/find_entities_in_category_names.rb -d #{db} -o #{data}/patterns/entities.csv`
  end

  desc "Find eponymy links between categories and articles"
  task :eponymy do
    data,db = get_params
    puts `./utils/export_eponymous_categories.rb -d #{db} -o #{data}/eponymous_from_compound.csv -i #{data}/patterns/entities.csv`
  end

=begin
  desc "Discover patterns in entity matches"
  task :group do
    data,db = get_params
    puts `./utils/discover_patterns.rb -o #{data}/patterns/patterns -f #{data}/patterns/entities.csv`
  end

  desc "Group patterns of order 1"
  task :group do
    data,db = get_params
    puts `./utils/group_matches_by_pattern.rb -o #{data}/patterns/grouped_patterns_1.csv -i #{data}/patterns/patterns_1.csv`
  end

  desc "Match patterns against categories"
  task :match do
    data,db = get_params
    puts `./utils/match_patterns.rb -d #{db} -o #{data}/patterns/matches_1.csv -f #{data}/patterns/grouped_patterns_1.csv`
  end

  desc "Map patterns to categories"
  task :map do
    data,db = get_params
    puts `./utils/match_patterns.rb -d #{db} -o #{data}/patterns/matches_1.csv -f #{data}/patterns/grouped_patterns_1.csv`
  end
=end
end
