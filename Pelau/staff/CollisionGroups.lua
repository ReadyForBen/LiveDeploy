local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local groupID = 34384814
local minRank = 0 -- Junior Server

local staffGroup = "Staff"

PhysicsService:CollisionGroupSetCollidable(staffGroup, staffGroup, false)

local function setCollisionGroup(character, groupName)
	local function applyCollisionGroup(part)
		if part:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(part, groupName)
		end
	end

	for _, part in ipairs(character:GetChildren()) do
		applyCollisionGroup(part)
	end

	character.ChildAdded:Connect(applyCollisionGroup)
end

local function onCharacterAdded(player)
	local function handleCharacter(character)
		local rank = player:GetRankInGroup(groupID)
		if rank >= minRank then
			setCollisionGroup(character, staffGroup)
		else
			print("not staff")
		end
	end

	player.CharacterAdded:Connect(handleCharacter)

	if player.Character then
		handleCharacter(player.Character)
	end
end

local function onPlayerAdded(player)
	onCharacterAdded(player)
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
