# frozen_string_literal: true

class MapData
  def initialize(initiatives)
    @initiatives = initiatives.map(&:to_public_initiative)
    @center = find_center(initiatives)
  end

  private

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def find_center(initiatives)
    number_of_locations = initiatives.length

    return [initiatives.first.latitude, initiatives.first.longitude] if number_of_locations == 1

    x = y = z = 0.0
    initiatives.each do |initiative|
      latitude = initiative.latitude * Math::PI / 180
      longitude = initiative.longitude * Math::PI / 180

      x += Math.cos(latitude) * Math.cos(longitude)
      y += Math.cos(latitude) * Math.sin(longitude)
      z += Math.sin(latitude)
    end

    x /= number_of_locations
    y /= number_of_locations
    z /= number_of_locations

    central_longitude = Math.atan2(y, x)
    central_square_root = Math.sqrt(x * x + y * y)
    central_latitude = Math.atan2(z, central_square_root)

    [central_latitude * 180 / Math::PI, central_longitude * 180 / Math::PI]
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
