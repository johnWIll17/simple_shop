class ProductsController < ApplicationController

  def initialize
    super
    @model = Product
    @model_object = nil

    @white_list_params = [:product_name, :price, :description, :active, :category_id]

    @model_objects_path = :products_path

    @search_list = ['product_name', 'price']

    object_info
  end

  def delete_image
    picture = Picture.find(params[:pic_id])
    picture.remove_image!
    picture.destroy

    redirect_to :back
  end

  private
    #def create_success
    #  create_image
    #end

    def create_image
      if params[:images]
        params[:images].each do |img|
          @model_object.pictures.create(image: img)
        end
      end
    end

end
