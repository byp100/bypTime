class AddAasmStateToMember < ActiveRecord::Migration
  def change
    add_column :members, :aasm_state, :string
  end
end
