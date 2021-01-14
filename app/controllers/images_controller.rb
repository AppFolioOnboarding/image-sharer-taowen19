class ImagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @image = Image.all
  end

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(url: params.require(:image)[:url])

    if @image.save
      render :show
    else
      render :new
    end
  end
end
