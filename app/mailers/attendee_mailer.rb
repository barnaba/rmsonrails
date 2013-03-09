#encoding: utf-8
class AttendeeMailer < ActionMailer::Base
  default from: "rejestracja@rms2013.pl"

  def registration_email(attendee)
    @name= attendee.name
    @email = attendee.email
    @registration_type = attendee.actual_registration_type
    @registration_type_text = case @registration_type
                              when "seated"
                                "Miejsce siedzące"
                              when "standing"
                                "Miejsce stojące"
                              end
    mail(to: attendee.email, subject: "Potwierdzenie rejestracji na wykład Richarda Stallmana", content_type: "text/plain")
  end
end
