local passports_with_required_fields = 0 -- Part 1
local passports_with_valid_fields    = 0 -- Part 2

local required_passport_fields = { byr=1, iyr=1, eyr=1, hgt=1, hcl=1, ecl=1, pid=1 }
local eye_colors = { amb=1, blu=1, brn=1, gry=1, grn=1, hzl=1, oth=1 }

local passport = {}

function process_passport()
  local passport_has_required_fields = true
  for k, v in pairs(required_passport_fields) do
    if not passport[k] then
      passport_has_required_fields = false
      break
    end
  end
  if passport_has_required_fields then
    passports_with_required_fields = passports_with_required_fields + 1
    local valid_fields = 0
    -- 1. Validate birth year
    local byr = tonumber(passport.byr)
    if byr and (byr >= 1920) and (byr <= 2002) then
      valid_fields = valid_fields + 1
    end
    -- 2. Validate issue year
    local iyr = tonumber(passport.iyr)
    if iyr and (iyr >= 2010) and (iyr <= 2020) then
      valid_fields = valid_fields + 1
    end
    -- 3. Validate expiration year
    local eyr = tonumber(passport.eyr)
    if eyr and (eyr >= 2020) and (eyr <= 2030) then
      valid_fields = valid_fields + 1
    end
    -- 4. Validate height
    local hgt = passport.hgt
    local hgt_value, hgt_unit = hgt:match('^([0-9]+)([cmin]+)$')
    hgt_value = tonumber(hgt_value)
    local hgt_lower, hgt_upper
    if hgt_unit == 'cm' then
      hgt_lower, hgt_upper = 150, 193
    elseif hgt_unit == 'in' then
      hgt_lower, hgt_upper = 59, 76
    end
    if hgt_value and hgt_lower and hgt_value >= hgt_lower and hgt_value <= hgt_upper then
      valid_fields = valid_fields + 1
    end
    -- 5. Validate hair color
    local hcl = passport.hcl:match('^#([0-9a-f]+)$')
    if hcl and (#hcl == 6) then
      valid_fields = valid_fields + 1
    end
    -- 6. Validate eye color
    local ecl = passport.ecl
    if eye_colors[ecl] then
      valid_fields = valid_fields + 1
    end
    -- 7. Validate passport id
    local pid = passport.pid:match('^[0-9]+$')
    if pid and (#pid == 9) then
      valid_fields = valid_fields + 1
    end
    -- All fields OK?
    if valid_fields == 7 then
      passports_with_valid_fields = passports_with_valid_fields + 1
    end
  end
  passport = {}
end

local input_file = io.open('input.txt', 'r')
for line in input_file:lines() do
  if line == '' then
    process_passport()
  else
    for a, b in line:gmatch('(%S+):(%S+)') do
      passport[a] = b
    end
  end
end
process_passport()
input_file:close()

print(string.format('PART1 - Passports with required fields : %d', passports_with_required_fields))
print(string.format('PART2 - Passports with valid fields : %d', passports_with_valid_fields))
