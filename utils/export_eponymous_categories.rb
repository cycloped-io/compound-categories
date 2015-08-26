#!/usr/bin/env ruby
# encoding: utf-8

require 'bundler/setup'
require 'slop'
require 'csv'
require 'colors'
require 'progress'
require 'cyclopedio/wiki'
require 'wiktionary/noun'

options = Slop.new do
  banner "#{$PROGRAM_NAME} -i articles_in_categories.csv -o eponymous_categries.csv -d database\n" +
    "Export eponymous categories from article names found in category names."

  on :i=, :input, "Input file with entity matches (CSV)", required: true
  on :o=, :output, "Output file with eponymous categories (CSV)", required: true
  on :d=, :database, "ROD database", required: true
end

begin
  options.parse
rescue => ex
  puts ex
  puts options
  exit
end

include Rlp::Wiki
Database.instance.open_database(options[:database])
at_exit do
  Database.instance.close_database
end

potential_count = 0
exported_count = 0
nouns = Wiktionary::Noun.new
CSV.open(options[:output],"w:utf-8") do |output|
  CSV.open(options[:input],"r:utf-8") do |input|
    input.with_progress do |row|
      begin
        category_id,category_name,*tuples = row
        tuples.each_slice(3) do |prefix,article_name,suffix|
          next unless prefix.empty? && suffix.empty?
          category = Category.find_by_wiki_id(category_id.to_i)
          article = Article.find_all_by_name(article_name).to_a.compact.first
          next unless category.eponymous_articles.empty?
          next if category.nil? || article.nil?
          potential_count += 1
          #intersection = category.parents.to_a & article.categories.to_a
          intersection = []
          if category_name == article_name
            output << [category_id,category_name,article.wiki_id,article_name]
            exported_count += 1
            next
            #category_name = category_name.hl(:purple)
            #article_name = article_name.hl(:purple)
          elsif category_name.match(/#{Regexp.escape(article_name)}/i)
            if $`.empty? && nouns.singularize(category_name) == article_name
              output << [category_id,category_name,article.wiki_id,article_name]
              exported_count += 1
              next
            end
            #category_name = $`.hl(:yellow) + article_name + $'.hl(:green)
          elsif article_name.match(/#{Regexp.escape(category_name)}/i)
            if $'.empty?
              output << [category_id,category_name,article.wiki_id,article_name]
              exported_count += 1
              next
            end
            #article_name = $`.hl(:yellow) + category_name + $'.hl(:blue)
          else
            first_index = category_name.split("").zip(article_name.split("")).each.with_index do |(category_char,article_char),index|
              break(index) if category_char != article_char
            end
            if first_index && first_index > 0
              if category_name =~ /people$/
                output << [category_id,category_name,article.wiki_id,article_name]
                exported_count += 1
                next
              elsif nouns.singularize(category_name) == article_name
                output << [category_id,category_name,article.wiki_id,article_name]
                exported_count += 1
                next
              elsif article_name[0...first_index].pluralize + article_name[first_index..-1] == category_name
                output << [category_id,category_name,article.wiki_id,article_name]
                exported_count += 1
                next
              end
              #category_name = category_name[0...first_index] + category_name[first_index..-1].hl(:green)
              #article_name = article_name[0...first_index] + article_name[first_index..-1].hl(:blue)
            end
          end

          #puts "#{category_name},#{article_name},#{intersection.size}"
        end
      rescue Interrupt
        puts
        break
      rescue Exception => ex
        puts row.join(",").hl(:red)
        puts ex
        puts ex.backtrace[0..3]
      end
    end
  end
end
puts "Exported links/potential links #{exported_count}/#{potential_count}"
