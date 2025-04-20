function love.load()
    love.window.setMode(800, 600, {resizable=false, vsync=false})
    love.window.setTitle("Game")

    fpsFont = love.graphics.newFont("/font/Dashhorizon-eZ5wg.otf",20)

    width, height = love.graphics.getDimensions()

    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    player = {}
        player.x = 100
        player.y = 300
        player.width = 50
        player.height = 50
        player.vx = 0
        player.vy = 0
        player.onGround = true
        player.jumpPower = -300
        player.gravity = 800
        player.isJumping = false
        player.jumpTime = 0
        player.maxJumpTime = 0.4

        player.left = player.x
        player.right = player.x + player.width
        player.top = player.ya
        player.bottom = player.y + player.height

        player.acceleration = 4000
        player.maxSpeed = 300
        player.friction = 1000

    ground = {}
        ground.x = 50
        ground.y = 500
        ground.width = width - 100
        ground.height = 20
        ground.left = ground.x
        ground.right = ground.x + ground.width
        ground.top = ground.y
        ground.bottom = ground.y + ground.height

end

function love.update(dt)
    Movement(dt)
    CheckCollision(dt)
    Collision()
    direction = math.abs(joystick:getGamepadAxis("leftx"))
end


function love.draw()
    love.graphics.setFont(fpsFont)
    love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    love.graphics.rectangle("fill", ground.x, ground.y, ground.width, ground.height)
    love.graphics.print(tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("direction: " .. tostring(direction), 10, 30)
end

function Movement(dt)
    if joystick:isDown(1) and player.onGround then
        player.vy = player.jumpPower
        player.onGround = false
        player.isJumping = true
        player.jumpTime = 0
    end
    -- if love.keyboard.isDown("space") and player.onGround then
    --     player.vy = player.jumpPower
    --     player.onGround = false
    --     player.isJumping = true
    --     player.jumpTime = 0
    -- end

    if not player.onGround then
        player.vy = player.vy + player.gravity * dt
    end
    
    if player.isJumping then
        player.jumpTime = player.jumpTime + dt
        if player.jumpTime < player.maxJumpTime and joystick:isDown(1) then
            player.vy = player.jumpPower
        else
            player.isJumping = false
        end
    end

    
    if love.keyboard.isDown("a") then
        player.vx = player.vx -player.acceleration * dt
    elseif love.keyboard.isDown("d") then
        player.vx = player.vx + player.acceleration * dt
    end

    if player.vx > 0 then
        player.vx = player.vx - player.friction * dt
        if player.vx < 0 then player.vx = 0 end
    elseif player.vx < 0 then
        player.vx = player.vx + player.friction * dt
        if player.vx > 0 then player.vx = 0 end
    end
    if player.vx > player.maxSpeed then
        player.vx = player.maxSpeed
    elseif player.vx < -player.maxSpeed then
        player.vx = -player.maxSpeed
    end

    player.x = player.x + player.vx * dt
    player.y = player.y + player.vy * dt

end

function Collision()
    if player.right > ground.left and player.left < ground.right and player.bottom > ground.top and player.top < ground.bottom then
        player.vy = 0
        player.onGround = true
        player.isJumping = false
    else
        player.onGround = false
    end
end

function CheckCollision(dt)
    player.left = player.x
    player.right = player.x + player.width
    player.top = player.y
    player.bottom = player.y + player.height

    ground.left = ground.x
    ground.right = ground.x + ground.width
    ground.top = ground.y
    ground.bottom = ground.y + ground.height

    if player.bottom > ground.top and player.onGround == true then
        player.y = ground.top - player.height
    end
end