require 'wnp/token'

module Wnp::Services

  class ObjectTags < Struct.new(:object)

    def add_tag name
      if error = Wnp::Token.new(name).validate
        return false
      end
      
      return false if has_tag_with_name?(name)

      tag = Wnp::Models::Tag.find_by_index(:name, name) ||
        Wnp::Models::Tag.create(name:name)

      tag.add_associated_object object
      tag.save
      object.add_tag tag.id
    end

    def remove_tag name
      if error = Wnp::Token.new(name).validate
        return false
      end

      if tag = tag_with_name(name)
        tag.remove_associated_object object
        tag.save
        object.remove_tag tag.id
      end
    end

    def has_tag_with_name? name
      !! tag_with_name(name)
    end

    def tag_with_name name
      tags_with_name = get_tags.select{|tag| tag.name == name}
      if tags_with_name.size > 0
        return tags_with_name.first
      else
        return nil
      end
    end

    def get_tags
      return [] if ! object.tag_ids
      object.tag_ids().map{|x| tag = Wnp::Models::Tag.find(x); tag}
    end

    def sorted_tag_names
      get_tags().map{|tag| tag.name}.sort
    end

  end

end
