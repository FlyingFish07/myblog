module PostsHelper
  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  # 参考actionview-4.2.4/lib/action_view/helpers/atom_feed_helper.rb进行了重写，以支持分页
  # ATOM分页设置参考: http://www.ibm.com/developerworks/library/x-tipatom2/
  # 分页可在options中设置:total_pages,:current_page，两个属性必须同时存在
  # 功能已实现，但决定不使用，因为很多reader不支持此功能
  # 使用方法如下
  # atom_feed_with_pagination(
  #   :url         => url,
  #   :root_url    => posts_url,
  #   :schema_date => '2008',
  #   :total_pages => @posts.total_pages,
  #   :current_page => @posts.current_page.to_i # current_page类型是WillPaginate::PageNumber,故作转化
  # ) do |feed|
  def atom_feed_with_pagination(options = {}, &block)
    if options[:schema_date]
      options[:schema_date] = options[:schema_date].strftime("%Y-%m-%d") if options[:schema_date].respond_to?(:strftime)
    else
      options[:schema_date] = "2005" # The Atom spec copyright date
    end

    xml = options.delete(:xml) || eval("xml", block.binding)
    xml.instruct!
    if options[:instruct]
      options[:instruct].each do |target,attrs|
        if attrs.respond_to?(:keys)
          xml.instruct!(target, attrs)
        elsif attrs.respond_to?(:each)
          attrs.each { |attr_group| xml.instruct!(target, attr_group) }
        end
      end
    end

    #提取出自定义的分页属性
    total_pages = options.delete(:total_pages)
    current_page = options.delete(:current_page)

    feed_opts = {"xml:lang" => options[:language] || "en-US", "xmlns" => 'http://www.w3.org/2005/Atom'}
    feed_opts.merge!(options).reject!{|k,v| !k.to_s.match(/^xml/)}

    xml.feed(feed_opts) do
      xml.id(options[:id] || "tag:#{request.host},#{options[:schema_date]}:#{request.fullpath.split(".")[0]}")
      xml.link(:rel => 'alternate', :type => 'text/html', :href => options[:root_url] || (request.protocol + request.host_with_port))

      #增加分页处理
      if total_pages.nil? || current_page.nil?
        # 不分页，原始逻辑
        xml.link(:rel => 'self', :type => 'application/atom+xml', :href => options[:url] || request.url)
      else
        append_page_info(xml,total_pages, current_page, options[:url] || request.url)
      end

      yield ActionView::Helpers::AtomFeedHelper::AtomFeedBuilder.new(xml, self, options)
    end
  end

  private
  # 向xml中追加分页信息
  def append_page_info(xml, total_pages, current_page, url)
    self_url = current_page == 1 ? url : add_param_to_url(url, "page", current_page)

    xml.link(:rel => 'self', :type => 'application/atom+xml', :href => self_url)
    xml.link(:rel => 'first', :href => url)
    if current_page > 1
      xml.link(:rel => 'previous', :href => add_param_to_url(url, "page", current_page - 1))
    end

    if current_page < total_pages
      xml.link(:rel => 'next', :href => add_param_to_url(url, "page", current_page + 1))
    end
    xml.link(:rel => 'last', :href => add_param_to_url(url, "page", total_pages))
  end

  # 向url中增加参数对
  def add_param_to_url(url, key, value)
    uri = URI.parse(url)
    if uri.query.nil?
      uri.query = URI.encode_www_form([[key, value.to_s]]) #注意这里是二维数组
    else
      new_query_ar = URI.decode_www_form(uri.query) << [key, value.to_s]
      uri.query = URI.encode_www_form(new_query_ar)
    end 
    uri.to_s
  end

end