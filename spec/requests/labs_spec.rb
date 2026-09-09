require "rails_helper"

RSpec.describe "Labs", type: :request do
  describe "authentication" do
    it "requires authentication for listing labs" do
      get labs_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /labs" do
    it "lists only the signed-in user's labs" do
      viewer = create(:user)
      other_user = create(:user)
      viewer_lab = create(:engineering_lab, user: viewer)
      create(:engineering_lab, user: other_user, title: "Other user's lab")

      sign_in viewer
      get labs_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(viewer_lab.title)
      expect(response.body).not_to include("Other user's lab")
    end
  end

  describe "POST /labs" do
    it "creates a lab from the user's training item" do
      user = create(:user)
      skill = create(:skill, name: "PostgreSQL", category: "Database")
      plan = create(:training_plan, user: user)
      item = create(
        :training_item,
        training_plan: plan,
        skill: skill,
        title: "Run a PostgreSQL query optimization experiment",
        description: "Investigate indexes with EXPLAIN ANALYZE."
      )

      sign_in user

      post labs_path, params: {
        training_item_id: item.id,
        engineering_lab: {
          title: "PostgreSQL Query Optimization Experiment",
          description: "Practical database workout.",
          objective: "Investigate indexing strategies.",
          deliverables_text: "EXPLAIN output\nBenchmark notes"
        }
      }

      lab = user.reload.engineering_labs.last

      expect(response).to redirect_to(lab_path(lab))
      expect(lab.training_item).to eq(item)
      expect(lab.skill).to eq(skill)
      expect(lab.user).to eq(user)
      expect(lab.deliverables).to eq([ "EXPLAIN output", "Benchmark notes" ])
    end

    it "prevents creating a lab from another user's training item" do
      owner = create(:user)
      intruder = create(:user)
      item = create(:training_item, training_plan: create(:training_plan, user: owner))

      sign_in intruder

      expect {
        post labs_path, params: {
          training_item_id: item.id,
          engineering_lab: {
            title: "Blocked lab",
            description: "Blocked description",
            objective: "Blocked objective",
            deliverables_text: "Blocked deliverable"
          }
        }
      }.not_to change(EngineeringLab, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /labs/:id" do
    it "allows the owner to view a lab" do
      user = create(:user)
      lab = create(:engineering_lab, user: user)

      sign_in user
      get lab_path(lab)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(lab.title)
    end

    it "prevents access to another user's lab" do
      owner = create(:user)
      intruder = create(:user)
      lab = create(:engineering_lab, user: owner)

      sign_in intruder
      get lab_path(lab)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /labs/:id" do
    it "updates a user's lab" do
      user = create(:user)
      lab = create(:engineering_lab, user: user, title: "Old title")

      sign_in user
      patch lab_path(lab), params: {
        engineering_lab: {
          title: "Updated title",
          description: "Updated description",
          objective: "Updated objective",
          deliverables_text: "Diagram\nBenchmark"
        }
      }

      expect(response).to redirect_to(lab_path(lab))
      expect(lab.reload.title).to eq("Updated title")
      expect(lab.deliverables).to eq([ "Diagram", "Benchmark" ])
    end

    it "prevents updating another user's lab" do
      owner = create(:user)
      intruder = create(:user)
      lab = create(:engineering_lab, user: owner, title: "Original title")

      sign_in intruder
      patch lab_path(lab), params: {
        engineering_lab: {
          title: "Intruder update",
          description: "Intruder description",
          objective: "Intruder objective",
          deliverables_text: "Intruder"
        }
      }

      expect(response).to have_http_status(:not_found)
      expect(lab.reload.title).to eq("Original title")
    end
  end

  describe "PATCH /labs/:id/complete" do
    it "marks a lab as completed" do
      user = create(:user)
      lab = create(:engineering_lab, user: user, status: :in_progress, completed_at: nil)

      sign_in user
      patch complete_lab_path(lab)

      expect(response).to redirect_to(lab_path(lab))
      expect(lab.reload).to be_completed
      expect(lab.completed_at).to be_present
    end

    it "prevents completing another user's lab" do
      owner = create(:user)
      intruder = create(:user)
      lab = create(:engineering_lab, user: owner, status: :in_progress)

      sign_in intruder
      patch complete_lab_path(lab)

      expect(response).to have_http_status(:not_found)
      expect(lab.reload).to be_in_progress
    end
  end
end
