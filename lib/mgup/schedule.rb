class Mgup::Schedule
  def self.departments
    require 'open-uri'
    content = open('https://raw.github.com/mgup/schedule/master/%D0%9E%D0%A7%D0%9D%D0%9E%D0%95/CAFEDRAS.DAT', 'r:windows-1251').read

    departments = {}
    i = 1
    content.encode('UTF-8').split("\r\n").each do |line|
      departments[i] = line
      i += 1
    end

    departments
  end

  def self.rooms
    require 'open-uri'
    departments = self.departments

    rooms = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [] }

    [1, 2, 3, 4, 5, 6].each do |list|
      content =  open("https://raw.github.com/mgup/schedule/master/%D0%9E%D0%A7%D0%9D%D0%9E%D0%95/CAB#{list}.DAT", 'r:windows-1251').read

      content.encode('UTF-8').split("\r\n").each do |line|
        line.match(/\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)\s*(\d+)\s*(.+)/) do |room|
          rooms[list].push({ type1: room[1], type2: room[2],
                              type3: room[3], department: departments[room[4].to_i],
                              capacity: room[5], name: room[6] })
        end
      end
    end

    rooms
  end
end