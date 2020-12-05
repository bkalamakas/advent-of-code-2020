local highest_seat_id
local seat_ids = {}

local input_file = io.open('input.txt', 'r')
for line in input_file:lines() do
  local seat = line
  -- Construct a binary number. Digit F becomes 0, B->1, R->1 and L->0.
  local seat_id = tonumber((seat:gsub('F','0'):gsub('B','1'):gsub('R','1'):gsub('L','0')), 2)
  if highest_seat_id == nil or seat_id > highest_seat_id then
    highest_seat_id = seat_id
  end
  seat_ids[#seat_ids + 1] = seat_id
end

input_file:close()

table.sort(seat_ids)

local available_seat, current_seat_index
for seat_index = 1, #seat_ids do
  if current_seat_index == nil then
    current_seat_index = seat_index
  else
    if (seat_ids[seat_index] - seat_ids[current_seat_index]) ~= 1 then
      available_seat = seat_ids[current_seat_index] + 1
      break
    end
    current_seat_index = seat_index
  end
end

print(string.format('PART1 - Highest seat Id: %d', highest_seat_id))
print(string.format('PART2 - Available seat Id: %d', available_seat))