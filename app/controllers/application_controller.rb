class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :require_login
  before_action :set_model_object, only: [:edit, :update]
  helper_method :sort_column, :sort_direction


  #Constants for working with Active & Delete submit button
  ACTIVE = true
  DEACTIVE = false

  SELECT_ACTIVE = 'Active'
  SELECT_DEACTIVE = 'Deactive'

  def initialize
    super
    @model = nil
    @selected_ids = :selected_ids

    @white_list_params = nil

    @model_objects_path = nil

    @search_list = nil
  end

  def index
    @model_objects = @model.search(params[:search], @search_list).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
  end

  def new
    @model_object = @model.new
  end

  def edit
  end

  def create
    @model_object = @model.new(object_params)
    if @model_object.save
      create_image if defined? create_image

      flash[:success] = "You have created successfully!"
      redirect_to send(@model_objects_path)
    else
      render :new
    end
  end

  def update
    if @model_object.update(object_params)
      create_image if defined? create_image

      flash[:success] = "You have updated successfully!"
      redirect_to send(@model_objects_path)
    else
      render :edit
    end
  end

  #Methods for working with Active & Delete submit button
  def status_form
    if params[:button_name] == 'active'
      active
    else
      deactive
    end
  end


  private

    #Methods for sorting table
    def sort_column
      @model.column_names.include?(params[:sort]) ? params[:sort] : 'id'
    end

    def sort_direction
      %w{asc desc}.include?(params[:direction]) ? params[:direction] : 'asc'
    end

    def set_model_object
      @model_object = @model.find_by(id: params[:id])
      unless @model_object
        redirect_to '/404'
      end
    end

    # This method contains extra information about @model_object
    #   @object_require: object when submit form (new/edit)
    #   @model_new_path: the path to create new object (ex: new_product_path)
    def object_info
      @object_require = @model.to_s.downcase.to_sym
      @model_new_path = "new_#{@model.to_s.downcase}_path".to_sym
    end

    def white_list_params
      params.require(@object_require).permit(*@white_list_params)
    end

    def object_params
      new_params = white_list_params
      new_params[:active] = ( new_params[:active] == SELECT_ACTIVE ? true : false )
      new_params
    end

    def action_form status
      @model.where(id: params[@selected_ids]).update_all(active: status) if @model
      flash[:success] = "Successfully!"
      redirect_to :back
    end

    def deactive
      action_form DEACTIVE
    end

    def active
      action_form ACTIVE
    end

    def not_authenticated
      flash[:danger] = 'You have to authenticate to access that page.'
      redirect_to log_in_path
    end

end
