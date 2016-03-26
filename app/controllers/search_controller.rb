class SearchController < ApplicationController
  def show
    @keyword = params[:q]
    @search = Post.search do 
      fulltext params[:q] do
        highlight :body , :fragment_size => 200
        highlight :title
      end
      paginate :page => params[:page], :per_page => 10
    end #search keyword a
    # puts @search.total  #results count
    #results = search.results # results
    @all_hits = []
    @search.each_hit_with_result do |hit, result|
      one_hit = {}
      one_hit[:result] =  result
      if hit.highlights(:title).first.nil?
        one_hit[:hl_title] = result.title
      else
        hl_title = hit.highlights(:title).first.format { |word| "<span class=\"search-highlight\">#{word}</span>" } 
        one_hit[:hl_title] = hl_title.html_safe
      end
      if hit.highlights(:body).first.nil?
        one_hit[:hl_body] = result.body[0,200] 
      else
        hl_body = hit.highlights(:body).first.format { |word| "<span class=\"search-highlight\">#{word}</span>" } 
        one_hit[:hl_body] = hl_body.html_safe
      end 
      @all_hits << one_hit
      puts one_hit
    end
  end
end
