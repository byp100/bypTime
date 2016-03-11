class AddAdditionalInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :additional_info, :json, default: {}
  end
end
