class CreateGithubQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :github_queries do |t|
      t.string :username
      t.string :language

      t.timestamps
    end
  end
end
