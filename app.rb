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

post("/stations") do
  station_name = params.fetch('station_name')
  new_station = Station.new({ :name => station_name })
  new_station.save()
  redirect("/admin")
end

delete("/stations") do
  station_id = params.fetch('station_id').to_i()
  Station.find(station_id).delete()
  redirect("/admin")
end

post("/lines") do
  line_name = params.fetch('line_name')
  new_line = Line.new({ :name => line_name })
  new_line.save()
  redirect("/admin")
end

delete("/lines") do
  line_id = params.fetch('line_id').to_i()
  Line.find(line_id).delete()
  redirect("/admin")
end

post("/lines/:line_id") do
  line_id = params.fetch('line_id').to_i()
  station_id = params.fetch('station_id').to_i()
  line = Line.find(line_id)
  station = Station.find(station_id)
  station.add_line(line)
  url = "/admin/lines/" + line_id.to_s()
  redirect(url)
end

post("/stations/:station_id") do
  line_id = params.fetch('line_id').to_i()
  station_id = params.fetch('station_id').to_i()
  line = Line.find(line_id)
  station = Station.find(station_id)
  line.add_station(station)
  url = "/admin/stations/" + station_id.to_s()
  redirect(url)
end

delete("/stations/:station_id") do
  line_id = params.fetch('line_id').to_i()
  station_id = params.fetch('station_id').to_i()
  Station.find(station_id).remove_line(Line.find(line_id))
  url = "/admin/stations/" + station_id.to_s()
  redirect(url)
end

delete("/lines/:line_id") do
  line_id = params.fetch('line_id').to_i()
  station_id = params.fetch('station_id').to_i()
  Line.find(line_id).remove_station(Station.find(station_id))
  url = "/admin/lines/" + line_id.to_s()
  redirect(url)
end

# --
#
# get('/stations')
# post('/stations')
#
# get('/stations/:id') {}
# delete('/stations/:id')
# patch('/stations/:id')
