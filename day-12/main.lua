function printf(...) print(string.format(...)) end
local x1, y1, dx1, dy1 = 0, 0,  1, 0 -- ship at (x1, y1) and its direction (dx1, dy1)
local x2, y2, dx2, dy2 = 0, 0, 10, 1 -- ship at (x2, y2) and the waypoint offset (dx2, dy2)
do -- Read input file
  local input_file = io.open('input.txt', 'r')
  for line in input_file:lines() do
    local command, parameter = line:match('^([A-Z]+)([0-9]+)$')
    parameter = tonumber(parameter)
    assert(command)
    assert(parameter)
    if false then
    elseif command == 'R' then while parameter >= 90 do parameter, dx1, dy1, dx2, dy2 = parameter - 90, dy1, -dx1, dy2, -dx2 end
    elseif command == 'L' then while parameter >= 90 do parameter, dx1, dy1, dx2, dy2 = parameter - 90, -dy1, dx1, -dy2, dx2 end
    else
      local dx1, dy1 = dx1, dy1
      if false then
      elseif command == 'F' then x2, y2 = x2 + parameter*dx2, y2 + parameter*dy2
      elseif command == 'N' then dx1, dy1, dy2 =  0,  1, dy2 + parameter
      elseif command == 'S' then dx1, dy1, dy2 =  0, -1, dy2 - parameter
      elseif command == 'E' then dx1, dy1, dx2 =  1,  0, dx2 + parameter
      elseif command == 'W' then dx1, dy1, dx2 = -1,  0, dx2 - parameter
      else error()
      end
      x1, y1 = x1 + parameter*dx1, y1 + parameter*dy1
    end
  end
end
printf('PART1 - |%d| + |%d| = %d', x1, y1, math.abs(x1) + math.abs(y1))
printf('PART2 - |%d| + |%d| = %d', x2, y2, math.abs(x2) + math.abs(y2))
