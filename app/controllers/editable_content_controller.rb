class EditableContentController < ApplicationController
  # see - http://dev.rubyonrails.org/ticket/6001
  unloadable

  def update
    return unless logged_in? and current_user.admin?
    
    content = EditableContent.find_by_name(params[:id])
    content.update_attributes(params[:editable_content])
    render :update do |page| 
      page << "savedEditArea('#{content.name}');"
    end
  end
end