class KindsController < ApplicationController
  def index
    @rodzaje = Kind.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml =>@rodzaje}
    end
  end
end
