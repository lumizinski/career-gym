class ProofOfWork < ApplicationRecord
  PROOF_TYPES = {
    github_repository: "github_repository",
    github_pull_request: "github_pull_request",
    technical_article: "technical_article",
    architecture_document: "architecture_document",
    benchmark: "benchmark",
    experiment: "experiment",
    presentation: "presentation",
    other: "other"
  }.freeze

  PROOF_TYPE_LABELS = {
    "github_repository" => "GitHub Repository",
    "github_pull_request" => "GitHub Pull Request",
    "technical_article" => "Technical Article",
    "architecture_document" => "Architecture Document",
    "benchmark" => "Benchmark",
    "experiment" => "Experiment",
    "presentation" => "Presentation",
    "other" => "Other"
  }.freeze

  enum :proof_type, PROOF_TYPES, validate: true

  belongs_to :user
  belongs_to :engineering_lab

  delegate :skill, to: :engineering_lab

  scope :recent_first, -> { order(completed_at: :desc, created_at: :desc, id: :desc) }

  validates :title, :description, :completed_at, presence: true
  validates :url, length: { maximum: 2048 }, allow_blank: true
  validate :url_must_be_http_or_https
  validate :ownership_matches_engineering_lab
  validate :engineering_lab_is_completed

  before_validation :set_completed_at, on: :create

  def proof_type_label
    self.class.proof_type_label_for(proof_type)
  end

  def self.proof_type_options
    proof_types.keys.map { |key| [ proof_type_label_for(key), key ] }
  end

  def self.proof_type_label_for(value)
    PROOF_TYPE_LABELS.fetch(value.to_s)
  end

  private

  def set_completed_at
    self.completed_at ||= engineering_lab&.completed_at || Time.current
  end

  def url_must_be_http_or_https
    return if url.blank?

    uri = URI.parse(url)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(:url, "must be a valid HTTP or HTTPS URL")
  rescue URI::InvalidURIError
    errors.add(:url, "must be a valid HTTP or HTTPS URL")
  end

  def ownership_matches_engineering_lab
    return if engineering_lab.blank? || user_id.blank?
    return if engineering_lab.user_id == user_id

    errors.add(:engineering_lab, "must belong to the same user")
  end

  def engineering_lab_is_completed
    return if engineering_lab.blank? || engineering_lab.completed?

    errors.add(:engineering_lab, "must be completed before adding proof of work")
  end
end
