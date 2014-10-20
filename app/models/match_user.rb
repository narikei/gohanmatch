class MatchUser < ActiveRecord::Base
  
  belongs_to :early_user, :class_name => 'User', :foreign_key => 'early_user_id'
  belongs_to :late_user,  :class_name => 'User', :foreign_key => 'late_user_id'
  belongs_to :from_user,  :class_name => 'User', :foreign_key => 'from_user_id'
  belongs_to :to_user,    :class_name => 'User', :foreign_key => 'to_user_id'
  

  after_save :matched, :if => :is_match

  
  def self.match_user_id(user_id)
    from_user_id = self.where(:from_user_id => user_id, :is_match => true).pluck(:to_user_id)
    to_user_id   = self.where(:to_user_id => user_id, :is_match => true).pluck(:from_user_id)
    (from_user_id | to_user_id)
  end

  def self.standed_user_ids(user_id)
    from_user_id = self.where(:from_user_id => user_id).pluck(:to_user_id)
    to_user_id   = self.where(:to_user_id => user_id).pluck(:from_user_id)
    (from_user_id | to_user_id)
  end

  def self.candidacy_user_ids(user_id)
    self.where(:to_user_id => user_id, :is_match => nil).pluck(:from_user_id)
  end
  
  
  def matched
    from_user.add_match_user_id(to_user_id)
    to_user.add_match_user_id(from_user_id)
  end

end
