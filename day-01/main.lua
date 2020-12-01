local sum_predicate = 2020

local numbers, input_file = {}, io.open('input.txt', 'r')
for line in input_file:lines() do
  numbers[#numbers + 1] = tonumber(line)
end
input_file:close()

local found_anything, n = false, #numbers

print('Looking for (a, b) solutions')

for i = 1, n do
  for j = i, n do
    local a, b = numbers[i], numbers[j]
    if a + b == sum_predicate then
      print(string.format('Found (a, b) = (%d, %d) where a + b = %d. Therefore a * b = %d is one solution.', a, b, sum_predicate, a*b))
      found_anything = true
    end
  end
end

if not found_anything then
  print('Nothing found')
end

found_anything = false

print()
print('Looking for (a, b, c) solutions')

for i = 1, n do
  for j = i, n do
    for k = j, n do
      local a, b, c = numbers[i], numbers[j], numbers[k]
      if a + b + c == sum_predicate then
        print(string.format('Found (a, b, c) = (%d, %d, %d) where a + b + c = %d. Therefore a * b * c = %d is one solution.', a, b, c, sum_predicate, a*b*c))
        found_anything = true
      end
    end
  end
end

if not found_anything then
  print('Nothing found')
end
