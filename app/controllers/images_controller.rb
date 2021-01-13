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
      #redirect_to @image.url
      render :show
    else
      puts "save failed"
      render :new
    end
  end
end 