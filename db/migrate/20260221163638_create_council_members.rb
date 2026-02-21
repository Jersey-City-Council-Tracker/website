class CreateCouncilMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :council_members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :seat, null: false
      t.date :term_start, null: false
      t.date :term_end

      t.timestamps
    end

    add_index :council_members, :last_name
  end
end
