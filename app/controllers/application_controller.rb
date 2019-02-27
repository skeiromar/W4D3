class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :ensure_logged_in 


  def current_user
    # debugger
    if session[:session_token]
      return User.find_by(session_token: session[:session_token])
    else
      return nil
    end
  end

  def logged_in?
    #we don't want this to ever be nil or truthy object
    #this will make it so it will always be either true or false
    !!current_user
  end

  def login!(user)
    session[:session_token] = user.reset_session_token!
  end 

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def ensure_logged_in 
    redirect_to new_session_url unless logged_in?
  end
end
