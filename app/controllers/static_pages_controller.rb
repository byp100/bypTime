class StaticPagesController < ApplicationController
  skip_before_filter :set_organization_as_tenant

  def select_chapter
    @chapters = Organization.all
  end

  def chapter
    chapter = Organization.find params[:organization][:chapter]
    redirect_to root_url(subdomain: chapter.slug)
  end
end