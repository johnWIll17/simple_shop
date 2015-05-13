class CategoriesController < ApplicationController

  def initialize
    super
    @model = Category
    @model_object = nil

    @white_list_params = [:category_name, :active]

    @model_objects_path = :categories_path

    @search_list = ['category_name', 'active']

    object_info
  end

end
