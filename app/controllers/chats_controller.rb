class ChatsController < ApplicationController

  before_filter :login_with_all
  
  def index
#     @match_users = MatchUser.includes(:to_user, :from_user).where("from_user_id = ? OR to_user_id = ?", login_user_id, login_user_id).where(:is_match => true).order(:updated_at).reverse_order.page(1)
    @match_users = MatchUser.includes(:to_user, :from_user).where("from_user_id = ? OR to_user_id = ?", login_user_id, login_user_id).where(:is_match => true).order(:updated_at).reverse_order.limit(100)
  end
  
  def show
    early_user_id = params[:id].to_i
    late_user_id  = login_user_id
    if(params[:id].to_i > login_user_id)
      early_user_id = login_user_id
      late_user_id  = params[:id]
    end
    
    match_user = MatchUser.where(:early_user_id => early_user_id, :late_user_id => late_user_id, :is_match => true).first
    unless match_user
      render :status => 403, :json => {:status => false}
      return
    end
    
    if match_user.from_user_id == login_user_id
      @user = match_user.to_user
    else
      @user = match_user.from_user
    end
    
    login_user.match_user_ids.delete(@user.id)
    
    @chats = Chat.includes(:early_user, :late_user).where(:early_user_id => early_user_id, :late_user_id => late_user_id).order(:id).reverse_order.page(1)
    @chats = @chats.reverse    
    
    @chat = Chat.new
    @chat.early_user_id = early_user_id
    @chat.late_user_id  = late_user_id
  end
  
  def create
    early_user_id = params[:chat][:early_user_id].to_i
    late_user_id  = params[:chat][:late_user_id].to_i
    
    if early_user_id != login_user_id && late_user_id != login_user_id
      render :status => 403, :json => {:status => false}
      return
    end
    
    to_user_id = early_user_id
    if late_user_id != login_user_id
      to_user_id = late_user_id
    end
    
    match_user = MatchUser.where(:early_user_id => early_user_id, :late_user_id => late_user_id, :is_match => true).first
    unless match_user
      render :status => 403, :json => {:status => false}
      return
    end
    
    @chat = Chat.new
    @chat.user_id = login_user_id
    @chat.early_user_id = early_user_id
    @chat.late_user_id  = late_user_id
    @chat.content = params[:chat][:content]
    
    @chat.save
    redirect_to("/chats/#{to_user_id}")
  end
  
end
