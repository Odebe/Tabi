# frozen_string_literal: true

module Tabi
  class Paragraph
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def to_xml
      "<p>#{text}</p>"
    end
  end
end
