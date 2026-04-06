class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :onboarding_application, null: false, foreign_key: true
      t.string :document_type, null: false # passport, ID, certificate_of_incorporation etc...
      t.boolean :verified, null: false, default: false
      t.string :file_url, null: false

      t.timestamps
    end
  end
end
