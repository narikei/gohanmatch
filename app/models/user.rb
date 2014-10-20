class User < ActiveRecord::Base
  
  include Redis::Objects
  list  :match_user_ids
  set   :friend_ids,      :maxlength => 200

  
  scope :active, lambda{ where(:active => true) }
  
  
  def add_match_user_id(user_id)
    match_user_ids.delete(user_id)
    match_user_ids.unshift(user_id)
  end
  
  def match_users(page, per)
    start = (page - 1) * per
    stop  = start + (per - 1)

    res = []
    user_ids = match_user_ids.range(start, stop)
    users    = User.active.where(:id => user_ids).index_by(&:id)
    res = user_ids.map{|user_id| users[user_id.to_i]}.compact

    Kaminari.paginate_array(res, :total_count => match_user_ids.length).page(page).per(per)
  end
  
end
