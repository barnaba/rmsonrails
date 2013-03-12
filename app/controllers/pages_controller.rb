class PagesController < ApplicationController

  caches_page :info, layout:false
  caches_page :streams, :media, :english

  def info
  end

  def streams
  end

  def media
  end

  def english
  end

end
