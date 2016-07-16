class Post < ActiveRecord::Base
  DEFAULT_LIMIT = 5

  acts_as_taggable  # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :categories 

  has_many                :comments, :dependent => :destroy
  has_many                :approved_comments, :class_name => 'Comment'
  belongs_to              :user

  before_validation       :generate_slug
  before_validation       :set_dates
  before_save             :apply_filter

  validates               :title, :slug, :body, :category_list, :presence => true
  validate                :validate_published_at_natural

  searchable do
    text :title, :stored => true
    text :body, :stored => true
  end

  def validate_published_at_natural
    if published_at_natural.present? && !published?
      errors.add("published_at_natural", "Unable to parse time")
    end
  end

  attr_accessor :minor_edit
  def minor_edit
    @minor_edit ||= "1"
  end

  def minor_edit?
    self.minor_edit == "1"
  end

  def published?
    published_at?
  end

  attr_accessor :published_at_natural
  def published_at_natural
    @published_at_natural ||= published_at.send_with_default(:strftime, '', "%Y-%m-%d %H:%M")
  end

  class << self
    def build_for_preview(params)
      post = Post.new(params)
      post.generate_slug
      post.set_dates
      post.apply_filter
      # 预览时无需新建tag
      # post.tag_list.each do |tag|
      #   post.tags << ActsAsTaggableOn::Tag.find_or_create_with_like_by_name(tag)
      # end
      post
    end

    def find_recent(options = {})
      tag = options.delete(:tag)
      category = options.delete(:category)
      # not used 
      # include_tags = options[:include] == :tags
      # include_categories = options[:include] == :categories

      order = 'published_at DESC'
      conditions = ['published_at < ?', Time.zone.now]
      limit = options[:limit] ||= DEFAULT_LIMIT
      page = options[:page] ||= 1

      result = nil
      if tag
        result = Post.tagged_with(tag) # alias tagged_with(tag, :on => tags)
        result = result.where(conditions)
      elsif category
        result = Post.tagged_with(category, :on => :categories)
        result = result.where(conditions)
      else
        result = where(conditions)
      end

      result = result.includes(:tags)
      result = result.includes(:categories) 
      # result.order(order).limit(limit)
      result.order(order).paginate(:page => page, :per_page => limit)

    end



    def find_by_permalink(year, month, day, slug, options = {})
      begin
        day = Time.parse([year, month, day].collect(&:to_i).join("-")).midnight
        result = where(['slug = ?', slug])

        if !options.empty? && options[:include].present?
          result = result.includes(:approved_comments) if options[:include].include?(:approved_comments)
          result = result.includes(:tags) if options[:include].include?(:tags)
        end

        post = result.detect do |one_post|
          [:year, :month, :day].all? {|time|
            one_post.published_at.send(time) == day.send(time)
          }
        end
      rescue ArgumentError # Invalid time
        post = nil
      end
      post || raise(ActiveRecord::RecordNotFound)
    end

    def find_all_grouped_by_month
      posts = where(['published_at < ?', Time.now]).order('published_at DESC')
      month = Struct.new(:date, :posts)
      posts.group_by(&:month).inject([]) {|a, v| a << month.new(v[0], v[1])}
    end
  end

  def destroy_with_undo(user)
    transaction do
      undo = DeletePostUndo.create_undo(self,user)
      self.destroy
      return undo
    end
  end

  def month
    published_at.beginning_of_month
  end

  def apply_filter
    # id 生成方法中采用slug名称，以免多文档时重复
    self.body_html = EnkiFormatter.format_as_xhtml(self.body, {:auto_id_prefix => "#{self.slug}-"})
  end

  def set_dates
    self.edited_at = Time.now if self.edited_at.nil? || !minor_edit?
    unless self.published_at_natural.nil?
      if self.published_at_natural.blank?
        self.published_at = nil
      elsif new_published_at = Chronic.parse(self.published_at_natural)
        self.published_at = new_published_at
      end
    end
  end

  def denormalize_comments_count!
    update_column(:approved_comments_count, self.approved_comments.count)
  end

  def generate_slug
    self.slug = self.title.dup if self.slug.blank?
    self.slug.slugorize!
  end


  def category_list=(value)
    value = value.split(',') if value.is_a?(String)
    # & 符号是特殊字符，分类为支持订阅不允许使用此字符
    value.map!{ |category_name| category_name.gsub!('&', 'and')
      category_name.gsub!(/[^A-Za-z0-9_ \.-]/, '')
      category_name }

    # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
    value = value.join(", ") if value.respond_to?(:join)
    super(value)
  end

  # 下面是用来进行标签过滤，目前不需要过滤
  # def tag_list=(value)
  #   value = value.split(',') if value.is_a?(String)
  #   value.map!{ |tag_name| tag_name.gsub!('&', 'and')
  #     tag_name.gsub!(/[^A-Za-z0-9_ \.-]/, '')
  #     tag_name }

  #   # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
  #   value = value.join(", ") if value.respond_to?(:join)
  #   super(value)
  # end
end
