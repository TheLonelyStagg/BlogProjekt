class TagsController < ApplicationController
  def index
    @tags = Tag.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml {render :xml =>@tags}
    end
  end

  def destroy
    Tag.find(params[:id]).destroy
    flash[:success] = "Tag usunięto"
    redirect_to tags_path
  end
end
