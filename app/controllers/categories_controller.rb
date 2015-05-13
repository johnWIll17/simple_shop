class CategoriesController < ApplicationController

  def initialize
    super
    @model = Category
    @primary_key = :category_ids
    @model_object = nil

    @white_list_params = [:category_name, :active]
    @object_require = :category

    @model_objects_path = :categories_path
    @model_new_path = :new_category_path

    @search_list = ['category_name', 'active']
  end

end
