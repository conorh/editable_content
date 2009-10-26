module EditableContentHelper
  def editable_content(name, &block)
    editable_content = capture(&block)

    unless page = EditableContent.find_by_name(name)
      page = EditableContent.create(:name => name, :content => editable_content)
    end
    
    edit_link = nil
    if logged_in? and current_user.admin?
      edit_link = "<script>
        var originalText = null;
        
        function makeEditArea(name) {
          var width = $('#editable_content_' + name).width();
          if(width <= 10) { // Chrome/Safari return 0 for this for some reason
            width = $('#editable_content_' + name).parent().width();
          }
          var height = $('#editable_content_' + name).height();
          if(height <= 10) {
            height = $('#editable_content_' + name).parent().height();
          }
          
          var style = '\"width:' + width + 'px; height:' + height + 'px;\"';
          originalText = $('#editable_content_' + name).html();
          $('#editable_content_' + name).html('<form id=\"editable_content_' + name + '_form\"><textarea name=\"editable_content[content]\" id=\"editable_content_' + name + '_textarea\" style=' + style + '>' +  $('#editable_content_' + name).html() + '</textarea></form>');
          $('#editable_content_' + name + '_edit').hide();
          $('#editable_content_' + name + '_save').show();
          $('#editable_content_' + name + '_preview').html('Preview');
        }
        
        function cancelEditArea(name) { hideEditArea(name, true); }
        function savedEditArea(name) { hideEditArea(name, false); }
        function hideEditArea(name, cancel) {
          if(cancel) {
            text = originalText;
          } else {
            text = $('#editable_content_' + name + '_textarea').val();
          }
          $('#editable_content_' + name).html(text);
          $('#editable_content_' + name + '_edit').show();
          $('#editable_content_' + name + '_save').hide();
        }
        
        var formText = null;
        function previewEditArea(name) {
          if(formText != null) {
            $('#editable_content_' + name).html(formText);
            $('#editable_content_' + name + '_preview').html('Preview');
            formText = null;
          } else {
            formText = $('#editable_content_' + name).html();
            newText = $('#editable_content_' + name + '_textarea').val();
            $('#editable_content_' + name).html(newText);
            $('#editable_content_' + name + '_preview').html('Edit');
          }
        }
      </script>
      <div style='float: right'>
        <div id='editable_content_#{name}_edit'><a href='#' onclick='makeEditArea(\"#{name}\"); return false;'>Edit</a></div>
        <div id='editable_content_#{name}_save' style='display: none;'>
          #{link_to_remote 'Save', :url => {:controller => 'editable_content', :action => 'update', :id => name}, :submit => "editable_content_#{name}_form"}
          | <a href='#' onclick='cancelEditArea(\"#{name}\"); return false;'>Cancel</a>
          | <a id='editable_content_#{name}_preview' href='#' onclick='previewEditArea(\"#{name}\"); return false;'>Preview</a>
        </div>
      </div>"     
    end
    
    concat("#{edit_link}<span id='editable_content_#{name}'>" + page.content + "</span>", block.binding)
  end
end