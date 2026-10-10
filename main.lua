-- Car Parking Multiplayer 2 - Game Guardian Script
-- Lua Game Engine Main File

function love.load()
    -- Game settings
    screenWidth = 1280
    screenHeight = 720
    
    -- Player stats
    player = {
        x = screenWidth / 2,
        y = screenHeight / 2,
        speed = 300,
        money = 50000000,
        coins = 30000,
        rank = "KING",
        level = 1,
        experience = 0
    }
    
    -- Daily tasks
    dailyTasks = {
        {id = 1, reward = 20000, completed = false, description = "Park 3 cars"},
        {id = 2, reward = 30000, completed = false, description = "Earn 50k money"},
        {id = 3, reward = 50000, completed = false, description = "Complete 5 parking spots"}
    }
    
    -- Car shop inventory
    carShop = {
        {name = "Sports Car", price = 0, owned = false, image = "sports"},
        {name = "SUV", price = 0, owned = false, image = "suv"},
        {name = "Luxury Car", price = 0, owned = false, image = "luxury"},
        {name = "Police Car", price = 0, owned = false, image = "police"},
        {name = "Air Suspension", price = 0, owned = false, image = "air"}
    }
    
    -- Game state
    gameState = "menu"
    selectedCar = 1
    parkingSpots = {}
    
    -- Create parking spots
    createParkingSpots()
end

function love.update(dt)
    if gameState == "playing" then
        -- Player movement
        if love.keyboard.isDown("w") then
            player.y = player.y - player.speed * dt
        elseif love.keyboard.isDown("s") then
            player.y = player.y + player.speed * dt
        end
        
        if love.keyboard.isDown("a") then
            player.x = player.x - player.speed * dt
        elseif love.keyboard.isDown("d") then
            player.x = player.x + player.speed * dt
        end
        
        -- Boundary check
        player.x = math.max(0, math.min(player.x, screenWidth))
        player.y = math.max(0, math.min(player.y, screenHeight))
    end
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.15)
    
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "playing" then
        drawGameplay()
    elseif gameState == "shop" then
        drawShop()
    elseif gameState == "tasks" then
        drawTasks()
    end
end

function drawMenu()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("CAR PARKING MULTIPLAYER 2", 0, 100, screenWidth, "center")
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf("Game Guardian Edition", 0, 160, screenWidth, "center")
    
    love.graphics.setFont(love.graphics.newFont(18))
    love.graphics.printf("[P] Play", 0, 250, screenWidth, "center")
    love.graphics.printf("[S] Shop", 0, 300, screenWidth, "center")
    love.graphics.printf("[T] Tasks", 0, 350, screenWidth, "center")
    love.graphics.printf("[Q] Quit", 0, 400, screenWidth, "center")
    
    -- Display stats
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.printf("Money: $" .. player.money .. " | Coins: " .. player.coins .. " | Rank: " .. player.rank, 
        0, 550, screenWidth, "center")
end

function drawGameplay()
    love.graphics.setColor(0.3, 0.3, 0.3)
    for _, spot in ipairs(parkingSpots) do
        love.graphics.rectangle("fill", spot.x, spot.y, 80, 100)
        love.graphics.setColor(0, 1, 0)
        love.graphics.print(spot.id, spot.x + 35, spot.y + 45)
        love.graphics.setColor(0.3, 0.3, 0.3)
    end
    
    -- Draw player car
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", player.x, player.y, 50, 60)
    
    -- HUD
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print("Money: $" .. player.money, 20, 20)
    love.graphics.print("Coins: " .. player.coins, 20, 45)
    love.graphics.print("Rank: " .. player.rank, 20, 70)
    love.graphics.print("[ESC] Menu | [T] Tasks | [S] Shop", 20, screenHeight - 30)
end

function drawShop()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("CAR SHOP - ALL CARS FREE!", 0, 20, screenWidth, "center")
    
    love.graphics.setFont(love.graphics.newFont(14))
    local y = 100
    for i, car in ipairs(carShop) do
        if i == selectedCar then
            love.graphics.setColor(1, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        
        local status = car.owned and "[OWNED]" or "[FREE]"
        love.graphics.print(i .. ". " .. car.name .. " - Price: FREE " .. status, 100, y)
        y = y + 40
    end
    
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("[UP/DOWN] Navigate | [ENTER] Buy | [ESC] Back", 100, screenHeight - 60)
end

function drawTasks()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("DAILY TASKS", 0, 20, screenWidth, "center")
    
    love.graphics.setFont(love.graphics.newFont(14))
    local y = 100
    for _, task in ipairs(dailyTasks) do
        local status = task.completed and "[COMPLETED]" or "[PENDING]"
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Task " .. task.id .. ": " .. task.description, 100, y)
        love.graphics.print("Reward: $" .. task.reward .. " " .. status, 120, y + 25)
        y = y + 70
    end
    
    love.graphics.setColor(0.7, 0.7, 0.7)
    love.graphics.print("[ESC] Back", screenWidth - 150, screenHeight - 30)
end

function createParkingSpots()
    local cols = 5
    local rows = 3
    local spotIndex = 1
    
    for r = 1, rows do
        for c = 1, cols do
            table.insert(parkingSpots, {
                id = spotIndex,
                x = 50 + (c - 1) * 200,
                y = 150 + (r - 1) * 150,
                occupied = false
            })
            spotIndex = spotIndex + 1
        end
    end
end

function love.keypressed(key)
    if gameState == "menu" then
        if key == "p" then gameState = "playing"
        elseif key == "s" then gameState = "shop"
        elseif key == "t" then gameState = "tasks"
        elseif key == "q" then love.event.quit()
        end
    elseif gameState == "playing" then
        if key == "escape" then gameState = "menu"
        elseif key == "t" then gameState = "tasks"
        elseif key == "s" then gameState = "shop"
        end
    elseif gameState == "shop" then
        if key == "escape" then gameState = "menu"
        elseif key == "up" then
            selectedCar = selectedCar - 1
            if selectedCar < 1 then selectedCar = #carShop end
        elseif key == "down" then
            selectedCar = selectedCar + 1
            if selectedCar > #carShop then selectedCar = 1 end
        elseif key == "return" then
            carShop[selectedCar].owned = true
        end
    elseif gameState == "tasks" then
        if key == "escape" then gameState = "menu" end
    end
end
