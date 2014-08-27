class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.string :email
      t.string :name
      t.string :keyword
      t.string :city
      t.string :state
      t.column :data, :json

      t.timestamps
    end
  end
end
