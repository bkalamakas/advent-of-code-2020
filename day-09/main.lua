function printf(...) print(string.format(...)) end
function clear(array) local n = #array ; for i = 1, n do array[i] = nil end end
function push(stack, value) stack[#stack + 1] = value end

local values, window_size = {}, 25
local part_one, part_two = nil, nil

do -- Load input file
  local input_file = io.open('input.txt', 'r')
  for line in input_file:lines() do
    push(values, tonumber(line))
  end
  input_file:close()
  assert(#values > window_size)
end

do -- Part 1
  local cursor = window_size + 1
  while cursor <= #values do
    local value = values[cursor]
    local evaluates = false
    local window_cursor = cursor - window_size - 1
    for i = 1, window_size do
      for j = i, window_size do
        if (i ~= j) and ((values[window_cursor + i] + values[window_cursor + j]) == value) then
          evaluates = true
        end
      end
    end
    if not evaluates then
      part_one = value
      break
    end
    cursor = cursor + 1
  end
  assert(part_one)
end

do -- Part 2
  local a, b = (function() -- Anonymous function call so we can easily break nested loops using return
    local value = part_one
    local range_begin, range_end = 1, 1
    while range_begin <= #values do
      range_end = range_begin
      while range_end <= #values do
        if range_end - range_begin + 1 >= 2 then
          local sum = 0
          for i = range_begin, range_end do
            sum = sum + values[i]
          end
          if sum > value then -- Tiny optimisation, works because we add positive numbers
            break
          end
          if sum == value then
            return range_begin, range_end
          end
        end
        range_end = range_end + 1
      end
      range_begin = range_begin + 1
    end
  end)()
  assert(a and b)
  local min, max
  for i = a, b do
    if not min or values[i] < min then min = values[i] end
    if not max or values[i] > max then max = values[i] end
  end
  assert(min and max)
  part_two = min + max
end

printf("PART1 - Can't find a satisfying sum for value %d.", part_one)
printf("PART2 - Encryption weakness: %d.", part_two)
