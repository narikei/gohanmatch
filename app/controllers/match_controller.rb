class MatchController < ApplicationController
  
  before_filter :login_with_all
  
  def index
  end
  
  def next
    # candidacy user
    candidacy_user_ids = MatchUser.candidacy_user_ids(login_user_id)
    @users = User.active.where("id IN (?)", candidacy_user_ids).limit(10).shuffle
    
    # initial user
    unless(@users.present?)
      to_user_ids = MatchUser.standed_user_ids(login_user_id)
      to_user_ids << login_user_id
#       @users = User.active.where("id NOT IN (?)", to_user_ids).shuffle[0..10]
      @users = User.active.where(:id => login_user.friend_ids.to_a).where("id NOT IN (?)", to_user_ids).shuffle[0..10]
    end
    
    render :json => @users
  end
  
  def yep
    early_user_id = params[:candidacy_user_id]
    late_user_id  = login_user_id
    if(params[:candidacy_user_id].to_i > login_user_id)
      early_user_id = login_user_id
      late_user_id  = params[:candidacy_user_id]
    end
    
    
    match_user = MatchUser.where(:early_user_id => early_user_id, :late_user_id => late_user_id).first_or_initialize
    if match_user.id
      if match_user.to_user_id == login_user_id
        match_user.is_match = true
        if match_user.save
          render :json => {:status => true}
        else
          render :json => {:status => false}
        end
  
        return
      end
    end
    
    
    match_user.from_user_id = login_user_id
    match_user.to_user_id = params[:candidacy_user_id]
    match_user.save
    
    render :json => {:status => true}
  end
  
  def nope
    early_user_id = params[:candidacy_user_id]
    late_user_id  = login_user_id
    if(params[:candidacy_user_id].to_i > login_user_id)
      early_user_id = login_user_id
      late_user_id  = params[:candidacy_user_id]
    end
    
    
    match_user = MatchUser.where(:early_user_id => early_user_id, :late_user_id => late_user_id).first_or_initialize
    unless match_user.id
      match_user.from_user_id = login_user_id
      match_user.to_user_id = params[:candidacy_user_id]
    end
    match_user.is_match = false
    match_user.save

    if match_user.save
        render :json => {:status => true}
      else
        render :json => {:status => false}
    end
  end
  
  def new_match
    login_user.match_user_ids
    render :json => login_user.match_user_ids
  end

end
