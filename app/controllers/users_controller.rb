class UsersController < ApplicationController

  def new_registration_form
    render({ :template => "users/signup_form.html.erb"})
  end


  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index.html.erb" })
  end

  def create
    the_user = User.new

    the_user.username = params.fetch("input_username")
    the_user.password = params.fetch("input_password")
    the_user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = the_user.save

    @the_user = the_user

    if save_status == true

    session[:user_id] = @the_user.id

      redirect_to("/users/#{the_user.username})", { :notice => "User account created successfully." })
    else
      redirect_to("/user_sign_up", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def show
    if @current_user == nil
      redirect_to("/user_sign_in", { :alert => "You have to sign in first."})
    else 
      the_username = params.fetch("path_id")
      @the_user = User.where({ :username => the_username }).at(0)
    render({ :template => "users/show.html.erb" })
    end
  end

  def update_form
    render({ :template => "users/edit_user_profile.html.erb"})
  end

  def update
    the_id = @current_user.id
    
    the_user = User.where({ :id => the_id }).at(0)
    the_user.comments_count = params.fetch("query_comments_count")
    the_user.email = params.fetch("query_email")
    the_user.likes_count = params.fetch("query_likes_count")
    the_user.username = params.fetch("query_username")
    the_user.private = params.fetch("query_private", false)

    if the_user.valid?

    the_user.save
      redirect_to("/users/#{the_user.username}", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.username}", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def update_user
    the_username = params.fetch("path_id")
    @the_user = User.where({ :username => the_username }).at(0)

    @the_user.username = params.fetch("query_username")
    @the_user.private = params.key?(:query_private)

    @the_user.save

    redirect_to("/users/#{@the_user.username}")
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end

  def toast_cookies
    reset_session
    redirect_to("/", {:notice => "Signed out successfully." })
  end

  def new_session_form
    render({ :template => "users/signin_form.html.erb"})
  end

  def authenticate
    un = params.fetch("input_username")
    pw = params.fetch("input_password")

    user = User.where({ :username => un }).at(0)
    if user == nil
      redirect_to("/user_sign_in", {:notice => "No user with that email address."})
    else
      if user.authenticate(pw)
        session.store(:user_id, user.id)

        redirect_to("/", { :notice => "Signed in successfully."})
      else
        redirect_to("/user_sign_in", {:alert => "Incorrect password."})
      end
    end
  end

  def feed
    the_username = params.fetch("path_id")
    @the_user = User.where({ :username => the_username }).at(0)
    @the_user_feed = @the_user.feed
    render({ :template => "users/feed.html.erb" })
  end

  def liked_photos
    the_username = params.fetch("path_id")
    @the_user = User.where({ :username => the_username }).at(0)
    render({ :template => "users/liked_photos.html.erb" })
  end

  def discover
    the_username = params.fetch("path_id")
    @the_user = User.where({ :username => the_username }).at(0)
    render({ :template => "users/discover.html.erb" })
  end

end
