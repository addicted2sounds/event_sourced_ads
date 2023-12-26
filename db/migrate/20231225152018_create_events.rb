class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :stream_name
      t.string :event_type
      t.jsonb :data

      t.timestamps
    end
  end
end
