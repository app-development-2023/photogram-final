class UsersController < ApplicationController

  def new_registration_form
    render({ :template => "users/signup_form.html.erb"})
  end


  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_users = User.where({ :id => the_id })

    @the_user = matching_users.at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    the_user = User.new
    #the_user.comments_count = params.fetch("query_comments_count")
    the_user.email = params.fetch("query_email")
    #the_user.likes_count = params.fetch("query_likes_count")
    the_user.password_digest = params.fetch("query_password_digest")
    #the_user.private = params.fetch("query_private", false)
    the_user.username = params.fetch("query_username")

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "User created successfully." })
    else
      redirect_to("/users", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def create
    the_user = User.new

    the_user.username = params.fetch("input_username")
    the_user.password = params.fetch("input_password")
    the_user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = the_user.save

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "User created successfully." })
    else
      redirect_to("/users", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.comments_count = params.fetch("query_comments_count")
    the_user.email = params.fetch("query_email")
    the_user.likes_count = params.fetch("query_likes_count")
    the_user.password_digest = params.fetch("query_password_digest")
    the_user.private = params.fetch("query_private", false)
    the_user.username = params.fetch("query_username")

    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end

  def toast_cookies
    reset_session
    redirect_to("/", {:notice => "See you later!" })
  end

  def new_session_form
    render({ :template => "users/signin_form.html.erb"})
  end

  def authenticate
    un = params.fetch("input_username")
    pw = params.fetch("input_password")

    user = User.where({ :username => un }).at(0)
    if user == nil
      redirect_to("/user_sign_in", {:alert => "No one by that name here"})
    else
      if user.authenticate(pw)
        session.store(:user_id, user.id)

        redirect_to("/", { :notice => "Welcome back, " + user.username + "!"})
      else
        redirect_to("/user_sign_in", {:alert => "Nice try, sucker!"})
      end
    end
  end

end
