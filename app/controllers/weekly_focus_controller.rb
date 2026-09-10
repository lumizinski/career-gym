class WeeklyFocusController < ApplicationController
  before_action :authenticate_user!

  def show
    @focus = CareerFocus.new(current_user)
  end
end
