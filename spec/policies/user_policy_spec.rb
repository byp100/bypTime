require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class }

  permissions :show?, :edit?, :update?, :destroy? do
    it 'denies access if user is not an admin or not logged in' do
      user = create :user
      expect(subject).not_to permit(user)
    end

    it 'permits access if user logged in' do
      user = create :user
      current_user = user
      expect(subject).to permit(current_user, user)
    end

    it 'permits access if user is admin' do
      user = create :user, :admin
      expect(subject).to permit(user)
    end
  end

  permissions :create?, :index?, :new? do
    it 'denies access if user is not an admin (even if logged in)' do
      user = create :user
      current_user = user
      expect(subject).not_to permit(user)
      expect(subject).not_to permit(current_user, user)
    end

    it 'permits access if user is admin' do
      user = create :user, :admin
      expect(subject).to permit(user)
    end
  end
end
