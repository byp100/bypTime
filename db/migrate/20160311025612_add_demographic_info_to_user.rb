class AddDemographicInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :demographic_info, :json, default: {}
  end
end
