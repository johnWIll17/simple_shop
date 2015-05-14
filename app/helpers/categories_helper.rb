module CategoriesHelper

  def object_variables
    category_variables = {}
    category_variables[:icon] = 'grid'
    category_variables[:title] = 'Categories'
    category_variables[:object_name] = 'Category'
    #category_variables[:object_controller] = CategoriesController
    category_variables[:form_path] = 'categories/form'
    category_variables[:status_form_path] = status_categories_path

    category_variables
  end

end
