class SkillGapsController < ApplicationController
  before_action :authenticate_user!

  def index
    @analysis = SkillGapAnalysis.new(current_user)
  end
end
