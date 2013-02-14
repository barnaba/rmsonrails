class Attendee < ActiveRecord::Base
  #todo nazwy kolumn małą literą
  attr_accessible :Email, :Surname, :kotik_mailing, :name

  validates_presence_of :Surname, :name
  validates_format_of :Email, with: /@/
end
