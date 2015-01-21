require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/stations")
require("./lib/lines")
require("pg")

DB = PG.connect({:dbname => "train_system"})

get("/") do
  erb(:index)
end

get("/stations/:id") do
  @id = params.fetch('id').to_i()
  erb(:station)
end

get("/lines/:id") do
  @id = params.fetch('id').to_i()
  erb(:line)
end

# ADMIN ROUTES

get("/admin") do
  erb(:admin)
end

get("/admin/stations/:id") do
  @id = params.fetch('id').to_i()
  erb(:admin_station)
end

get("/admin/lines/:id") do
  @id = params.fetch('id').to_i()
  erb(:admin_line)
end

post("/edit_stations") do
  station_name = params.fetch('station_name')
  new_station = Station.new({ :name => station_name })
  new_station.save()
  redirect("/admin")
end

post("/edit_lines") do
  line_name = params.fetch('line_name')
  new_line = Line.new({ :name => line_name })
  new_line.save()
  redirect("/admin")
end

post("/edit_line_connection") do
  line_id = params.fetch('line_id').to_i()
  station_id = params.fetch('station_id').to_i()
  line = Line.find(line_id)
  station = Station.find(station_id)
  station.add_line(line)
  url = "/admin/stations/" + station_id.to_s()
  redirect(url)
end

post("/edit_station_connection") do
  line_id = params.fetch('line_id').to_i()
  station_id = params.fetch('station_id').to_i()
  line = Line.find(line_id)
  station = Station.find(station_id)
  line.add_station(station)
  url = "/admin/lines/" + line_id.to_s()
  redirect(url)
end
