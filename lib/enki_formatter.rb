class EnkiFormatter
  class << self
    def format_as_xhtml(text)
        Kramdown::Document.new(text,:syntax_highlighter=>'rouge').to_html
    #  Lesstile.format_as_xhtml(
    #    text,
    #    :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(text)).to_html},
    #    :code_formatter => Lesstile::CodeRayFormatter
    #  )
    end
  end
end
