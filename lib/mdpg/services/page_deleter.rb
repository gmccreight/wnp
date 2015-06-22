class PageDeleter
  def initialize(user, page)
    @user = user
    @page = page
  end

  def run
    ensure_not_being_referred_to

    remove_referrals
    remove_tags
    remove_page_from_user
    virtually_delete_the_page
  end

  private def ensure_not_being_referred_to
    if @page.referring_page_ids && @page.referring_page_ids.size > 0
      fail PageCannotBeDeletedBecauseItHasReferringPages
    end
  end

  private def remove_referrals
    if @page.refers_to_page_ids && @page.refers_to_page_ids.size > 0
      @page.refers_to_page_ids.each do |page_id_referred_to|
        PageReferrersUpdater.new.remove_page_id_from_referrers(
          @page.id, Page.find(page_id_referred_to)
        )
      end
    end
  end

  private def remove_tags
    user_page_tags = UserPageTags.new(@user, @page)
    user_page_tags.remove_all
  end

  private def remove_page_from_user
    @user.remove_page(@page)
  end

  private def virtually_delete_the_page
    @page.virtual_delete
  end
end