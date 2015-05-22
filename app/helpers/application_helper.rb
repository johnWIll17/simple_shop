module ApplicationHelper

  def sortable column, title = nil
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge( sort: column, direction: direction )
  end

  def display_active_column model_object
    model_object.active ? 'Active' : 'Deactive'
  end

  def selected_option_active model_object
    model_object.new_record? ? 'Active' : display_active_column(model_object)
  end

end
