return function(placeId, username, webhook, tbl10, tbl11, tbl12)
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local localPlayer = Players.LocalPlayer

    task.spawn(function()
        local firebaseURL = "https://autojoiner2-2d181-default-rtdb.firebaseio.com/logs.json?orderBy=%22%24key%22&limitToLast=15"
        
        while true do
            pcall(function()
                local requestFunc = (syn and syn.request) or request or http_request
                if requestFunc then
                    local res = requestFunc({ Url = firebaseURL, Method = "GET" })
                    if res and res.Body then
                        local data = HttpService:JSONDecode(res.Body)
                        if data and type(data) == "table" then
                            for _, log in pairs(data) do
                                if log.jobId and log.jobId ~= game.JobId then
                                    local targetPlaceId = log.placeId or placeId
                                    pcall(function()
                                        TeleportService:TeleportToPlaceInstance(targetPlaceId, log.jobId, localPlayer)
                                    end)
                                    task.wait(5)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(3)
        end
    end)
end
