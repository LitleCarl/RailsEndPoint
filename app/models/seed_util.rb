class SeedUtil
  def self.generate
    start_time = Time.now - 6.hours

    (6.hours).times.each do |i|
      current_time = start_time + i.seconds

      Student.first(6).each do |student|
        station = Station.offset(rand(Station.count)).first
        Track.create_with_options({
                                      station_device_id: station.device_id,
                                      bracelet_device_id: student.device_id,
                                      location: station.location,
                                      created_at: current_time
                                  })
      end
    end
  end
end