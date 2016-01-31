class AddManualInvoicingToUser < ActiveRecord::Migration
  def change
    add_column :users, :manual_invoicing, :boolean
  end
end
