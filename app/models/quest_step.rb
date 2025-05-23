class QuestStep < ApplicationRecord
  belongs_to :quest
  belongs_to :success_step, class_name: 'QuestStep', optional: true
  belongs_to :failure_step, class_name: 'QuestStep', optional: true
  has_many :quest_step_choices, -> { order(position: :asc) }, dependent: :destroy

  validates :position, presence: true, numericality: { only_integer: true }
  validates :body, presence: true

  def upload_image(file)
    return unless file.present?

    s3 = Aws::S3::Resource.new
    extension = file.original_filename.split('.').last.downcase
    file_name = "image_#{Time.now.to_i}.#{extension}"
    obj = s3.bucket('commandfeel').object("quest_steps/#{self.id}/#{file_name}")
    
    puts "Uploading file #{file_name}"
    obj.upload_file(file.tempfile.path, acl: 'public-read')
    
    self.update(image_url: obj.public_url)
    self
  end

  def upload_images(params)
    if params[:image].present?
      self.update(image_url: upload_to_s3("image", params[:image]))
    end
    
    if params[:thumbnail].present?
      self.update(thumbnail_url: upload_to_s3("thumbnail", params[:thumbnail]))
    end
    
    self
  end

  private

  def upload_to_s3(type, file)
    s3 = Aws::S3::Resource.new
    file_name = "#{type}_#{Time.now.to_i}.#{file.original_filename.split('.').last}"
    obj = s3.bucket('commandfeel').object("quest_steps/#{self.id}/#{type}/#{file_name}")
    
    puts "Uploading file #{file_name}"
    obj.upload_file(file.tempfile.path, acl: 'public-read')
    obj.public_url
  end
end 