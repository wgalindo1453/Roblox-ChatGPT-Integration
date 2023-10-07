local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RemoteEvent = ReplicatedStorage:WaitForChild("ChatGPTEvent")

-- Reference the computer model and its GUI components
local computerModel = Workspace:WaitForChild("Working Screen")
local Screen = computerModel:WaitForChild("Screen")
local surfaceGui = Screen:WaitForChild("SurfaceGui")
local frame = surfaceGui:WaitForChild("Frame")
local submitButton = frame:WaitForChild("SubmitButton")
local inputBox = frame:WaitForChild("InputBox")
local outputLabel = frame:WaitForChild("OutputLabel")

submitButton.MouseButton1Click:Connect(function()
	local userInput = inputBox.Text
	RemoteEvent:FireServer(userInput) -- Send the user input to the server
end)

RemoteEvent.OnClientEvent:Connect(function(response)
	if response then
		outputLabel.Text = response
	else
		outputLabel.Text = "Failed to get a response. Please try again."
	end
end)