# This file is part of DieRoller.
# Copyright (C) 2016 Igor Padoim
#
# DieRoller is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# DieRoller is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with DieRoller.  If not, see <http://www.gnu.org/licenses/>.

class Dice

  def initialize(seed)
    @rand = Random.new(seed.to_i)
  end

  def parse_string(string)
    dice = []
    i    = 0

    string.gsub(/\d{1,2}d\d{1,3}(\ ?[+-]\ ?\d{1,3})?/) do |d|
      dice[i] = d
      i += 1
    end

    if dice.length < 1
      dice = []
    end
    return dice
  end

  def parse_dice(dice)
    die = {}
    die[:number] = dice[/^\d{1,2}/].to_i
    die[:die]    = dice[/d\d{1,3}/][/\d{1,3}/].to_i
    die[:mod]    = dice[/[+-]\ ?\d{1,3}/].to_s.gsub(" ", "").to_i
    return die
  end

  def run_dice(array)
    res = {}

    # First, we check if the array is valid
    raise ArgumentError, "Wrong number of arguments." unless array.length > 0

    # Run one iteration for each of the dice parsed.
    array.each_index do |i|
      # Recovers the die data
      die  = parse_dice(array[i])
      # Sets both the integer total result to zero
      resi = 0
      # And the result string to empty
      ress = "( "

      # Runs one iteration for each of this dice that must be rolled
      die[:number].times do |j|
        resx  = @rand.rand(die[:die])
        resi += resx
        ress << resx.to_s
        if j < (die[:number] - 1)
          ress << " + "
        end
      end

      # After all dice have been rolled, we add the modifier, if any
      resi += die[:mod]
      if die[:mod] > 0
        ress << " + " + die[:mod].magnitude.to_s
      else
        if die[:mod] < 0
          ress << " - " + die[:mod].magnitude.to_s
        end
      end
      # Lastly, we add the total result
      ress << " ) = " + resi.to_s

      # And record it in the Hash
      res[i] = {
        :str => ress,
        :int => resi
      }
    end

    # At last, we return the Hash
    return res
  end

  def run(string)
    return run_dice(parse_string(string))
  end

  def get_modifier(value)
    mod  = value / 2
    mod -= 5
    return mod
  end

end
