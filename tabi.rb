# frozen_string_literal: true

require 'yaml'

$config = YAML.load(File.read('config.yml'))

require 'nokogiri'
require 'open-uri'
require 'uri'
require "base64"

require "mini_magick" if $config['images'] && $config['compress_images']

%w[tabi baka].each do |gem_name|
  Dir[__dir__+"/#{gem_name}/*.rb"].each{ |file| require file }
end

parser = Baka::Parser.new($config['link'])
book = Tabi::Book.new(parser.main_title)

parser.chapters.each do |chapter|
  chapter_section = Tabi::Section.new(chapter.title)
  
  if $config['images'] == true
    chapter.images.each do |image|
      chapter_section.add_image!(image)
    end
  end

  chapter.paragraphs.each do |par|
    chapter_section.add_par!(par.text)
  end
  
  book.add_section!(chapter_section)
end

# TODO: change later
filename = $config['filename'] || "#{parser.main_title.split(' ').join('_').gsub(':','_')}_images.fb2"
File.open(filename, 'w').write(book.to_xml)


