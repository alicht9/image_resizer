class ImageResizer < Sinatra::Base
  not_found { erb :'404' }

  get '/' do
    erb :resize
  end

  post '/' do
    width = params["width"].to_i
    height = params["height"].to_i

    if width <= 0 || height <= 0
	@error = "ERROR: Both height and width must be positive integers!"
	status 500
        return erb :error
    end

    begin
      response = open(params["image_url"]) #This is open-uri's open
    rescue
      @error = "ERROR: Unable to open the input url: #{params["image_url"]}"
      status 500
      return erb :error
    end

    img = Magick::ImageList.new

    begin
      img.from_blob(response.read)
    rescue
      @error = "ERROR: ImageMagick was unable to figure out what to do with this image."
      status 500
      return erb :error
    end

    img.resize! width, height
    #Just return pngs for now, as they usually display nicely in browsers. We always 
    #have the option to allow the user select a format at some later date.
    img.format = 'png'
    content_type 'image/png'
    img.to_blob
  end
  
end
