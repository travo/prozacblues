project.helpers do

  def main_header_image
    if page.meta['main_image']
      %{<style type="text/css"> header { background-image: url(#{href(page.meta['main_image'])}) } </style>}
    end
  end

end
