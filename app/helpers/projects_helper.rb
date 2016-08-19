module ProjectsHelper
  def render_project_description(project)
    simple_format(project.description)
  end

  def render_project_image(project, _size = :thumb)
    image_tag(project.image.thumb, width: 123, height: 90)
  end
end
