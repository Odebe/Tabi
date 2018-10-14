# frozen_string_literal: true

module Tabi
  class Section
    attr_reader :title, :images

    def initialize(title)
      @title = title
      @sections = []
      @pars = []
      @images = []
    end

    def add_image!(image)
      @images << Tabi::Image.new(image.filename, image.data)
    end

    def add_par!(text)
      @pars << Tabi::Paragraph.new(text)
    end

    def has_binary_data?
      @images.any?
    end

    def binary_data
      @images.map(&:to_binary).join('')
    end

    def to_xml
      "<section>#{xml_title}#{xml_images}#{xml_paragraphs}</section>"
    end

    def xml_title
      title.nil? ? '' : "<title><p>#{title}</p></title>"
    end

    def xml_images
      @images.empty? ? '' : @images.map(&:to_xml).join('')
    end

    def xml_paragraphs
      @pars.empty? ? '' : @pars.map(&:to_xml).join('')
    end
  end
end