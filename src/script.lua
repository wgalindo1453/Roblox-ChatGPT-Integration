local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local RemoteEvent = ReplicatedStorage:WaitForChild("ChatGPTEvent")

local OPENAI_API_URL = "https://api.openai.com/v1/chat/completions"
local API_KEY = "YOUR_API_KEY" -- Replace with your OpenAI API key

local headers = {
	["Authorization"] = "Bearer " .. API_KEY,
	["Content-Type"] = "application/json"
}

function fetchRecipeFromAPI(query)
	local data = {
		model = "gpt-4",
		messages = {
			{role = "user", content = query}
		},
		temperature = 0.7,
		max_tokens = 500,
		top_p = 1,
		frequency_penalty = 0,
		presence_penalty = 0
	}

	local response = HttpService:RequestAsync({
		Url = OPENAI_API_URL,
		Method = "POST",
		Headers = headers,
		Body = HttpService:JSONEncode(data)
	})

	if response and response.Success then
		local responseBody = HttpService:JSONDecode(response.Body)
		return responseBody.choices[1].message.content
	else
		warn("Failed to get response from OpenAI API. Status: " .. response.StatusCode .. ". Message: " .. response.StatusMessage)
		return nil
	end
end

RemoteEvent.OnServerEvent:Connect(function(player, userInput)
	local response = fetchRecipeFromAPI(userInput)
	RemoteEvent:FireClient(player, response) -- Send the response back to the client
end)