function clear_array(array) local n = #array for i = 1, n do array[i] = nil end end
function push(stack, value) stack[#stack + 1] = value end
function pop(stack) assert(#stack > 0) local value = stack[#stack] ; stack[#stack] = nil return value end
function empty(stack) return (#stack == 0) end
function errorf(...) error(string.format(...)) end
function printf(...) print(string.format(...)) end

local program = {} -- array of instructions

local input_file = io.open('input.txt', 'r')
for instruction in input_file:lines() do
  for opcode, a1 in instruction:gmatch('([a-z]+) (.+)') do
    push(program, { opcode, tonumber(a1) })
  end
end
input_file:close()

function run_program()
  local accumulator = 0
  local instruction_pointer = 1
  local history = {} -- set of instruction pointers that have been visited
  while true do
    if instruction_pointer == (#program + 1) then
      return true, accumulator
    end
    if history[instruction_pointer] then
      return false, accumulator
    end
    history[instruction_pointer] = 1
    local instruction = program[instruction_pointer]
    if not instruction then
      errorf('Program out of bounds. Instruction pointer : %d / %d', instruction_pointer, #program)
    end 
    local opcode = instruction[1]
    local next_instruction_pointer = instruction_pointer + 1
    if opcode == 'jmp' then
      next_instruction_pointer = instruction_pointer + instruction[2]
    elseif opcode == 'acc' then
      accumulator = accumulator + instruction[2]
    end
    instruction_pointer = next_instruction_pointer
  end
end

do
  local _, accumulator = run_program()
  printf('PART1 - Accumulator : %d', accumulator)
end

do
  for instruction_number, instruction in ipairs(program) do
    local opcode = instruction[1]
    if opcode == 'jmp' then
      instruction[1] = 'nop'
    elseif opcode == 'nop' then
      instruction[1] = 'jmp'
    end
    if opcode ~= instruction[1] then
      local program_ended_correctly, accumulator = run_program()
      if program_ended_correctly then
        printf('PART2 - Fixed instruction #%d. Accumulator = %d.', instruction_number, accumulator)
        break
      else
        instruction[1] = opcode
      end
    end
  end
end

