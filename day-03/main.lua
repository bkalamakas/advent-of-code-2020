local input_file = io.open('input.txt', 'r')

local map_trees, map_width, map_height = {}, nil, nil
do
  local i, j = 0, 0
  for line in input_file:lines() do
    i, j = 0, j + 1
    for character in line:gmatch('.') do
      i = i + 1
      map_trees[i..'/'..j] = (character == '#')
    end
    if not map_width then map_width = i end
  end
  map_height = j
  input_file:close()
end

local function trees_encountered(slope_x, slope_y)
  local result = 0
  local i, j = 1, 1
  while j <= map_height do
    if map_trees[i..'/'..j] then
      result = result + 1
    end
    i = i + slope_x
    if i > map_width then
      i = i - map_width
    end
    j = j + slope_y
  end
  print(string.format('Encountered %d tree(s) while sliding down [%d, %d]', result, slope_x, slope_y))
  return result
end

print('PART1: ')
trees_encountered(3, 1)

print() print('PART2:')
local slopes = { { 1, 1 }, { 3, 1 }, { 5, 1 }, { 7, 1 }, { 1, 2 } }
local result = 1
for _, slope in ipairs(slopes) do
  result = result * trees_encountered(slope[1], slope[2])
end
print(string.format('Product of the results: %d', result))
