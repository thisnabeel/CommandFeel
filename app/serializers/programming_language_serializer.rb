class ProgrammingLanguageSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :editor_slug
end
