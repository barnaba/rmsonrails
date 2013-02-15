class AddResignationToAttendee < ActiveRecord::Migration
  def change
    add_column :attendees, :resignation_token, :string
    add_column :attendees, :resigned, :boolean, :default => false
  end
end
