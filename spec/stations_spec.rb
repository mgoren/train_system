require('spec_helper')

describe(Station) do

  describe('#==') do
    it("returns as equal when stations names and IDs match") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      station1_from_db = Station.all().first()
      expect(station1).to(eq(station1_from_db))
    end
  end

  describe('.all') do
    it("returns empty at first") do
      expect(Station.all()).to(eq([]))
    end
  end

  describe('#save') do
    it("saves station into db") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      expect(Station.all()).to(eq([station1]))
    end
  end

  describe('#update') do
    it("will update the name of a station") do
      test_station = Station.new({ :name => "Times Square" })
      test_station.save()
      test_station.update({:name => "Union Square"})
      expect(test_station.name()).to(eq("Union Square"))
    end
  end

  describe("#delete") do
    it("lets you delete a station from the database") do
      test_station = Station.new({ :name => "Times Square"})
      test_station.save()
      test_station2 = Station.new({ :name => "Union Square"})
      test_station2.save()
      test_station.delete()
      expect(Station.all()).to(eq([test_station2]))
    end
  end

  describe('#lines') do
    it("returns array of lines that pass through this station") do
      station1 = Station.new({ :name => "Times Square"})
      station1.save()
      line1 = Line.new({ :name => "Q"})
      line1.save()
      line2 = Line.new({ :name => "R"})
      line2.save()
      station1.add_line(line1)
      station1.add_line(line2)
      expect(station1.lines()).to(eq([line1, line2]))
    end

    it("correctly associates lines and stations") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      station2 = Station.new({ :name => "Union Square" })
      station2.save()
      line1 = Line.new({ :name => "Q"})
      line1.save()
      line2 = Line.new({ :name => "R"})
      line2.save()
      station1.add_line(line1)
      station2.add_line(line1)
      expect(line1.stations()).to(eq([station1, station2]))
    end

    it("avoids duplicates in stops table") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      station2 = Station.new({ :name => "Union Square" })
      station2.save()
      line1 = Line.new({ :name => "Q"})
      line1.save()
      line2 = Line.new({ :name => "R"})
      line2.save()
      station1.add_line(line1)
      station2.add_line(line1)
      line1.add_station(station1)
      expect(line1.stations()).to(eq([station1, station2]))
    end

    it("avoids duplicates in stops table (another test)") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      station2 = Station.new({ :name => "Union Square" })
      station2.save()
      line1 = Line.new({ :name => "Q"})
      line1.save()
      line2 = Line.new({ :name => "R"})
      line2.save()
      station1.add_line(line1)
      station2.add_line(line1)
      line1.add_station(station1)
      line2.add_station(station1)
      line1.add_station(station1)
      expect(station1.lines()).to(eq([line1, line2]))
    end
  end

  describe('#remove_line') do
    it("removes connection entry from stops table") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      station2 = Station.new({ :name => "Union Square" })
      station2.save()
      line1 = Line.new({ :name => "Q"})
      line1.save()
      line2 = Line.new({ :name => "R"})
      line2.save()
      station1.add_line(line1)
      station1.add_line(line2)
      station1.remove_line(line1)
      expect(station1.lines()).to(eq([line2]))
    end
  end

end
