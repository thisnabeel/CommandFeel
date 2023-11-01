class LanguageAlgorithmStarterSerializer < ActiveModel::Serializer
  attributes :id, :test_cases, :programming_language_id, :algorithm_id, :code, :code_lines, :video_url, :algorithm

  def language
    object.programming_language
  end

  def algorithm
    object.algorithm
  end

  def test_cases
    object.test_cases.order("created_at ASC")
  end
  
end
