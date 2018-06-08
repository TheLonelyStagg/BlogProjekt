class TagsController < ApplicationController
  def index
    @tags = Tag.all
    respond_to do |format|
        format.html # index.html.erb
        format.xml {render :xml =>@tags}
    end
    end

end
