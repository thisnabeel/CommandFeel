class LanguageAlgorithmStarterSerializer < ActiveModel::Serializer
  attributes :id, :programming_language_id, :algorithm_id, :code, :code_lines, :video_url

  def language
    object.programming_language
  end

  def algorithm
    object.algorithm
  end
end
