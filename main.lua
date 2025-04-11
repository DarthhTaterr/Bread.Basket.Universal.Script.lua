local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Bread Basket Scripts",
   LoadingTitle = "Welcome to Bread Basket Scripts",
   LoadingSubtitle = "by DarthhTaterr and Bread's Nutella",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "Big Hub"
   },
})

local MainTab = Window:CreateTab("Main")
local DiscordSection = MainTab:CreateSection("Discord Invite")

-- Button that copies Discord invite
MainTab:CreateButton({
   Name = "Copy Discord Invite",
   Callback = function()
      local discordLink = "https://discord.gg/y4XaB9ZRcG"
      setclipboard(discordLink)
      Rayfield:Notify({
         Title = "Discord Invite Copied!",
         Content = "The invite link has been copied to your clipboard: "..discordLink,
         Duration = 6,
         Image = 0
      })
   end,
})

MainTab:CreateLabel("Join our Discord: https://discord.gg/y4XaB9ZRcG")
MainTab:CreateLabel("Paid/Premium script coming out soon with premium benifits!!")

-- Player Tab
local PlayerTab = Window:CreateTab("Player", nil)
PlayerTab:CreateSection("Movement Mods")

-- Services
local UserInputService = game:GetService("UserInputService")

-- Jump system variables
local safeJumpEnabled = false
local riskyJumpEnabled = false
local spaceHeld = false
local jumpCooldown = 1 / 5 -- 5 jumps per second
local lastSafeJumpTime = 0

-- WalkSpeed variables
local walkSpeedEnabled = false
local currentWalkSpeed = 16 -- Default walkspeed

-- Safe Jump Toggle
PlayerTab:CreateToggle({
   Name = "Infinite Jump (Hold Space - Safe)",
   CurrentValue = false,
   Callback = function(state)
      safeJumpEnabled = state
      if state then
         riskyJumpEnabled = false
      end
   end,
})

-- Risky Jump Toggle
PlayerTab:CreateToggle({
   Name = "Infinite Jump (May Get Kicked)",
   CurrentValue = false,
   Callback = function(state)
      riskyJumpEnabled = state
      if state then
         safeJumpEnabled = false
      end
   end,
})

-- WalkSpeed Toggle
PlayerTab:CreateToggle({
   Name = "Enable Custom WalkSpeed",
   CurrentValue = false,
   Callback = function(state)
      walkSpeedEnabled = state
      if state then
         -- Apply current walkspeed when enabled
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = currentWalkSpeed
         end
      else
         -- Reset to default when disabled
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

-- WalkSpeed Slider
PlayerTab:CreateSlider({
   Name = "WalkSpeed Value",
   Range = {16, 100},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 16,
   Callback = function(value)
      currentWalkSpeed = value
      if walkSpeedEnabled then
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
         end
      end
   end,
})

-- Spacebar input detection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
   if input.KeyCode == Enum.KeyCode.Space then
      spaceHeld = true
   end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
   if input.KeyCode == Enum.KeyCode.Space then
      spaceHeld = false
   end
end)

-- Safe jump loop (5 per second)
task.spawn(function()
   while true do
      if safeJumpEnabled and spaceHeld then
         local now = tick()
         if now - lastSafeJumpTime >= jumpCooldown then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
               char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
               lastSafeJumpTime = now
            end
         end
      end
      task.wait(0.01)
   end
end)

-- Risky jump loop (no cooldown)
task.spawn(function()
   while true do
      if riskyJumpEnabled and spaceHeld then
         local char = game.Players.LocalPlayer.Character
         if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end
      task.wait(0.01) -- Super responsive (1ms intervals)
   end
end)

-- Character added/removed detection to maintain walkspeed
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
   if walkSpeedEnabled then
      character:WaitForChild("Humanoid").WalkSpeed = currentWalkSpeed
   end
end)