class KindsController < ApplicationController
  def index
    @rodzaje = Kind.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml =>@rodzaje}
    end
  end

  def destroy
    Kind.find(params[:id]).destroy
    flash[:success] = "Rodzaj usunięto"
    redirect_to kinds_path
  end
end
