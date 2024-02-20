class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :auth_token
      t.string :google_id

      t.timestamps
    end
  end
end
