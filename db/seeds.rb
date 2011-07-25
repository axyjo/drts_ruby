# Terrains:
Terrain.create(name: "Plains", blue_value: 0)
Terrain.create(name: "Forest", blue_value: 1)
Terrain.create(name: "Hills", blue_value: 2)
Terrain.create(name: "Mountains", blue_value: 3)
Terrain.create(name: "Impassable Mountains", blue_value: 4)
Terrain.create(name: "Desert", blue_value: 5)
Terrain.create(name: "Tundra", blue_value: 6)
Terrain.create(name: "Swamp", blue_value: 7)
Terrain.create(name: "River", blue_value: 8)
Terrain.create(name: "Ocean/Sea", blue_value: 255)

# Coordinates:
for x in 1..Rails.configuration.game[:gameSize]
  # Use a transaction to speed things up.
  ActiveRecord::Base.transaction do
    for y in 1..Rails.configuration.game[:gameSize]
      Coordinate.create(lat: x, lng: y)
    end
  end
end
