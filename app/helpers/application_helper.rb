module ApplicationHelper
  def active_if(action_string)
    (controller_name, action_name) = action_string.split('#')
    if params[:controller] == controller_name and params[:action] == action_name
      'class=active'
    else
      ''
    end
  end

  def active_if_photos
    if params[:controller] == "photo_albums"
      'class=active'
    else
      ''
    end
  end
end
