class BattlesController < ApplicationController
  
  # Call battle() to run a battle. For now, battles are instantaneous
  # and result in the extermination of the losing army.
  # Refinement will take place later.

  # Sum of intended attribute

  def sum(army, a)
    d = 0
    army.each do |i|
      d = d + i[a]
    end
    d
  end

  # Updates database depending on result of battle

  def resolve(id, s)
    if s == 0
      Army.find(id).destroy
    elsif s > 0
      s_unit = (s.to_i)/(Army.find(id).units.count.to_i)
      Army.find(id).units.each do |u|
        if u[:size] <= s_unit
          u.destroy
        else
          u.update_attributes(:size => u[:size]-s_unit)
      end
    end  
  end

  # Calculates result of battle.

  def battle(id_a, id_b)
    army_a = Army.find(id_a).units
    army_b = Army.find(id_b).units
    d_a = sum(army_a, :defense)
    d_b = sum(army_b, :defense)
    o_a = sum(army_a, :offense)
    o_b = sum(army_b, :offense)
    a_0 = sum(army_a, :size)
    b_0 = sum(army_b, :size)
    t_a = (a_0 * d_a) / o_b
    t_b = (b_0 * d_b) / o_a
    if t_a < t_b
      survivors = b_0 - (t_a * (o_a / d_b))
      resolve(id_a, 0)
      resolve(id_b, survivors)
    elsif t_b < t_a
      survivors = a_0 - (t_b * (o_b / d_a))
      resolve(id_a, survivors)
      resolve(id_b, 0)
    elsif t_b == t_a
      resolve(id_a, 0)
      resolve(id_b, 0)
    end
  end
end