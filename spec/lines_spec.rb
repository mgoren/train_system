require('spec_helper')

describe(Line) do

  describe('#==') do
    it("returns as equal when line names and IDs match") do
      q1 = Line.new({ :name => "Q" })
      q1.save()
      q1_from_db = Line.all().first()
      expect(q1).to(eq(q1_from_db))
    end
  end

  describe('.all') do
    it("returns empty at first") do
      expect(Line.all()).to(eq([]))
    end
  end

  describe('#save') do
    it("saves line into db") do
      q1 = Line.new({ :name => "Q" })
      q1.save()
      expect(Line.all()).to(eq([q1]))
    end
  end

  describe('#update') do
    it("will update the name of a line") do
      test_line = Line.new({ :name => "Q" })
      test_line.save()
      test_line.update({:name => "W"})
      expect(test_line.name()).to(eq("W"))
    end
  end

  describe("#delete") do
    it("lets you delete a list from the database") do
      test_line = Line.new({ :name => "Q"})
      test_line.save()
      test_line2 = Line.new({ :name => "R"})
      test_line2.save()
      test_line.delete()
      expect(Line.all()).to(eq([test_line2]))
    end
  end

  describe('#stations') do
    it("returns array of stations this line passes through") do
      line1 = Line.new({ :name => "Q"})
      line1.save()
      station1 = Station.new({ :name => "Times Square"})
      station1.save()
      station2 = Station.new({ :name => "Union Square"})
      station2.save()
      line1.add_station(station1)
      line1.add_station(station2)
      expect(line1.stations()).to(eq([station1, station2]))
    end
  end

  describe('#remove_station') do
    it("removes connection entry from stops table") do
      station1 = Station.new({ :name => "Times Square" })
      station1.save()
      station2 = Station.new({ :name => "Union Square" })
      station2.save()
      line1 = Line.new({ :name => "Q"})
      line1.save()
      line2 = Line.new({ :name => "R"})
      line2.save()
      line1.add_station(station1)
      line1.add_station(station2)
      line1.remove_station(station1)
      expect(line1.stations()).to(eq([station2]))
    end
  end
  
end
