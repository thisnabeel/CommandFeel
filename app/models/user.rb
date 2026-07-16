class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # acts_as_token_authenticatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]
  has_many :attempts
  has_many :user_quiz_statuses
  has_many :saved_jobs
  has_many :proofs
  has_many :proof_links
  has_many :projects
  has_many :cohort_users
  has_many :cohorts, through: :cohort_users
  has_many :occupation_skill_user_notes, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :question_comments, dependent: :destroy
  has_many :occupation_skill_evidences, dependent: :destroy

  validates :first_name, :last_name, presence: true, on: :create
  validates :first_name, :last_name, presence: true, if: :validating_name_fields?

  def name_complete?
    first_name.present? && last_name.present?
  end

  def display_first_name
    return first_name.strip if first_name.present?

    token = (username.presence || email.to_s.split('@').first).to_s.split(/[\s._-]+/).first
    token.present? ? token.capitalize : 'there'
  end

  def generate_temporary_authentication_token
    # self.authentication_token = Devise.friendly_token
    token = Devise.friendly_token
    tokens = (self.tokens || []).push(token)
    begin
      self.update(tokens: tokens)
    rescue => exception
      puts exception
    end
    return token
  end

  def clear_temporary_authentication_token
    self.authentication_token = nil
    self.save
  end

  def admin?
  	array = ["farhanmshaikh@hotmail.com", "rockystorm@gmail.com"]
  	bool = false
  	array.each do |a|
	  	if self.email.include? a
	  		return true
	  	else
	  	end
  	end
  	return bool
  end

  def User.is_admin? (user)
    if !user.present?
      bool = false
    else
      array = ["farhanmshaikh@hotmail.com", "rockystorm@gmail.com"]
      bool = false
      array.each do |a|
        if user.email.include? a
          return true
        else
        end
      end
    end
    return bool
  end


  def login
    @login || self.username || self.email
  end

  # Avatar
  def upload_avatar(params)
    # require 'aws-sdk'

    user = self
    avatar_original = params[:avatar_original]
    avatar_cropped = params[:avatar_cropped]

    # return avatar_cropped
    # user.update(avatar_original_url: upload_aws(user, "original", avatar_cropped))
    if avatar_original.present?
      user.update(avatar_source_url: upload_aws(user, "original", avatar_original))
    end
    user.update(avatar_cropped_url: upload_aws(user, "cropped", avatar_cropped))
    return user
  end

  def upload_aws(user, key, file)
    s3 = Aws::S3::Resource.new
    file_name = key + ".jpeg"
    obj = s3.bucket('commandfeel').object("users/#{user.id}/avatar/#{key}/#{file_name}")
    puts "Uploading file #{file_name}"
    obj.upload_file(file, acl:'public-read')
    return obj.public_url
  end

  def delete_note
    require 'aws-sdk'

    title = params[:title]
    word_type = params[:type]
    id = params[:id]
    url = params[:url]
    word = word_type.constantize.find(id)

    key = url.split("amazonaws.com/")[1]
    puts key

    s3 = Aws::S3::Resource.new

    # reference an existing bucket by name
    bucket = s3.bucket('commandfeel')
    # bucket.objects.each do |obj|
    #   puts "#{obj.key} => #{obj.etag}"
    # end

    # single object operations
    obj = bucket.object(key)
    puts obj.exists?
    if obj.delete
      puts "deleted!"
      hash = word.recordings
      hash.delete(title)
      word.update(recordings: hash)
    end

    render json: {
      status: 200,
      message: "Destroyed!",
    }.to_json

    rescue => e
      Rails.logger.error "Failure with S3 call. Details: #{e}; #{e.backtrace}"
      return false
  end

  private

  def validating_name_fields?
    will_save_change_to_first_name? || will_save_change_to_last_name?
  end
end
