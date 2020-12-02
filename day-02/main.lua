local input_file = io.open('input.txt', 'r')
local input = input_file:read('*a')
input_file:close()

local valid_passwords_1, valid_passwords_2 = 0, 0
for a, b, character, password in input:gmatch('([0-9]+)%-([0-9]+) ([a-zA-Z]+): ([a-zA-Z]+)') do
  a, b = tonumber(a), tonumber(b)
  
  -- Part 1, hack: use gsub to get the character count
  local character_count = select(2, password:gsub(character, ''))
  if character_count >= a and character_count <= b then
    valid_passwords_1 = valid_passwords_1 + 1
  end
  
  -- Part 2
  if (character == password:sub(a, a)) ~= (character == password:sub(b, b)) then
    valid_passwords_2 = valid_passwords_2 + 1
  end
end

print(string.format('PART 1 - Valid password count: %d', valid_passwords_1))
print(string.format('PART 2 - Valid password count: %d', valid_passwords_2))
