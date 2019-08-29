class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :image
      t.string :password_digest
      t.string :remember_digest
      t.string :role
      t.string :activation_digest
      t.boolean :activated
      t.datetime :activated_at
      t.string :reset_digest

      t.timestamps
    end
  end
end
