class ApiController < ApplicationController
  def search
    return if params[:query].blank?
    @reg_number = SearchResult.run(params[:query])
    
    respond_to do |format|
      format.html
      format.json { render :json => output.to_json }
      format.xml  { render :xml  => output.to_xml(:root => 'result', :skip_instruct => true) }
    end
  end
  
  private
  
  def output
    number, company = @reg_number.try :split, '|'
    {
      :success    => (!!@reg_number).to_s,
      :reg_number => number      || 'Not found' ,
      :company    => company     || 'Not found' 
    }
  end
end