# encoding: utf-8
class SearchResult
  
  BASE_URL = 'http://www.allabolag.se/?what='
  
  @@logger = Logger.new(File.join(Rails.root, 'log/results.log'))
  
  class << self
    def run(query)
      @query = query.downcase
      return read if read
      
      agent = Mechanize.new
      agent.user_agent = 'Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'
      @page = agent.get(SearchResult::BASE_URL + URI.encode(@query))
      
      if result_found
        @@logger.info "New company found -- query: #{@query}, company_name: #{@company_name}, reg. code: #{@reg_number}"
        write
      else
        @@logger.info "Search returned no results -- query: #{@query}"
        File.open(File.expand_path('log/response_with_errors.html', Rails.root), 'w'){|f| f.write(@page.body.force_encoding('UTF-8')) }
        nil
      end
    end
  
    def read
      Rails.cache.read @query
    end
  
    def write
      Rails.cache.write @query, @reg_number
      @reg_number
    end
    
    def result_found
      return if @page.at('td.text16red')   #error message
      @company_name = @page.at('h2.hitlistLink').children.first.content
      @reg_number   = @page.at('td.text11grey6').to_s.match(/(\d+-\d+)/)[1]
      !!@company_name.downcase.match(@query)
    end
    
  end
end