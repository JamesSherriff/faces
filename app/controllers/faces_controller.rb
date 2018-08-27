class FacesController < ApplicationController
  require 'face_detect'
  require 'face_detect/adapter/google'
  
  def index
    if params[:upload] then
      filetype = params[:upload][:file].original_filename.split(".")[1]
      path = File.join("public", "images", "upload", "image." + filetype)
      File.open(path, "wb") { |f| f.write(params[:upload][:file].read) }
      
      input = File.new(path)
      detector = FaceDetect.new(
        file: input,
        adapter: FaceDetect::Adapter::Google
      )
      results = detector.run
      results #=> [<FaceDetect::Face>, ...]
      face = results.first
      
      puts face.inspect
      
      if face != nil then
        mouth_width = face.mouth_right.x - face.mouth_left.x

        moustache_width = mouth_width
        moustache_height = 300 * (530 / mouth_width)
        
        moustache_number = Random.rand(0..3)

        first_image  = MiniMagick::Image.new("public/images/upload/image." + filetype)
        second_image = MiniMagick::Image.new("moustache_" + moustache_number.to_s + ".png")
        result = first_image.composite(second_image) do |c|
          c.compose "Over"    # OverCompositeOp
          c.geometry (moustache_width + 20).to_s + "x" + (moustache_height).to_s + "+" + (face.mouth_left.x - 10).to_s + "+" + ((face.mouth_left.y + 5) - (moustache_width / 2)).to_s# copy second_image onto first_image from (20, 20)
        end
        result.write "public/output.jpg"
        @image = "output.jpg"
      end
    end
  end
  
end
