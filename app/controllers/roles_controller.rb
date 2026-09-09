class RolesController < ApplicationController
  before_action :set_role, only: %i[show edit update destroy]

  def index
    @roles = Role.all
  end

  def show
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.new(role_params)

    if @role.save
      redirect_to @role, notice: "Role was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @role.update(role_params)
      redirect_to @role, notice: "Role was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @role.destroy!
    redirect_to roles_path, notice: "Role was successfully destroyed.", status: :see_other
  end

  private

  def set_role
    @role = Role.find(params.expect(:id))
  end

  def role_params
    params.expect(role: [ :company, :title, :description ])
  end
end
