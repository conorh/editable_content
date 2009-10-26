class CreateEditableContent < ActiveRecord::Migration
  def self.up
    create_table :editable_contents do |t|
      t.string :name
      t.text :content
      t.integer :user_id
      t.timestamps
    end
    add_index(:editable_contents, :name)
  end

  def self.down
    drop_table :editable_contents
  end
end