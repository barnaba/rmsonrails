class StatsController < ApplicationController
  layout false
  def index
    attendees = Attendee.all
    @stats = stats
    @mailing_stats = mailing_stats
    max_cap = 300
    @capacity = [{x: Attendee.first.created_at.to_i, y: 300}, {x: Time.now.to_i, y: 300}]
    @date_stats = date_stats
    add_last_day_if_needed
    @daily_subs = Marshal.load(Marshal.dump(date_stats));
    @daily_subs.each do |tuple|
      Rails.logger.error tuple[:x].class.to_s
      tuple[:x] = (Date.parse(tuple[:x]).to_datetime + 12.hours).to_i
      tuple[:y] = tuple[:y].to_i
    end
    respond_to do |format|
      format.html
    end
  end

private
  def add_last_day_if_needed
    if Date.parse(@date_stats.last[:x]) != Date.today
      @date_stats << {x: Date.today.to_s, y: 0}
    end
  end

  def date_stats
    res = ActiveRecord::Base.connection.execute('select created_at::timestamp::date, count(*) from attendees group by created_at::timestamp::date order by created_at ASC;')
    res.map{|tuple| {x: tuple['created_at'], y: tuple['count']}}
  end

  def stats
    res = ActiveRecord::Base.connection.execute('select created_at, (select count(*) from attendees as b where b.created_at <= attendees.created_at) as count from attendees order by created_at asc;')
    res.map{|tuple| {x: Time.parse(tuple['created_at'] + " UTC").to_i, y: tuple['count'].to_i}}
  end

  def mailing_stats
    res = ActiveRecord::Base.connection.execute('select created_at, (select count(*) from attendees as b where b.created_at <= attendees.created_at and b.kotik_mailing = true) as count from attendees where attendees.kotik_mailing = true order by created_at asc;')
    res.map{|tuple| {x: Time.parse(tuple['created_at'] + " UTC").to_i, y: tuple['count'].to_i}}
  end
end