# frozen_string_literal: true

module Baka
  class Paragraph
    attr_reader :text

    def initialize(text)
      @text = text.strip
    end
  end
end
