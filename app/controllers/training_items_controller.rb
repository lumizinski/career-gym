class TrainingItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_training_item

  def update
    if @training_item.update(training_item_params)
      redirect_back fallback_location: training_index_path, notice: "Training item updated."
    else
      redirect_back fallback_location: training_index_path, alert: @training_item.errors.full_messages.to_sentence
    end
  end

  private

  def set_training_item
    @training_item = current_user.training_plan&.training_items&.find(params.expect(:id))
    return if @training_item.present?

    raise ActiveRecord::RecordNotFound
  end

  def training_item_params
    params.expect(training_item: [ :status ])
  end
end
