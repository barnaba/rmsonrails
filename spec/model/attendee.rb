require 'spec_helper'


describe "registration" do
  MAX_SEATS = 7
  MAX_ATTENDEES = 13

  def create_n_attendees(n)
    n.times do |i|
      a = Attendee.create :email => "#{i}@gmail.com", :name => i.to_s, registration_type: Attendee.registration_type
      a.save()
    end
  end

  before (:all) do
    APP_CONFIG['max_seats'] = MAX_SEATS
    APP_CONFIG['max_attendees'] = MAX_ATTENDEES
  end

  it "doesn't allow attendee to register if the attendee limit is reached" do
    create_n_attendees(MAX_ATTENDEES)
    a = Attendee.create email: "too_many_attendees@gmail.com", name: "oops"
    a.save.should == false
    a.errors.should_not be_empty
    Attendee.count.should == MAX_ATTENDEES
  end

  it "allows attendees to register" do
    create_n_attendees(MAX_ATTENDEES)

    Attendee.count.should == MAX_ATTENDEES
  end

  it "correctly reports actual registration type for seated guests" do
    create_n_attendees(MAX_SEATS - 1)

    a = Attendee.create :email => "seated@gmail.com", registration_type: Attendee.registration_type

    a.actual_registration_type.should == "seated"
  end

  it "correctly reports actual registration type for standing guests" do
    create_n_attendees(MAX_SEATS)

    a = Attendee.create :email => "standing@gmail.com", registration_type: Attendee.registration_type

    a.actual_registration_type.should == "standing"
  end
end

