function printf(...) print(string.format(...)) end
function push(stack, value) stack[#stack + 1] = value end
local values, max_value = {}, nil
local matrix = {
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,1,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
  l,l,l,l,l,l,l,l,l,l,
}

do -- Load input file
  local input_file = io.open('input.txt', 'r')
  for line in input_file:lines() do
    local value = tonumber(line) ; assert(value, '<'..line..'>')
    if not max_value or value > max_value then
      max_value = value
    end 
    push(values, value)
  end
  input_file:close()
  assert(max_value)
end

-- Add socket and device joltage to the values so differences can be computed correctly
push(values, 0)
push(values, max_value + 3)

table.sort(values)

do -- Part 1
  local values = values
  local differences = {}
  for i = 2, #values do
    local d = values[i] - values[i - 1]
    differences[d] = (differences[d] or 0) + 1
  end
  printf('PART1 - %d.', differences[1]*differences[3])
end


--[[
We can see arrangements like a tree. In the first example
  16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4
Becomes ([0] and [max+3] added)
  0, 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, 22

Because for each element/node e we can check if there is some greater number x satisfying x - e <= 3. If there is, we can branch from there:

0 -> 1 -> 4 -> 5 -> 6 -> 7 -> 10 -> 11 -> 12 -> 15 -> 16 -> 19 -> 22
          |    |              |
          |    |              + -> 12 -> 15 -> 16 -> 19 -> 22
          |    |
          |    + -> 7 -> 10 -> 11 -> 12 -> 15 -> 16 -> 19 -> 22
          |              |
          |              + -> 12 -> 15 -> 16 -> 19 -> 22
          |
          + -> 6 -> 7 -> 10 -> 11 -> 12 -> 15 -> 16 -> 19 -> 22
          |              |
          |              + -> 12 -> 15 -> 16 -> 19 -> 22
          |
          + -> 7 -> 10 -> 11 -> 12 -> 15 -> 16 -> 19 -> 22
                    |
                    + -> 12 -> 15 -> 16 -> 19 -> 22

In this tree there are 8 unique branches, thus the number of arrangements is 8.

--]]

do -- Part 2
  local values = values -- local local local :)
  local hot_cache, hot_cache_hit = {}, 0
  local implementation -- "Forward" declaration for recursion
  function implementation(index)
    local value = hot_cache[index]
    if value then
      hot_cache_hit = hot_cache_hit + 1
      return value
    end
    local branches_count = 0
    local has_next_value = false
    value = values[index]
    for i = 1, 3 do
      local next_index = index + i
      local next_value = values[next_index]
      if next_value and (next_value - value <= 3) then
        has_next_value = true
        branches_count = branches_count + implementation(next_index) -- Sum of leaves that can be seen from this element/node
      end
    end
    if not has_next_value then
      value = 1 -- If our node is a leaf, increment the branch count
    else
      value = branches_count -- Propagate branch count to caller
    end
    hot_cache[index] = value -- You better cache or you better wait
    return value
  end
  printf('PART2 - %d. Hit cache %d time%s.%s', implementation(1), hot_cache_hit, ((hot_cache_hit ~= 1) and 's' or ''), (matrix[hot_cache_hit] and ' Nice.' or ''))
end
