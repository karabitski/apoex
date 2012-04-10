# encoding: utf-8
class SearchResult
  
  BASE_URL = 'http://www.allabolag.se/?what='
  attr_accessor :query, :page, :result
  
  @@logger = Logger.new(File.join(Rails.root, 'log/results.log'))
  
  class << self
    def run(query)
      @query = query.downcase
      return read if read
      
      agent = Mechanize.new
      agent.user_agent = 'Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1'
      @page = agent.get(SearchResult::BASE_URL << @query)

      if result_found
        @@logger.info "New company found -- query: #{@query}, result: #{@result}"
        write
      else
        @@logger.info "Search returned no results -- query: #{@query}"
        nil
      end
    end
  
    def read
      Rails.cache.read @query
    end
  
    def write
      Rails.cache.write @query, @result
    end
    
    def result_found
      @result = @page.at('h2.hitlistLink').children.first.content
      !@page.at('td.text16red') && !!@result.downcase.match(@query.downcase)
    end
    
  end
end