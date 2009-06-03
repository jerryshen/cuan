# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
   #get json data
    def render_json records,total
    json_texts = []
    records.to_a.each{|cat|json_texts << cat.attributes.to_json}
    return "{'count':#{total},'rows':[#{json_texts.join(",")}]}"
  end
end
