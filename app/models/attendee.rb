#include Rails.application.routes.url_helpers

class Attendee < ActiveRecord::Base
  #todo nazwy kolumn małą literą
  attr_accessible :Email, :Surname, :kotik_mailing, :name

  validates_format_of :Email, with: /@/
  validates_uniqueness_of :Email

  after_create :generate_resignation_token

  def resign
      self.resigned = true
      save
  end

  def token_valid?(token)
    token == self.resignation_token
  end

  def has_resigned?
    self.resigned
  end

  protected

  def generate_resignation_token
    begin 
      token = SecureRandom.urlsafe_base64
    end while Attendee.where(:resignation_token => token).exists?
    self.resignation_token = token
    self.save
  end

end
