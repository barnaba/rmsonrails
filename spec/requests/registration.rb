require "spec_helper"
include ActionView::Helpers::SanitizeHelper 

describe "registration" do
  MAX_SEATS = 7
  MAX_ATTENDEES = 13

  before (:all) do
    APP_CONFIG['max_seats'] = MAX_SEATS
    APP_CONFIG['max_attendees'] = MAX_ATTENDEES
  end

  def create_n_attendees(n)
    n.times do |i|
      a = Attendee.create :email => "#{i}@gmail.com", :name => i.to_s
      a.registration_type = a.registration_type
      a.save!
    end
  end

  it "Allows registration when attendee is valid" do
    get "/attendees/new"
    assert_response(:success)
    post "/attendees", :attendee => {email: "test@test", registration_type: "seated"}
    assert_redirected_to root_path
  end

  it "Notifies the user when he attempts seated registration, but all the seats are taken" do
    create_n_attendees(MAX_SEATS)
    post "/attendees", :attendee => {email: "test@test", registration_type: "seated"}
    assert_response(:success)
    assert_select("#error_explanation")
    post "/attendees", :attendee => {email: "test@test", registration_type: "standing"}
    assert_redirected_to root_path
  end

end
