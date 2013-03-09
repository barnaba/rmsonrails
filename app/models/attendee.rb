#encoding: utf-8
#include Rails.application.routes.url_helpers

class Attendee < ActiveRecord::Base
  #todo nazwy kolumn małą literą
  attr_accessible :email, :surname, :kotik_mailing, :name, :registration_type
  attr_accessor :registration_type

  default_scope order('created_at ASC')

  validates_format_of :email, with: /@/
  validates_uniqueness_of :email
  validate :registration_open?
  validate :registration_type_hasnt_changed

  after_create :generate_resignation_token

  def resign
      self.resigned = true
      save
  end

  def token_valid?(token)
    token == self.resignation_token
  end

  def registration_type
    Attendee.registration_type
  end

  def registration_type=(original)
    @original_registration_type = original
  end

  def has_resigned?
    self.resigned
  end

  def actual_registration_type
    attendee_ord = Attendee.where('id < ?', self.id).count
    if attendee_ord < Attendee.max_seats
      "seated"
    elsif attendee_ord < Attendee.max_attendees
      "standing"
    else
      "closed"
    end
  end

class << self
  def growing?
    today = Attendee.where('created_at >= ?', Date.today.to_time).count
    yesterday = Attendee.where('created_at >= ? and created_at < ?', Date.yesterday.to_time, Time.now - 1.day).count
    begin
      [today > yesterday, "#{((today * 1.0)/yesterday * 100).round}%"]
    rescue
      [today > yesterday, "∞"]
    end
  end

  def registration_available?
    Attendee.count < Attendee.max_attendees
  end

  def seats_available?
    Attendee.count < Attendee.max_seats
  end

  def max_attendees
    APP_CONFIG['max_attendees']
  end

  def max_seats
    APP_CONFIG['max_seats']
  end
  
  def registration_type
    if Attendee.seats_available?
      "seated"
    elsif Attendee.registration_available?
      "standing"
    else
      "closed"
    end
  end
end


  protected

  def registration_type_hasnt_changed
    if @original_registration_type != registration_type
      errors[:base] << I18n.t('registration.changed')
    end
  end

  def registration_open?
    unless Attendee.registration_available?
      errors[:base] << I18n.t('registration.closed')
    end
  end

  def generate_resignation_token
    begin
      token = SecureRandom.urlsafe_base64
    end while Attendee.where(:resignation_token => token).exists?
    self.resignation_token = token
    self.save
  end


end
