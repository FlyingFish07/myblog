class Comment < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  attr_accessor         :openid_error
  attr_accessor         :openid_valid

  belongs_to            :post

  before_save           :apply_filter
  after_save            :denormalize
  after_destroy         :denormalize

  validates             :author, :body, :post, :presence => true
  validate :open_id_error_should_be_blank

  validates   :author_email, format:{
                        with: /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
                      }
  validates   :author_url, format: {
                        with: /[a-zA-z]+:\/\/[^\s]*/
                      } , unless: "author_url.blank?"

  def open_id_error_should_be_blank
    errors.add(:base, openid_error) unless openid_error.blank?
  end

  def apply_filter
    #self.body_html = Lesstile.format_as_xhtml(self.body, :code_formatter => Lesstile::CodeRayFormatter)
    self.body_html = Lesstile.format_as_xhtml(self.body, :code_formatter => lambda { |code, lang| 
        logger.info "code:#{code},lang:#{lang}"
        lang = :plaintext if lang.nil?
        code = CGI::unescapeHTML(code)
        Rouge.highlight(code,lang,'html')
     })
  end

  def blank_openid_fields
    self.author_url = "" if self.author_url.nil?
    # TODO support openid
    # self.author_email = "" if self.author_email.nil?
  end

  def requires_openid_authentication?
    return false unless author

    !!(author =~ %r{^https?://} || author =~ /\w+\.\w+/)
  end

  def trusted_user?
    false
  end

  def user_logged_in?
    false
  end

  def approved?
    true
  end

  def denormalize
    self.post.denormalize_comments_count!
  end

  def destroy_with_undo
    undo_item = nil
    transaction do
      self.destroy
      undo_item = DeleteCommentUndo.create_undo(self)
    end
    undo_item
  end

  # Delegates
  def post_title
    post.title
  end

  class << self
    def protected_attribute?(attribute)
      [:author, :author_url,:author_email, :body].include?(attribute.to_sym)
    end

    def new_with_filter(params)
      comment = Comment.new(params)
      comment.created_at = Time.now
      comment.apply_filter
      comment
    end

    def build_for_preview(params)
      comment = Comment.new_with_filter(params)
      if comment.requires_openid_authentication?
        comment.author_url = comment.author
        comment.author     = "Your OpenID Name"
      end
      comment
    end

    def find_recent(options = {})
      limit = options[:limit] ||= DEFAULT_LIMIT
      all.order('created_at DESC').limit(limit)
    end
  end
end
