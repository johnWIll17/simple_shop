class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :sort_column, :sort_direction
  before_action :set_model_object, only: [:edit, :update]

  #Constants for working with Active & Delete submit button
  ACTIVE = 'Active'
  DEACTIVE = 'Delete'

  def initialize
    super
    @model = nil
    @primary_key = nil

    @white_list_params = nil
    @object_require = nil

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
      child_logic

      flash[:success] = "You have created successfully!"
      redirect_to send(@model_objects_path)
    else
      render :new
    end
  end

  def update
    if @model_object.update(object_params)
      child_logic

      flash[:success] = "You have updated successfully!"
      redirect_to send(@model_objects_path)
    else
      render :edit
    end
  end

  #Methods for working with Active & Delete submit button
  def deactive
    action_form 'Deactive'
  end

  def active
    action_form 'Active'
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

    def object_params
      params.require(@object_require).permit(*@white_list_params)
    end

    def action_form status
      @model.where(id: params[@primary_key]).update_all(active: status) unless @model.nil?
      flash[:success] = "You have #{status.to_s + 'd'} successfully!"
      redirect_to :back
    end

    def child_logic
      create_success if defined? create_success
    end

end
