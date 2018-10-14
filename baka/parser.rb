# frozen_string_literal: true

module Baka
  class Parser
    # attr_reader :chapters

    CONTENT_CSS_SELECTOR = 'div.mw-content-ltr'

    def initialize(link)
      raise ArgumentError if link.nil?
      @host = URI(link).host
      @link = link
      @chapters = []
    end

    def cover
      @_cover ||= 
        if @images.nil?
          cover_link = page.css('a.image').first['href']
          Baka::Image.new(cover_link, get_image(cover_link))
        else
          images.first
        end
    end

    def images!
      @images = chapters.flat_map(&:images)
    end

    def images
      @images ||= chapters.flat_map(&:images)
    end

    def images_links
      @_images_link ||= page.css('a.image').map { |link| link['href'] }
    end

    def main_title
      page.css('h1#firstHeading').text
    end

    def chapters
      @_chapters ||= separate_chapters
    end

    def content
      @_content ||= page.css(CONTENT_CSS_SELECTOR)
    end

    def page
      @_page ||= Nokogiri::HTML(open(@link) { |io| io.read })
    end

    private

    def separate_chapters
      objs = content.children
      h_ids = objs.map.with_index { |e, i| e.name == 'h2' ? i : nil }.compact

      h_ids.each_cons(2).each_with_object([]) do |h_id, result|
        chap_title = objs[h_id[0]].css('span.mw-headline').first.text
        puts "chapter: #{chap_title}"
        chapter = Baka::Chapter.new(chap_title)

        chapter_objs = objs[(h_id[0]+1)...h_id[1]]

        paragraphs = chapter_objs.select { |e| e.name = 'p' }
        paragraphs.each { |par| chapter.add_par!(par.text) }

        if $config['images'] == true
          chapter_objs.css('a.image').each do |link|
            chapter.add_image!(link['href'], get_image(link['href']))
          end
        end

        result << chapter
      end
    end

    def get_image(link)
      full_image_link = open_page(link).css('div.fullImageLink a')[0]['href']
      file = open_link(full_image_link)
      res_file = $config['images'] && $config['compress_images'] ? process_file(file) : file
      Base64.encode64(res_file)
    end

    def process_file(file)
      image = MiniMagick::Image.read(file)
      image.resize "600x"
      tmp_file = Tempfile.new('tmp')
      image.write(tmp_file.path)
      result = tmp_file.read
      tmp_file.close!
      image.destroy!
      result
    end

    def full_link(path)
      "https://" + @host + path
    end

    def open_link(link)
      link = full_link(link)
      puts "reading #{link}"
      open(link) { |io| io.read }
    end

    def open_page(link)
      Nokogiri::HTML(open_link(link))
    end
  end
end
