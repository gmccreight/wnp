# frozen_string_literal: true

class SharingTokenAlreadyExistsException < RuntimeError
end

class PageSharingTokens < Struct.new(:page)
  TOKEN_TYPES = [:readonly, :readwrite].freeze

  def self.find_page_by_token(token)
    TOKEN_TYPES.each do |type|
      page = Page.find_by_index(:"#{type}_sharing_token", token)
      next unless page
      return [page, type] if _get_sharing_token_of_type_is_actived page, type
    end
    [nil, nil]
  end

  def self._get_sharing_token_of_type_is_actived(page, type)
    val = page.send :"#{type}_sharing_token_activated"
    !val.nil?
  end

  def rename_sharing_token(type, new_token)
    return :token_type_does_not_exist unless TOKEN_TYPES.include?(type)
    error = Token.new(new_token).validate
    if error
      return error
    else
      found_page, _token_type = self.class.find_page_by_token(new_token)
      if found_page
        raise SharingTokenAlreadyExistsException if found_page.id != page.id
      end
      page.send :"#{type}_sharing_token=", new_token
      page.save
    end
    nil
  end

  def activate_sharing_token(type)
    _set_activation type, true
  end

  def deactivate_sharing_token(type)
    _set_activation type, false
  end

  private def _set_activation(type, value)
    return :token_type_does_not_exist unless TOKEN_TYPES.include?(type)
    page.send :"#{type}_sharing_token_activated=", value
    page.save
    true
  end
end
