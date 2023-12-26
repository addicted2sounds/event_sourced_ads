class CreateAds < ActiveRecord::Migration[7.1]
  def change
    create_table :ads, id: :uuid do |t|
      t.string :title
      t.string :body
      t.string :status

      t.timestamps
    end
  end
end
