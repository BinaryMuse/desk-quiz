class StaticController < ApplicationController
  # All non-API requests render the single-page app
  def show
    render nothing: true, layout: true
  end
end
