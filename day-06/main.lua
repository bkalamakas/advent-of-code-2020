local questions_sum = 0        -- Part 1
local common_questions_sum = 0 -- Part 2

local group_mapped_question_count = {} -- map of (string -> number) : Stores how many times a question has been answered in the group being processed
local group_individual_count = 0 -- Stores how many individuals are in the group being processed

function process_questions()
  for _, answers in pairs(group_mapped_question_count) do
    questions_sum = questions_sum + 1
    if answers == group_individual_count then
      -- Everyone answered yes to this question
      common_questions_sum = common_questions_sum + 1
    end
  end
  group_mapped_question_count = {}
  group_individual_count = 0
end

local input_file = io.open('input.txt', 'r')
for questions in input_file:lines() do
  if questions == '' then
    process_questions()
  else
    local map = group_mapped_question_count
    for question in questions:gmatch('.') do
      map[question] = (map[question] or 0) + 1
    end
    group_individual_count = group_individual_count + 1
  end
end
process_questions()
input_file:close()

print(string.format('PART1 - Sum of positive questions : %d', questions_sum))
print(string.format('PART2 - Sum of common positive questions : %d', common_questions_sum))
