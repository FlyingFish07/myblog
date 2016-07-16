class Pubimage < ActiveRecord::Base
  mount_uploader :pimage, PubimageUploader

  belongs_to :user

  # 原始文件名保存在name中，设置在PubfileUploader中设置
  validates  :name, :pimage, :presence => true
  validates :name, uniqueness: { scope: :user_id }

end
