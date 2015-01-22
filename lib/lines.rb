class Line
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes[:id]
  end

  define_method(:==) do |another_line|
    self.id() == another_line.id() && self.name() == another_line.name()
  end

  define_singleton_method(:all) do
    lines = []
    returned_lines = DB.exec("SELECT * FROM lines ORDER BY name;")
    returned_lines.each() do |line|
      name = line.fetch("name")
      id = line.fetch("id").to_i()
      lines.push(Line.new({ :name => name, :id => id }))
    end
    lines
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO lines (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name)
    @id = self.id()
    DB.exec("UPDATE lines SET name = '#{@name}' WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE FROM stops WHERE line_id = #{self.id()};")
    DB.exec("DELETE FROM lines WHERE id =#{self.id()};")
  end

  define_method(:add_station) do |station|
    existing_connection = DB.exec("SELECT * FROM stops WHERE line_id = #{self.id()} AND station_id = #{station.id()};")
    if ! existing_connection.first()
      DB.exec("INSERT INTO stops (line_id, station_id) VALUES (#{self.id()}, #{station.id()});")
    end
  end

  define_method(:stations) do
    stations = []
    returned_station_ids = DB.exec("SELECT station_id FROM stops WHERE line_id = #{self.id()};")
    returned_station_ids.each() do |station_id_hash|
      station_id = station_id_hash.fetch('station_id').to_i()
      returned_station = DB.exec("SELECT * FROM stations WHERE id = #{station_id};")
      name = returned_station.first().fetch('name')
      id = returned_station.first().fetch('id').to_i()
      stations.push(Station.new({:name => name, :id => id}))
    end
    stations.sort!{ |a,b| a.name.downcase <=> b.name.downcase }
  end

  # removes connection, not actual line or station
  define_method(:remove_station) do |station|
    DB.exec("DELETE FROM stops WHERE line_id = #{self.id()} AND station_id = #{station.id()};")
  end

  define_singleton_method(:find) do |id|
    Line.all().each() do |line|
      if line.id() == id
        return line
      end
    end
  end


end
