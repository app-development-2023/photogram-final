class PhotosController < ApplicationController
  def index
    matching_photos = Photo.all
    @photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photos/index.html.erb" })
  end

  def show
    p_id = params.fetch("path_id")
    @the_photo = Photo.where({:id => p_id }).first
    render({:template => "photos/show.html.erb"})
  end

  def create
    user_id = session.fetch(:user_id)
    image = params.fetch(:image)
    caption = params.fetch("query_caption")
    photo = Photo.new
    photo.owner_id = user_id
    photo.image = image
    photo.caption = caption
    save_status = photo.save

    if save_status == true
      session.store(:user_id, user_id)
      redirect_to("/photos", { :notice => "Photo created successfully"})
    else
      redirect_to("/photos", {:alert => photo.errors.full_messages.to_sentence})
    end
  end

  def update
      id = params.fetch("the_photo_id")
      photo = Photo.where({ :id => id }).at(0)
      photo.caption = params.fetch("input_caption")
      photo.image = params.fetch("input_image")
      photo.save
  
      redirect_to("/photos/#{photo.id}")
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
