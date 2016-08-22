class CreateVerifyQueues < ActiveRecord::Migration[5.0]
  def change
    create_table :verify_queues do |t|
      t.integer :verify_type
      t.integer :user_id
      t.string :title
      t.string :image
      t.integer :verify_status
      t.string :message

      t.timestamps
    end
  end
end
