class CreateAttendees < ActiveRecord::Migration
  def change
    create_table :attendees do |t|
      t.string :name
      t.string :Surname
      t.string :Email
      t.boolean :kotik_mailing

      t.timestamps
    end
  end
end
