class ImagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @images = Image.all.reverse
    @images = Image.tagged_with(params[:tag]).reverse if params[:tag].present?
    @filtered_tag = params[:tag] if params[:tag].present?
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
    @image = Image.find params[:id]
    @image.destroy!
    if params[:filtered_tag].present?
      redirect_to images_path(tag: params[:filtered_tag])
    else
      redirect_to images_path
    end
  end

  private

  def image_params
    params.require(:image).permit(:url, :tags)
  end
end
