class Station
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes[:id]
  end

  define_method(:==) do |another_station|
    self.id() == another_station.id() && self.name() == another_station.name()
  end

  define_singleton_method(:all) do
    stations = []
    returned_stations = DB.exec("SELECT * FROM stations;")
    returned_stations.each() do |station|
      name = station.fetch("name")
      id = station.fetch("id").to_i()
      stations.push(Station.new({ :name => name, :id => id }))
    end
    stations
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO stations (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name)
    DB.exec("UPDATE stations SET name = '#{@name}' WHERE id = #{self.id()};")
  end

  define_method(:delete) do
    DB.exec("DELETE FROM stations WHERE id = #{self.id()};")
  end

  define_method(:add_line) do |line|
    existing_connection = DB.exec("SELECT * FROM stops WHERE line_id = #{line.id()} AND station_id = #{self.id()};")
    if ! existing_connection.first()
      DB.exec("INSERT INTO stops (line_id, station_id) VALUES (#{line.id()}, #{self.id()});")
    end
  end

  # removes connection, not actual line or station
  define_method(:remove_line) do |line|
    DB.exec("DELETE FROM stops WHERE station_id = #{self.id()} AND line_id = #{line.id()};")
  end

  define_method(:lines) do
    lines = []
    returned_line_ids = DB.exec("SELECT line_id FROM stops WHERE station_id = #{self.id()};")
    returned_line_ids.each() do |line_id_hash|
      line_id = line_id_hash.fetch('line_id').to_i()
      returned_line = DB.exec("SELECT * FROM lines WHERE id = #{line_id};")
      name = returned_line.first().fetch('name')
      id = returned_line.first().fetch('id').to_i()
      lines.push(Line.new({:name => name, :id => id}))
    end
    lines
  end

  define_singleton_method(:find) do |id|
    Station.all().each() do |station|
      if station.id() == id
        return station
      end
    end
  end

end
