class ListsController < ApplicationController
  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)

    # Upload the image to Cloudinary and store the URL in the list's image_url attribute
    if params[:list][:image].present?
      result = Cloudinary::Uploader.upload(params[:list][:image])
      @list.image_url = result["url"]
    end

    if @list.save
      redirect_to @list
    else
      render 'new'
    end
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])

    if @list.update(list_params)
      # Re-upload the image to Cloudinary if a new image was selected
      if params[:list][:image].present?
        result = Cloudinary::Uploader.upload(params[:list][:image])
        @list.update(image_url: result["url"])
      end

      redirect_to @list
    else
      render 'edit'
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy

    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:name, :image_url)
  end
end
