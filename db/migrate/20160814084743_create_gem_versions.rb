class CreateGemVersions < ActiveRecord::Migration
  def change
    create_table :gem_versions do |t|

      t.string :name, null: false
      t.string :version, null: false
      t.string :gem_copy, null: false
      t.string :sha, null: false

      t.timestamps null: false
    end
  end
end
