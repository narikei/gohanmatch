class Chat < ActiveRecord::Base

  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :early_user, :class_name => 'User', :foreign_key => 'early_user_id'
  belongs_to :late_user,  :class_name => 'User', :foreign_key => 'late_user_id'

  validates :content, :presence  => true

  before_validation { |model| model.content.strip! }

end
