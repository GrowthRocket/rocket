module Account::ProjectsHelper

  def render_project_video_or_image(project)
    if project.video.include? "youku"
      project.video.html_safe
    else
      image_tag(project.image.large)
   end
  end
  
end
