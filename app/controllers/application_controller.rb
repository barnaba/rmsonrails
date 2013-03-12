#encoding: utf-8
require 'net/http'
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :stream_active?

  def stream_active?
    begin
      url = URI.parse('http://brama.elka.pw.edu.pl/stream/606')
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
      }
      active = !(res.body =~ /Strumieniowanie jeszcze nie rozpocz/)
      puts active.inspect
      @stream_active = active
    rescue
      @stream_active = false
    end
  end
end
