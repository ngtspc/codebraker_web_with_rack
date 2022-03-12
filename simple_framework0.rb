require 'erb'
require_relative 'codebraker'
require_relative 'datahandler'

class SimpleFramework
  @@warehouse = []
  @@attempts = 0
  @@i = 0
  @@current_number = 0

  def self.call(env)
    new(env).response
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/"
      response = Rack::Response.new(render("start.html.erb"))
      @@warehouse = DataHandler.default_setting(@request)
    when "/set_att"
      response = Rack::Response.new(render("visual_attempts.html.erb"))
    when "/get_att"
      response = Rack::Response.new(@request.params["attempts"])
        @@attempts = @request.params["attempts"].to_i
      response.redirect("/set_num")
    when "/set_num"
      response = Rack::Response.new(render("visual_number.html.erb"))
    when "/get_num"
        response = Rack::Response.new(@request.params["number"])
        @right_number = wrong_input_check
        if @right_number
          @@current_number = @request.params["number"].to_i 
          if @request.params["number"].to_i > 0
            SimpleFramework.check(@request.params["number"].to_i, current_attempts)
            DataHandler.add(@request, "numbers", @request.params["number"].to_i)
            DataHandler.add(@request, "masks", SimpleFramework.check(@request.params["number"].to_i, current_attempts))
          end
          @hiden_number = @@warehouse["masks"].find{|mask| mask == '++++'}
          response.redirect("/set_num")
          @@attempts -= 1
        else
          response = Rack::Response.new(render("visual_number.html.erb"))
        end

    when "/game"
        response = Rack::Response.new(render("game.html.erb"))
    else
      response = Rack::Response.new("Not found", 404)
    end
    @@warehouse = DataHandler.session(@request)
    response.finish
  end

  def redirect(address = '')
    Rack::Response.new { |response| response.redirect("/#{address}") }
  end

  def self.check(number, attempts)
    @@codebraker ||= Codebraker.new(number, attempts)
    @@codebraker.compare(number)
  end

  def wrong_input_check
    status = true
    if (@request.params["number"].to_i).to_s.length != 4
      status = false
    end
    status
  end
  
  def self.attempts
    @@attempts
  end

  def self.warehouse
    @@warehouse
  end

  def self.current_number
    @@current_number
  end
end

def render(file_name)
  path = File.expand_path("../views/#{file_name}", __FILE__)
  ERB.new(File.read(path)).result(binding)  
end

def your_number
  @request.params["number"].to_i
end

def current_attempts
  @request.params["attempts"]
end
