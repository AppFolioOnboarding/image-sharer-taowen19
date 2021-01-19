class ImagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @images = Image.all.reverse
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

  private

  def image_params
    params.require(:image).permit(:url, :tags)
  end
end
