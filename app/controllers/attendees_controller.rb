class AttendeesController < ApplicationController
  before_filter :registration_enabled, :only => ['create', 'new']
  caches_action :new, layout: false
  # GET /attendees
  # GET /attendees.json
  def index
    @attendees = Attendee.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attendees }
    end
  end

  # GET /attendees/new
  # GET /attendees/new.json
  def new
    @attendee = Attendee.new
    @registration_in_progress = false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attendee }
    end
  end

  # POST /attendees
  # POST /attendees.json
  def create

    unless @registration_enabled
      redirect_to root_path
      return
    end

    @attendee = Attendee.new(params[:attendee])
    @attendee.valid?

    respond_to do |format|
      if verify_recaptcha(model: @attendee) && @attendee.save
        format.html { redirect_to root_path, notice: t('notice.registration.success')}
        format.json { render json: @attendee, status: :created, location: @attendee }
      else
        @registration_in_progress = @attendee.errors.keys.any?
        format.html { render action: "new" }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end
  end

  def resign
    @attendee = Attendee.find(params[:id])
    token = params[:token]
    if @attendee.token_valid? token
      @attendee.resign
    end
  end

  private

  def registration_enabled
    @registration_enabled = Date.today() >= Date.parse("01/03/2013") || Rails.env == "development"
  end
end
