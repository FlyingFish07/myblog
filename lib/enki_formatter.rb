class EnkiFormatter
  class << self
    def format_as_xhtml(text, options = nil)
        all_options = {:syntax_highlighter=>'rouge'}
        all_options.merge! options unless options.nil?
        Kramdown::Document.new(text,all_options).to_html
    #  Lesstile.format_as_xhtml(
    #    text,
    #    :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(text)).to_html},
    #    :code_formatter => Lesstile::CodeRayFormatter
    #  )
    end
  end
end
