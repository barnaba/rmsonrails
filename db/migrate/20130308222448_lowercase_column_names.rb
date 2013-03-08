class LowercaseColumnNames < ActiveRecord::Migration
  def up
    rename_column :attendees, :Surname, :surname
    rename_column :attendees, :Email, :email
  end

  def down
    rename_column :attendees, :surname, :Surname
    rename_column :attendees, :email, :Email
  end
end
