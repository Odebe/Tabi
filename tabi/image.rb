# frozen_string_literal: true

module Tabi
  class Image
    attr_reader :link, :filename, :file

    def initialize(filename, tempfile = nil)
      @filename = filename
      @file = tempfile
    end

    def to_xml
      "<image l:href=\"\##{@filename}\"/>"
    end

    def to_binary
      "<binary id=\"#{filename}\" content-type=\"image/jpeg\">#{binary_data}</binary>"
    end

    def binary_data
      file
    end
  end
end
