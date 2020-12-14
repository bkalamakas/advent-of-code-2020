function printf(...) print(string.format(...)) end
do -- LOOP : Light object orientation programming :)
  local OCCUPIED_SEAT = '#'
  local EMPTY_SEAT    = 'L'
  -- 4 3 2
  -- 5 . 1
  -- 6 7 8
  local detail_offsets_i = { 1,  1,  0, -1, -1, -1, 0, 1 }
  local detail_offsets_j = { 0, -1, -1, -1,  0,  1, 1, 1 }
  local function detail_map_count_occupied(map, i, j, candidate, extended_neighbours)
    local result = 0
    
    return result
  end
  -- map.data is a map (string->string) with a unique key for each pair of grid coordinate because why not
  local function map_get(map, i, j) return map.data[i..'/'..j]  end
  local function map_set(map, i, j, x) map.data[i..'/'..j] = x end
  local function map_occupied_seats(map)
    local data, result = map.data, 0
    for key, value in pairs(data) do
      if value == OCCUPIED_SEAT then
        result = result + 1
      end
    end
    return result
  end
  -- Cellular automata!
  local function map_simulate(map, mutable_map, occupied_rule, extended_neighbours)
    local state_changed = false
    local data = map.data
    for key, character in pairs(data) do
      local i, j = key:match('(.+)/(.+)')
      local current_seat_state = map:get(i, j)
      local adjacent_occupied_seats = 0
      for o = 1, #detail_offsets_i do
        local offset_i, offset_j = detail_offsets_i[o], detail_offsets_j[o]
        local scale = 0
        while true do
          scale = scale + 1
          local seat_value = map:get(i + offset_i*scale, j + offset_j*scale)
          if seat_value == OCCUPIED_SEAT then adjacent_occupied_seats = adjacent_occupied_seats + 1 end
          if (not extended_neighbours) or (not seat_value) or (seat_value == EMPTY_SEAT) or (seat_value == OCCUPIED_SEAT) then break end
        end
      end
      if (current_seat_state == EMPTY_SEAT) and (adjacent_occupied_seats == 0) then
        mutable_map:set(i, j, OCCUPIED_SEAT)
        state_changed = true
      elseif (current_seat_state == OCCUPIED_SEAT) and (adjacent_occupied_seats >= occupied_rule) then
        mutable_map:set(i, j, EMPTY_SEAT)
        state_changed = true
      else
        mutable_map:set(i, j, current_seat_state)
      end
    end
    return state_changed
  end
  function make_map()
    return {
      -- Data
      data = {};
      -- Functions
      get = map_get;
      set = map_set;
      simulate = map_simulate;
      occupied_seats = map_occupied_seats;
    }
  end
end

local first_map, second_map, swap_map, iterations = make_map(), make_map(), make_map()

do -- Load input file
  local input_file = io.open('input.txt', 'r')
  local i, j = 0, 0
  for line in input_file:lines() do
    i, j = 0, j + 1
    for character in line:gmatch('.') do -- Match ANY character
      i = i + 1
      first_map:set(i, j, character)
      second_map:set(i, j, character)
    end
  end
end

iterations = 0
while true do
  if not first_map:simulate(swap_map, 4, false) then
    break
  end
  iterations = iterations + 1
  first_map, swap_map = swap_map, first_map
end

printf("PART1 - %d occupied seat(s) in %d iteration(s)", first_map:occupied_seats(), iterations)

iterations = 0
while true do
  if not second_map:simulate(swap_map, 5, true) then
    break
  end
  iterations = iterations + 1
  second_map, swap_map = swap_map, second_map
end

printf("PART2 - %d occupied seat(s) in %d iteration(s)", second_map:occupied_seats(), iterations)
