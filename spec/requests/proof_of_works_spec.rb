require "rails_helper"

RSpec.describe "Proof of work", type: :request do
  describe "authentication" do
    it "requires authentication for listing proof of work" do
      get proof_of_works_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET /proof_of_work" do
    it "lists only the signed-in user's proof of work" do
      viewer = create(:user)
      other_user = create(:user)
      viewer_proof = create(:proof_of_work, user: viewer, title: "Viewer evidence")
      create(:proof_of_work, user: other_user, title: "Other evidence")

      sign_in viewer
      get proof_of_works_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(viewer_proof.title)
      expect(response.body).not_to include("Other evidence")
    end
  end

  describe "POST /labs/:lab_id/proof_of_work" do
    it "creates proof for the user's completed lab" do
      user = create(:user)
      lab = create(:engineering_lab, user: user, status: :completed, title: "PostgreSQL Query Optimization")

      sign_in user

      post lab_proof_of_works_path(lab), params: {
        proof_of_work: {
          title: "PostgreSQL Query Optimization Experiment",
          description: "Compared query performance before and after indexing.",
          proof_type: :benchmark,
          url: "https://github.com/example/repo"
        }
      }

      proof = user.reload.proof_of_works.last

      expect(response).to redirect_to(proof_of_work_path(proof))
      expect(proof.engineering_lab).to eq(lab)
      expect(proof.user).to eq(user)
    end

    it "prevents creating proof for another user's lab" do
      owner = create(:user)
      intruder = create(:user)
      lab = create(:engineering_lab, user: owner, status: :completed)

      sign_in intruder

      expect {
        post lab_proof_of_works_path(lab), params: {
          proof_of_work: {
            title: "Blocked proof",
            description: "Blocked description",
            proof_type: :benchmark,
            url: "https://example.com/blocked"
          }
        }
      }.not_to change(ProofOfWork, :count)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /proof_of_work/:id" do
    it "allows the owner to view proof" do
      user = create(:user)
      proof = create(:proof_of_work, user: user)

      sign_in user
      get proof_of_work_path(proof)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(proof.title)
    end

    it "prevents viewing another user's proof" do
      owner = create(:user)
      intruder = create(:user)
      proof = create(:proof_of_work, user: owner)

      sign_in intruder
      get proof_of_work_path(proof)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /proof_of_work/:id" do
    it "updates the user's proof" do
      user = create(:user)
      proof = create(:proof_of_work, user: user, title: "Old proof")

      sign_in user
      patch proof_of_work_path(proof), params: {
        proof_of_work: {
          title: "Updated proof",
          description: "Updated evidence summary.",
          proof_type: :technical_article,
          url: "https://example.com/article"
        }
      }

      expect(response).to redirect_to(proof_of_work_path(proof))
      expect(proof.reload.title).to eq("Updated proof")
      expect(proof.proof_type).to eq("technical_article")
    end

    it "prevents updating another user's proof" do
      owner = create(:user)
      intruder = create(:user)
      proof = create(:proof_of_work, user: owner, title: "Original proof")

      sign_in intruder
      patch proof_of_work_path(proof), params: {
        proof_of_work: {
          title: "Intruder proof",
          description: "Intruder update",
          proof_type: :other
        }
      }

      expect(response).to have_http_status(:not_found)
      expect(proof.reload.title).to eq("Original proof")
    end
  end

  describe "DELETE /proof_of_work/:id" do
    it "deletes the user's proof" do
      user = create(:user)
      proof = create(:proof_of_work, user: user)

      sign_in user

      expect {
        delete proof_of_work_path(proof)
      }.to change(ProofOfWork, :count).by(-1)

      expect(response).to redirect_to(lab_path(proof.engineering_lab))
    end

    it "prevents deleting another user's proof" do
      owner = create(:user)
      intruder = create(:user)
      proof = create(:proof_of_work, user: owner)

      sign_in intruder

      expect {
        delete proof_of_work_path(proof)
      }.not_to change(ProofOfWork, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
