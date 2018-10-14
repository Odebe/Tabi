# frozen_string_literal: true

module Baka
  class Image
    attr_reader :link, :filename, :data

    def initialize(link, data)
      @link = link
      @filename = filename_from_link
      puts "link: #{@link}, filename: #{@filename}"
      @data = data
    end

    private

    def filename_from_link
      query = URI(@link).query
      query_hash = Hash[URI.decode_www_form(query)]
      query_hash['title'].split(':').last
    end
  end
end
