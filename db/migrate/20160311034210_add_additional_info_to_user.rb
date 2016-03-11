class AddAdditionalInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :additional_info, :jsonb, default: {}
  end
end
