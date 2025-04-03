local DataStoreService = game:GetService("DataStoreService")
local DataManager = {}

--[[
	Saves player data to a specified DataStore.

	@param dataKey (string): The name of the DataStore to save data to.
	@param player (Player): The player whose data is being saved.
	@param data (table): A table containing the data entries to save. Each entry should have a "Name" field.

	@return nil
	
	Notes:
	- By default, the function filters out duplicate entries based on the "Name" property.
	- Duplicates are skipped and a warning is printed in the output.
	- Set `uniqueToggle` to false to allow duplicates.
]]
function DataManager.SaveData(dataKey, player, data)
	local uniqueToggle = true

	-- Table to store unique entries
	local uniqueData = {}
	-- Table to track seen names or IDs
	local seenKeys = {}

	for _, entry in ipairs(data) do
		if uniqueToggle then
			if not seenKeys[entry.Name] then
				table.insert(uniqueData, entry)
				seenKeys[entry.Name] = true
			else
				warn(string.format("Duplicate entry detected: %s for player: %s - Skipping this entry.", entry.Name, player.Name))
			end
		else
			table.insert(uniqueData, entry)
		end
	end

	-- Save the filtered unique data to the DataStore
	local success, err = pcall(function()
		local playerDataStore = DataStoreService:GetDataStore(dataKey)
		playerDataStore:SetAsync(player.UserId, uniqueData)
	end)

	if not success then
		warn(string.format("Failed to save data for player: %s Error: %s", player.Name, err))
	end
end

--[[
	Retrieves saved player data from the specified DataStore.

	@param dataKey (string): The name of the DataStore to load data from.
	@param player (Player): The player whose data is being loaded.

	@return (table): The saved data if available, or an empty table if no data is found or an error occurs.

	Notes:
	- Ensure the dataKey matches the one used during saving.
	- Always load data before modifying it to prevent accidental overwrites.
]]
function DataManager.LoadData(dataKey, player)
	local success, result = pcall(function()
		local playerDataStore = DataStoreService:GetDataStore(dataKey)
		return playerDataStore:GetAsync(player.UserId)
	end)
	if success and result then
		return result -- Return the saved data
	else
		return {} -- Return an empty table if no data or an error occurs
	end
end

--[[
	Adds a new data entry to a player's saved data in the specified DataStore.

	@param dataKey (string): The name of the DataStore to save data to.
	@param player (Player): The player whose data is being updated.
	@param newData (table): A table representing the new data entry to add.

	@return (table): The updated data table after the new entry has been added.

	Notes:
	- Automatically loads the existing data, appends the new entry, and saves it.
	- Uses SaveData, which may filter duplicates if the "Name" field already exists.
]]
function DataManager.AddData(dataKey, player, newData)
	local playerData = DataManager.LoadData(dataKey, player) -- Load existing data
	table.insert(playerData, newData) -- Add the new data
	DataManager.SaveData(dataKey, player, playerData) -- Save the updated data
	return playerData -- Return updated data
end

--[[
	Edits an existing data entry in a player's saved data.

	@param dataKey (string): The name of the DataStore where the player's data is stored.
	@param player (Player): The player whose data is being modified.
	@param entryName (string): The value of the "Name" field for the entry you want to edit.
	@param updatedProperties (table): A table of key-value pairs representing the properties to update.

	@return (table | nil): The updated data table if the entry is found, or nil if the entry was not found.

	Notes:
	- Only updates existing entries—use AddData to add new ones.
	- Entry must have a "Name" property that matches `entryName`.
	- Logs a warning if the entry is not found.
]]
function DataManager.EditData(dataKey, player, entryName, updatedProperties)
	local playerData = DataManager.LoadData(dataKey, player) -- Load existing data
	local entryFound = false

	for _, entry in ipairs(playerData) do
		if entry.Name == entryName then
			for key, value in pairs(updatedProperties) do
				entry[key] = value -- Update entry properties
			end
			entryFound = true
			break
		end
	end

	if entryFound then
		DataManager.SaveData(dataKey, player, playerData) -- Save the updated data
		return playerData -- Return updated data
	else
		warn(string.format("Entry with name %s not found for player: %s", entryName, player.Name))
		return nil
	end
end

--[[
	Clears all saved data for a player from the specified DataStore.

	@param dataKey (string): The name of the DataStore to clear data from.
	@param player (Player): The player whose data is to be deleted.

	@return nil

	Notes:
	- Permanently deletes all saved data for the player in the given DataStore.
	- Useful for resetting player progress or handling data corruption.
	- Logs a success message on completion, or a warning if an error occurs.
]]
function DataManager.ClearData(dataKey, player)
	local success, err = pcall(function()
		local playerDataStore = DataStoreService:GetDataStore(dataKey)
		playerDataStore:RemoveAsync(player.UserId)
	end)

	if success then
		print(string.format("Successfully cleared data for player: %s", player.Name))
	else
		warn(string.format("Failed to clear data for player: %s Error: %s", player.Name, err))
	end
end

return DataManager
