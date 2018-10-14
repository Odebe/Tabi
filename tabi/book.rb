# frozen_string_literal: true

module Tabi
  class Book
    attr_reader :title

    def initialize(title)
      raise ArgumentError if title.nil?
      @title = title
      @sections = []
    end

    def add_section!(section)
      @sections << section
    end

    def xml_header
      '<?xml version="1.0" encoding="UTF-8"?>'
    end

    def to_xml
      "#{xml_header}#{open_tag}#{xml_description}#{body_xml}#{binary_data}#{close_tag}"
    end

    def open_tag
      '<FictionBook xmlns="http://www.gribuser.ru/xml/fictionbook/2.0" xmlns:l="http://www.w3.org/1999/xlink">'
    end

    def close_tag
      '</FictionBook>'
    end

    def xml_description
      %(<description>
          <title-info>
            <book-title>#{title}</book-title>
            <coverpage>#{cover_image_xml}</coverpage>
          </title-info>
        </description>)
    end

    def cover_image_xml
      if cover = @sections.first.images.first
        cover.to_xml
      else
        ''
      end
    end

    def binary_data
      @sections.any?(&:has_binary_data?) ? @sections.map(&:binary_data).join('') : ''
    end

    def body_xml
      "<body>#{xml_title}#{xml_sections}</body>"
    end

    def xml_sections
      @sections.map(&:to_xml).join('')
    end

    def xml_title
      "<title><p>#{title}</p></title>"
    end
  end
end