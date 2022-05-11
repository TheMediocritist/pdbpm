import "CoreLibs/graphics"
local gfx = playdate.graphics
local pdbpm = import "lib/pdbpm"

gfx.setColor(gfx.kColorBlack)

function load()
beat = 1
  lastUpdateTime = 0
  paused = false
  pulse = 0
  -- Init new Track object and start playing
  samplePlayer = playdate.sound.sampleplayer.new("assets/demo_loop.wav")
  music = pdbpm.newTrack(samplePlayer)
    :load(samplePlayer)
    :setBPM(127)
    :setLooping(true)
    :on("beat", function(n)
      local r, g, b = math.random(255), math.random(255), math.random(255)
      pulse = 1
    end)
    :play()
end

function draw()

    gfx.clear()
    local w, h = 400, 240
    
    -- Draw circle
    local radius = 30 + (pulse)^3 * 100
    gfx.setLineWidth(4)
    gfx.drawCircleAtPoint( w / 2, h / 2, radius)
    
    -- Get current beat and subbeat with 4x multiplier
    local beat, subbeat = music:getBeat(4)
    
    gfx.setLineWidth(8)
    -- Draw 4x subbeat progress arc
    local angle1 = -180 * subbeat
    local angle2 = 180 * subbeat
    gfx.setColor(gfx.kColorWhite)
    gfx.drawArc(w / 2, h / 2, radius, angle1, angle2)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawArc(w / 2, h / 2, 30, angle2, angle1)
    
    -- Get current beat and subbeat
    local beat, subbeat = music:getBeat()
    
    -- Draw current beat number
    font = gfx.font.new("assets/Asheville-Sans-14-Bold")
    gfx.setFont(font)
    gfx.drawTextAligned(beat, 200, 112, kTextAlignment.center)
end

load()


function playdate.update()
    gfx.clear()
    local t = playdate.getCurrentTimeMilliseconds()
    dt = (t - lastUpdateTime)/1000 --and (t - lastUpdateTime) or 0
    lastUpdateTime = t
    
    music:update(dt)
    pulse = math.max(0, pulse - dt) 
    draw(dt)
    playdate.drawFPS(0,0)
    
end
