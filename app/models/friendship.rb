class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def confirm_friend(user)
    friendship = inverse_friendships.find { |friendshipcheck| friendshipcheck.user == user }
    friendship.status = true
    friendship.save
  end

end
