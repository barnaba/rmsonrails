#encoding: utf-8
#include Rails.application.routes.url_helpers

class Attendee < ActiveRecord::Base
  #todo nazwy kolumn małą literą
  attr_accessible :Email, :Surname, :kotik_mailing, :name

  default_scope order('created_at ASC')

  validates_format_of :Email, with: /@/
  validates_uniqueness_of :Email

  after_create :generate_resignation_token

  def resign
      self.resigned = true
      save
  end

  def ord 
    Attendee.where('created_at < ?', self.created_at).count
  end

  def mailing_ord 
    Attendee.where('created_at < ? and kotik_mailing = true', self.created_at).count
  end

  def token_valid?(token)
    token == self.resignation_token
  end

  def has_resigned?
    self.resigned
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
