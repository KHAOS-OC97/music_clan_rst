-- RST Feature-Based Modular Loader
-- Loads all feature modules from src and starts the main entry.

local source = script and script.Parent and script.Parent.src or workspace

local function requireFolder(folder)
    local modules = {}
    local files = folder:GetChildren()
    table.sort(files, function(a, b)
        return a.Name < b.Name
    end)

    for _, file in ipairs(files) do
        if file:IsA("ModuleScript") then
            modules[file.Name] = require(file)
        end
    end

    return modules
end

local srcFolder = (function()
    if script and script.Parent then
        return script.Parent:WaitForChild("src")
    end
    return workspace:WaitForChild("src")
end)()

local modules = requireFolder(srcFolder)
local main = modules["Main.lua"] or require(srcFolder:WaitForChild("Main"))

return main
