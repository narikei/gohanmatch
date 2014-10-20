class SessionsController < ApplicationController
  
  def callback

    auth = request.env["omniauth.auth"]
    
    user = User.where(:provider => auth[:provider], :uid => auth[:uid]).first_or_initialize

    if user.id
      # 既存のユーザ情報があった場合　ルートに遷移させます
      session[:user_id] = user.id
    else
      user = User.new
      user.provider = auth[:provider]
      user.uid      = auth[:uid]
      user.nickname = auth[:info][:name]
      user.image    = "https://graph.facebook.com/#{auth[:uid]}/picture?height=300&width=300"
      user.sex      = get_gender(auth[:extra][:raw_info][:gender])
      user.active = true

      if user.save
        session[:user_id] = user.id
      end
    end
    
    if user.friend_ids.blank?
      friends(auth)
    end
    
    session[:auth] = auth
    
    redirect_to("/")
  end
  
  def destroy
    session.destroy
    redirect_to("/")
  end
  
  private
  def get_gender(gender)
    if gender === "male"
      return 0
    elsif gender === "female"
      return 1   
    end
    
    nil
  end
  
  def friends(auth)
    # 友達をUser登録
    if(auth[:provider] == "facebook")
      graph = Koala::Facebook::API.new(auth[:credentials][:token])
      friends = graph.get_object("/#{auth[:uid]}/friends")
      
      friends.each do |friend|
        f = User.where(:provider => "facebook", :uid => friend["id"]).first_or_initialize

        unless(f.id)
          f.nickname = friend["name"]
          f.image    = "https://graph.facebook.com/#{friend["id"]}/picture?height=300&width=300"
          f.save
        end

        login_user.friend_ids.add(f.id)
      end
      
      login_user.friend_ids.expire 7.days
    end
  end
  
end