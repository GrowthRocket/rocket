module WelcomeHelper
  def render_progress_landing_page(percent)
    percent = percent.to_s + "%"
    content_tag :div, class: "progress progress-whole" do
      content_tag :div, class: %w(progress-bar progress-content), role: "progressbar", 'aria-valuenow': percent, 'aria-valuemin': "0", 'aria-valuemax': "100", 'style': "width: "+ percent + ";min-width:2em;"  do
      end
    end
  end
end
