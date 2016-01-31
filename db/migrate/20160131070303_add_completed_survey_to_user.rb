class AddCompletedSurveyToUser < ActiveRecord::Migration
  def change
    add_column :users, :completed_survey, :boolean
  end
end
