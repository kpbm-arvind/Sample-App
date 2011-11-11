class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps # creates 'magic columns' => created_at/updated_at columns
    end
  end

  def self.down
    drop_table :users
  end
end
