class StaticPagesController < ApplicationController
  skip_before_filter :set_organization_as_tenant
  def home
  end
end