class ImagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @images = Image.all.reverse
    @images = Image.tagged_with(params[:tag]).reverse if params[:tag].present?
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(url: image_params[:url])
    @image.tag_list.add(image_params[:tags].split)

    if @image.save
      render :show
    else
      render :new
    end
  end

  def destroy
    Image.destroy(image_params[:id])
    redirect_to images_path
  end

  private

  def image_params
    params.require(:image).permit(:url, :tags, :id)
  end
end
