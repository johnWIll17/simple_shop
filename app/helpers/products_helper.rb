module ProductsHelper

  def object_variables
    product_variables = {}
    product_variables[:icon] = 'list'
    product_variables[:title] = 'Products'
    product_variables[:object_name] = 'Product'
    #product_variables[:object_controller] = ProductsController
    product_variables[:form_path] = 'products/form'
    product_variables[:status_form_path] = status_products_path

    product_variables
  end

end
