class TrainingItem < ApplicationRecord
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  belongs_to :training_plan
  belongs_to :skill
  has_one :engineering_lab, dependent: :nullify

  scope :ordered, -> { order(:position, :id) }

  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :position, uniqueness: { scope: :training_plan_id }

  def supports_engineering_lab?
    practical_work_text.match?(/\b(design|build|implement|practice|run|benchmark|investigat(?:e|ion)|experiment|instrument|load test)\b/i).present?
  end

  def suggested_engineering_lab_attributes
    {
      title: title,
      description: description,
      objective: description,
      deliverables: default_lab_deliverables
    }
  end

  private

  def practical_work_text
    [ title, description ].join(" ")
  end

  def default_lab_deliverables
    if skill.name == "System Design" || title.match?(/\bdesign\b/i)
      [
        "Architecture diagram",
        "API design",
        "Data model",
        "Failure scenarios",
        "Scalability analysis"
      ]
    else
      [
        "Scope and success criteria",
        "Experiment or implementation notes",
        "Results and findings",
        "Follow-up improvements"
      ]
    end
  end
end
