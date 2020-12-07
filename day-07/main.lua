function clear_array(array) local n = #array for i = 1, n do array[i] = nil end end
function push(stack, value) stack[#stack + 1] = value end
function pop(stack) assert(#stack > 0) local value = stack[#stack] stack[#stack] = nil return value end
function empty(stack) return (#stack == 0) end

-- The problem is a layered graph
-- A bag is a node, every sentence in the input data is describing a node and its weights to its descendents
-- next_weights represents every weight from "top" to "bottom", prev_weights represents every weight from "bottom" to "top"

local next_weights = {} -- map ( color : string ) -> array ( weight : table )
local prev_weights = {} -- map ( color : string ) -> array ( weight : table )

function make_weight(color_name, weight_value) -- weight ""constructor""
  return { color = color_name ; value = weight_value }
end

function add_next_weight(color, weight)
  local array = next_weights[color]
  if not array then array = {} ; next_weights[color] = array end
  array[#array + 1] = weight
end

function add_prev_weight(color, weight)
  local array = prev_weights[color]
  if not array then array = {} ; prev_weights[color] = array end
  array[#array + 1] = weight
end

do -- Load and parse input file
  local input_file = io.open('input.txt', 'r')
  local cart = {} -- token accumulator
  local color_table, color, token_index = {}, nil, nil
  for sentences in input_file:lines() do
    token_index = 1 ; clear_array(color_table) ; clear_array(cart)
    for token in sentences:gmatch('%S+') do -- Split in tokens, delimited by spaces (%s : match space, %S : match anything but space).
      if token_index <= 2 then
        color_table[#color_table + 1] = token
      elseif token_index == 3 then
        color = table.concat(color_table, ' ')
      elseif token_index >= 5 then
        cart[#cart + 1] = token
        if #cart == 4 then -- Handles the case "x y bags contain no other bags." since "no other bags." is 3 tokens and will thus be discarded
          local cart_color, cart_value = cart[2]..' '..cart[3], tonumber(cart[1])
          add_next_weight(color, make_weight(cart_color, cart_value))
          add_prev_weight(cart_color, make_weight(color, cart_value))
          clear_array(cart)
        end
      end
      token_index = token_index + 1
    end
  end
end

do -- Solve part 1
  local result_set = {} -- set since we don't want to count a bag multiple times
  local search_stack = {} -- stack (color : string) for greedy search
  -- Greedy search for 'shiny gold's previous nodes
  push(search_stack, 'shiny gold')
  while not empty(search_stack) do
    local previous_color = pop(search_stack)
    result_set[previous_color] = 1
    local weights = prev_weights[previous_color]
    if weights then
      for _, weight in ipairs(weights) do
        push(search_stack, weight.color)
      end
    end
  end
  local result_count = 0
  for _ in pairs(result_set) do
    result_count = result_count + 1
  end
  result_count = result_count - 1 -- Don't count 'shiny gold'
  print(string.format('PART1 - %d bag%s can contain at least one shiny gold bag.', result_count, (result_count == 1) and '' or 's'))
end

do -- Solve part 2
  local result = 0
  local search_stack = {} -- stack (weight : table) for greedy search
  -- Greedy search for 'shiny gold's next nodes
  push(search_stack, make_weight('shiny gold', 1))
  while not empty(search_stack) do
    local next_weight = pop(search_stack)
    result = result + next_weight.value
    local weights = next_weights[next_weight.color]
    if weights then
      for _, weight in ipairs(weights) do
        push(search_stack, make_weight(weight.color, next_weight.value*weight.value)) -- Multiply values as we're going deep
      end
    end
  end
  result = result - 1 -- No counting, counting bad
  print(string.format('PART2 - %d required bag%s in shiny bag.', result, (result == 1) and '' or 's'))
end
