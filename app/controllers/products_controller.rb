class ProductsController < ApplicationController

  def initialize
    super
    @model = Product
    @primary_key = :product_ids
    @model_object = nil

    @white_list_params = [:product_name, :price, :description, :active, :category_id]
    @object_require = :product

    @model_objects_path = :products_path
    @model_new_path = :new_product_path

    @search_list = ['product_name', 'price', 'active']
  end


  def create
    @model_object = @model.new(object_params)
    if @model_object.save
      create_image

      flash[:success] = 'Your product has been created successfully!'
      redirect_to products_path
    else
      render :new
    end
  end

  def update
    @model_object = @model.find(params[:id])
    if @model_object.update(object_params)
      create_image

      flash[:success] = 'Your product has been updated successfully!'
      redirect_to products_path
    else
      render :edit
    end
  end

  def delete_image
    picture = Picture.find(params[:pic_id])
    picture.remove_image!
    picture.destroy

    redirect_to :back
  end

  private
    def create_image
      if params[:images]
        params[:images].each do |img|
          @model_object.pictures.create(image: img)
        end
      end
    end

end
