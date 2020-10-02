#!/usr/bin/env ruby

class Drone
  @@engines = 4
  @@gyroscope = [0,0,0] # x:pitch, y:roll, z:height
  @@orientation_sensor = [0,0] # pitch, roll
  @@engine_power = 0 # 0 to 100%
  @@engine_status = false # on/off
  @@drone_status = 0 # 0:off, 1:hovering, 2:moving

  def self.take_off
    @@engine_status = true
    @@engine_power = 50
    @@orientation_sensor = [0,0]
    @@gyroscope = [0,0,10]
    @@drone_status = 1
    status
  end

  def self.move(direction)
    case direction
    when 'forward'
      @@gyroscope = [0,1,10]
      @@drone_status = 2

    when 'left'
      @@gyroscope = [-1,0,10]
      @@drone_status = 2

    when 'right'
      @@gyroscope = [1,0,10]
      @@drone_status = 2

    when 'back'
      @@gyroscope = [0,-1,10]
      @@drone_status = 2

    when 'up'
      @@gyroscope = [0,0,15]
      @@drone_status = 2

    when 'down'
      @@gyroscope = [0,0,5]
      @@drone_status = 2
    end

    status
  end

  def self.stabilize
    state = @@gyroscope
    @@gyroscope = [0,0,state[2]]
    @@drone_status = 1

    status
  end

  def self.status
    case @@drone_status
    when 0
      puts "off"
    when 1
      puts "hovering"
      distress?

    when 2
      puts "moving"
      distress?
    end
  end

  def self.land
    stabilize
    @@gyroscope = [0,0,0]
    @@engine_status = false
    @@drone_status = 0

    status
  end

  def self.distress?
    if !@@engine_status || @@gyroscope[2] == 0
      puts "Mayday, Mayday !!!"
    end
  end
end
