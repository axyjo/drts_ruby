# Terrains:
Terrain.create(name: "Plains", blue_value: 0, cost: 1)
Terrain.create(name: "Forest", blue_value: 1, cost: 1.5)
Terrain.create(name: "Hills", blue_value: 2, cost: 5)
Terrain.create(name: "Mountains", blue_value: 3, cost: 7)
Terrain.create(name: "Impassable Mountains", blue_value: 4, cost: -1)
Terrain.create(name: "Desert", blue_value: 5, cost: -1)
Terrain.create(name: "Tundra", blue_value: 6, cost: -1)
Terrain.create(name: "Swamp", blue_value: 7, cost: -1)
Terrain.create(name: "River", blue_value: 8, cost: -1)
Terrain.create(name: "Ocean/Sea", blue_value: 255, cost: -1)

# Coordinates:
base_path = Rails.root.join('app', 'assets', 'images', 'map')
terrain = ChunkyPNG::Image.from_file(base_path.join('terrain.png'))
political = ChunkyPNG::Image.from_file(base_path.join('political.png'))
masses = ChunkyPNG::Image.from_file(base_path.join('masses.png'))

for x in 1..Rails.configuration.game[:gameSize]
  # Use a transaction to speed things up.
  ActiveRecord::Base.transaction do
    for y in 1..Rails.configuration.game[:gameSize]
      # Determine the terrain.
      blue = ChunkyPNG::Color.b(terrain.get_pixel(x-1, y-1))
      t = Terrain.find_by_blue_value(blue)

      # Determine the empire.
      empire_id = ChunkyPNG::Color.r(political.get_pixel(x-1, y-1))
      if empire_id == 0
        e = nil
        e_id = nil
      else
        e = Empire.find_or_create_by_id(empire_id)
        e_id = e.id
      end

      # Determine the province.
      province_g = ChunkyPNG::Color.g(political.get_pixel(x-1, y-1))
      province_b = ChunkyPNG::Color.b(political.get_pixel(x-1, y-1))
      province_id = province_g * 255 + province_b + 1
      p = Province.find_or_create_by_id_and_empire_id(province_id, e_id)

      # Finally, create the coordinate.
      Coordinate.create(lat: x, lng: y, terrain: t, province: p)
    end
  end
end
