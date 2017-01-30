defmodule PhotoPi.Twitter do
  @moduledoc false

  @status Application.get_env(:photo_pi, __MODULE__)[:status_message]

  @spec post_status_with_image(Path.t) :: any
  def post_status_with_image(image_path) do
    image = File.read!(image_path)
    ExTwitter.update_with_media(@status, image)
  end

end
