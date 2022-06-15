require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock and Sofia"

  erb :home
end

# get "/test" do
# end

get "/chapters/:number" do
  number = params[:number].to_i

  redirect "/" unless (1..12).cover?(number)

  @title = display_chp_num_and_name(number)
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/search" do
  erb :search
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |par, ind|
      id = "par_num#{ind}"
      "<p id=#{id}>#{par}</p>"
    end.join
  end

  def find_in_all_text(query)
    selected = (1..12).select do |num| 
      File.read("data/chp#{num}.txt").include?(query)
    end
    selected unless selected.empty?
  end

  def each_paragraph(num)
    query = params[:query]
    contents = File.read("data/chp#{num}.txt").split("\n\n")
    contents.each_with_index do |par, ind|
      yield(par, ind) if par.include?(query) && block_given?
    end
  end

  def display_chp_num_and_name(num)
    "Chapter #{num}: #{@contents[num - 1]}"
  end
end



