class TemplatesController < ApplicationController
  before_filter do
    # Templates should always be sent as HTML, even though
    # Angular sends application/json as a valid type
    response.headers["Content-Type"] = 'text/html'
  end

  def show
    render "templates/#{params[:template]}", layout: false
  end
end
