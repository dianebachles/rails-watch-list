class ListsController < ApplicationController
  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
    @bookmark = Bookmark.new
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)

    if params[:list][:image].present?
      uploaded_file = params[:list][:image]
      cloudinary_response = Cloudinary::Uploader.upload(uploaded_file, api_key: ENV['CLOUDINARY_API_KEY'], api_secret: ENV['CLOUDINARY_API_SECRET'], cloud_name: ENV['CLOUDINARY_CLOUD_NAME'])
      @list.image = cloudinary_response["public_id"]
    end

    if @list.save
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    redirect_to root_path
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
