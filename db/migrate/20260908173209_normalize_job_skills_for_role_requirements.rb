class NormalizeJobSkillsForRoleRequirements < ActiveRecord::Migration[8.1]
  def up
    add_reference :job_skills, :job, foreign_key: true
    add_reference :job_skills, :skill, foreign_key: true
    add_column :job_skills, :required_level, :integer

    backfill_existing_job_skills
    remove_columns :job_skills, :job, :skill
    deduplicate_job_skills

    change_column_null :job_skills, :job_id, false
    change_column_null :job_skills, :skill_id, false
    change_column_null :job_skills, :required_level, false

    add_index :job_skills, [ :job_id, :skill_id ], unique: true
  end

  def down
    add_column :job_skills, :job, :string
    add_column :job_skills, :skill, :string

    execute <<~SQL
      UPDATE job_skills
      SET job = jobs.title,
          skill = skills.name
      FROM jobs, skills
      WHERE jobs.id = job_skills.job_id
        AND skills.id = job_skills.skill_id;
    SQL

    remove_index :job_skills, column: [ :job_id, :skill_id ]

    change_column_null :job_skills, :required_level, true
    change_column_null :job_skills, :skill_id, true
    change_column_null :job_skills, :job_id, true

    remove_reference :job_skills, :skill, foreign_key: true
    remove_reference :job_skills, :job, foreign_key: true
    remove_column :job_skills, :required_level, :integer
  end

  private

  def backfill_existing_job_skills
    execute <<~SQL
      INSERT INTO jobs (title, created_at, updated_at)
      SELECT DISTINCT job_skills.job, NOW(), NOW()
      FROM job_skills
      WHERE job_skills.job IS NOT NULL
        AND job_skills.job <> ''
        AND NOT EXISTS (
          SELECT 1
          FROM jobs
          WHERE jobs.title = job_skills.job
        );
    SQL

    execute <<~SQL
      UPDATE job_skills
      SET job_id = jobs.id
      FROM jobs
      WHERE jobs.title = job_skills.job
        AND job_skills.job_id IS NULL;
    SQL

    execute <<~SQL
      UPDATE job_skills
      SET skill_id = matched_skills.skill_id
      FROM (
        SELECT DISTINCT ON (LOWER(name)) id AS skill_id, LOWER(name) AS normalized_name
        FROM skills
        ORDER BY LOWER(name), id
      ) matched_skills
      WHERE LOWER(job_skills.skill) = matched_skills.normalized_name
        AND job_skills.skill_id IS NULL;
    SQL

    execute <<~SQL
      UPDATE job_skills
      SET required_level = 1
      WHERE required_level IS NULL;
    SQL

    execute <<~SQL
      DELETE FROM job_skills
      WHERE job_id IS NULL
         OR skill_id IS NULL;
    SQL
  end

  def deduplicate_job_skills
    execute <<~SQL
      DELETE FROM job_skills older
      USING job_skills newer
      WHERE older.job_id = newer.job_id
        AND older.skill_id = newer.skill_id
        AND older.id < newer.id;
    SQL
  end
end
