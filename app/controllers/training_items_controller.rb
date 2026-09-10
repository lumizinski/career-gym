class TrainingItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_training_item

  def update
    return_to = safe_return_path

    if @training_item.update(training_item_params)
      redirect_to(return_to || training_index_path, notice: "Training item updated.", allow_other_host: false)
    else
      redirect_to(return_to || training_index_path, alert: @training_item.errors.full_messages.to_sentence, allow_other_host: false)
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

  def safe_return_path
    path = params[:return_to].presence || request.referer
    return unless path.present?

    uri = URI.parse(path)
    return if uri.host.present? || uri.scheme.present?
    return unless path.start_with?("/")
    return if path.start_with?("//")

    path
  rescue URI::InvalidURIError
    nil
  end
end
