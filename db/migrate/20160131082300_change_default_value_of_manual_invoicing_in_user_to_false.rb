class ChangeDefaultValueOfManualInvoicingInUserToFalse < ActiveRecord::Migration
  def change
  	change_column :users, :manual_invoicing, :boolean, :default => false
  end
end
