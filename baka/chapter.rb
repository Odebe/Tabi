# frozen_string_literal: true

module Baka
  class Chapter
    attr_reader :paragraphs, :images, :title

    def initialize(title)
      raise ArgumentError if title.nil?
      @title = title
      @paragraphs = []
      @images = []
    end

    def add_image!(link, data)
      File.open('file', 'w').write(data.to_s)
      puts data.class
      @images << Baka::Image.new(link, data)
    end

    def add_par!(text)
      @paragraphs << Baka::Paragraph.new(text)
    end
  end
end