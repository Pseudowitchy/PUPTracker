_addon.name = 'Puppet Tracker'
_addon.author = 'Pseudowitchy'
_addon.version = 0.3
_addon.command = 'pup'

require('luau')
require('queues')
res  = require('resources')
texts = require('texts')
local config = require('config')
local functions = require('functions')

-- Attachment Durations:
Flashbulb = 45
Flashbulb_Display = 0
Flashbulb_Count = 0
Flashbulb_Equipped = 0

Eraser = 30
Eraser_Display = 0
Eraser_Count = 0
Eraser_Equipped = 0

Strobe = 30
Strobe_Display = 0
Strobe_Count = 0
Strobe_Equipped = 0

HeatCapacitor = 90
HeatCapacitor_Display = 0
HeatCapacitor_Count = 0
HeatCapacitor_Equipped = 0

ShockAbsorber = 180
ShockAbsorber_Display = 0
ShockAbsorber_Count = 0
ShockAbsorber_Equipped = 0

Disruptor = 60
Disruptor_Display = 0
Disruptor_Count = 0
Disruptor_Equipped = 0

Regulator = 60
Regulator_Display = 0
Regulator_Count = 0
Regulator_Equipped = 0

Economizer = 180
Economizer_Display = 0
Economizer_Count = 0
Economizer_Equipped = 0

ManaConverter = 180
ManaConverter_Display = 0
ManaConverter_Count = 0
ManaConverter_Equipped = 0

BarrageTurbine = 180
BarrageTurbine_Display = 0
BarrageTurbine_Count = 0
BarrageTurbine_Equipped = 0

time_start = os.time()
pet_skills = ''
puppet_skills = ''

local defaults = {
    automatonname = Mademoiselle,
    
    font = Impact,
    fontsize = 30,   
    
    pos = {
        x = 100,
        y = 100},  
        
    bg = {
        alpha = 115,
        red = 0,
        green = 0,
        blue = 0},
    
    toggles = {
        draggable = false,
        right = false,
        bottom = false,
        bold = true,
        italics = false}
}

settings = config.load(defaults)
config.save(settings)

count_start = 0

label = [[ \cs(255, 115, 0) ==== Cooldowns ==== \cr
\cs(125, 125, 125)${puppet_skills|   - No Trackable Skills}]]

windower.register_event('login', function()
    windower.add_to_chat(8,'----- Puppet Tracker Loaded -----')
end)

windower.register_event('load', function()
    windower.add_to_chat(8,'----- Puppet Tracker Loaded -----')
end)

function windowSetup()
    
    local default_settings = T{}
    default_settings.pos = {}
    default_settings.pos.x = settings.pos.x
    default_settings.pos.y = settings.pos.y
    
    default_settings.bg = {}
    default_settings.bg.alpha = settings.bg.alpha
    default_settings.bg.red = settings.bg.red
    default_settings.bg.blue = settings.bg.blue
    default_settings.bg.green = settings.bg.green
    
    default_settings.flags = {}
    default_settings.flags.draggable = settings.toggles.draggable
    default_settings.flags.right = settings.toggles.right
    default_settings.flags.bottom = settings.toggles.bottom
    default_settings.flags.bold = settings.toggles.bold
    default_settings.flags.italics = settings.toggles.italics
    
    default_settings.text = {}
    default_settings.text.font = settings.font
    default_settings.text.size = settings.fontsize

    default_settings.text.fonts = {}
    default_settings.text.alpha = settings.fontcolor.alpha
    default_settings.text.red = settings.fontcolor.red
    default_settings.text.blue = settings.fontcolor.blue
    default_settings.text.green = settings.fontcolor.green
    
    default_settings.text.stroke = {}
    default_settings.text.stroke.width = 1
    default_settings.text.stroke.alpha = 100
    default_settings.text.stroke.red = 0
    default_settings.text.stroke.green = 0
    default_settings.text.stroke.blue = 0
    
    if not (window == nil) then --This should clear and then redefine what is in the hud
        texts.destroy(window)
    end
    window = texts.new('', default_settings)
    
    texts.append(window, label, default_settings)
        
    window:show() --Displays the hud hopefully.
end

windowSetup()

function check_flashbulb()
    if Flashbulb_Display > 0 then
        Flashbulb_Display = Flashbulb - (os.time() - Flashbulb_Count)
    end
end

function check_eraser()
    if Eraser_Display > 0 then
        Erase_Display = Eraser - (os.time() - Eraser_Count)
    end
end

function check_strobe()
    if Strobe_Display > 0 then
        Strobe_Display = Strobe - (os.time() - Strobe_Count)
    end
end

function check_heatcapacitor()
    if HeatCapacitor_Display > 0 then
        HeatCapacitor_Display = HeatCapacitor - (os.time() - HeatCapacitor_Count)
    end
end

function check_shockabsorber()
    if ShockAbsorber_Display > 0 then
        ShockAbsorber_Display = ShockAbsorber - (os.time() - ShockAbsorber_Count)
    end
end

function check_disruptor()
    if Disruptor_Display > 0 then
        Disruptor_Display = Disruptor - (os.time() - Disruptor_Count)
    end
end

function check_regulator()
    if Regulator_Display > 0 then
        Regulator_Display = Regulator - (os.time() - Regulator_Count)
    end
end

function check_economizer()
    if Economizer_Display > 0 then
        Economizer_Display = Economizer - (os.time() - Economizer_Count)
    end
end

function check_manaconverter()
    if ManaConverter_Display > 0 then
        ManaConverter_Display = ManaConverter - (os.time() - ManaConverter_Count)
    end
end

function check_barrageturbine()
    if BarrageTurbine_Display > 0 then
        BarrageTurbine_Display = BarrageTurbine - (os.time() - BarrageTurbine_Count)
    end
end

function updatePetSkills()
    -- if not pet.isvalid then
    --     return 
    -- end

    local pet_skills = ''
    
    texts.append(window, pet_skills)

    if Strobe_Equipped == 0 and HeatCapacitor_Equipped == 0 and Flashbulb_Equipped == 0 and Eraser_Equipped == 0 and ShockAbsorber_Equipped == 0 and
Disruptor_Equipped == 0 and Regulator_Equipped == 0 and Economizer_Equipped == 0 and ManaConverter_Equipped == 0 and BarrageTurbine_Equipped == 0 then
        pet_skills = "   - No Trackable Skills"
    else
        if Strobe_Equipped == 1 then
            if Strobe_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,0,0)Strobe: ●\\cr \n"
            elseif Strobe_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Strobe: (" .. Strobe_Display .. ")\\cr \n"
            end
        end
        if HeatCapacitor_Equipped == 1 then
            if HeatCapacitor_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,0,0)Heat Capacitor: ●\\cr \n"
            elseif HeatCapacitor_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Heat Capacitor: (" .. HeatCapacitor_Display .. ")\\cr \n"
            end
        end
        if Flashbulb_Equipped == 1 then
            if Flashbulb_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(175,175,175)Flashbulb: ●\\cr \n"
            elseif Flashbulb_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Flashbulb: (" .. Flashbulb_Display .. ")\\cr \n"
            end
        end
        if Eraser_Equipped == 1 then
            if Eraser_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(175,175,175)Eraser: ●\\cr \n"
            elseif Eraser_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Eraser: (" .. Eraser_Display .. ")\\cr \n"
            end
        end
        if ShockAbsorber_Equipped == 1 then
            if ShockAbsorber_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,125,0)Shock Absorber: ●\\cr \n"
            elseif ShockAbsorber_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Shock Absorber: (" .. ShockAbsorber_Display .. ")\\cr \n"
            end
        end
        if Disruptor_Equipped == 1 then
            if Disruptor_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,0,125)Disruptor: ●\\cr \n"
            elseif Disruptor_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Disruptor: (" .. Disruptor_Display .. ")\\cr \n"
            end
        end
        if Regulator_Equipped == 1 then
            if Regulator_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,0,125)Regulator: ●\\cr \n"
            elseif Regulator_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Regulator: (" .. Regulator_Display .. ")\\cr \n"
            end
        end
        if Economizer_Equipped == 1 then
            if Economizer_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,0,125)Economizer: ●\\cr \n"
            elseif Economizer_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Economizer: (" .. Economizer_Display .. ")\\cr \n"
            end
        end
        if ManaConverter_Equipped == 1 then
            if ManaConverter_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(125,0,125)Mana Converter: ●\\cr \n"
            elseif ManaConverter_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Mana Converter: (" .. ManaConverter_Display .. ")\\cr \n"
            end
        end
        if BarrageTurbine_Equipped == 1 then
            if BarrageTurbine_Display == 0 then
                pet_skills = pet_skills .. "\\cs(125, 125, 125) -\\cr \\cs(0,125,0)Barrage Turbine: ●\\cr \n"
            elseif BarrageTurbine_Display > 0 then
                pet_skills = pet_skills .. "\\cs(100, 100, 100) - Barrage Turbine: (" .. BarrageTurbine_Display .. ")\\cr \n"
            end
        end
    end

    window.puppet_skills = pet_skills

end

windower.register_event(
    "prerender",
    function()
        
        --Items we want to check every second
        if os.time() > time_start then
            time_start = os.time()
            
            check_flashbulb()
            check_strobe()
            check_heatcapacitor()
            check_shockabsorber()
            check_disruptor()
            check_regulator()
            check_economizer()
            check_manaconverter()
            check_barrageturbine()
            
            updatePetSkills()            
        end
    end
)

windower.register_event(
    "incoming text",
    function(original, modified, mode)
        
        if original:contains(settings.automatonname) then
            if original:contains("Erase") then
                Eraser_Count = os.time()
                Eraser_Display = Eraser
                Eraser_Equipped = 1
            elseif original:contains("Flashbulb") then
                Flashbulb_Count = os.time()
                Flashbulb_Display = Flashbulb
                Flashbulb_Equipped = 1
            elseif original:contains("Provoke") then
                Strobe_Count = os.time()
                Strobe_Display = Strobe
                Strobe_Equipped = 1
            elseif original:contains("Heat Capacitor") then
                HeatCapacitor_Count = os.time()
                HeatCapacitor_Display = HeatCapacitor
                HeatCapacitor_Equipped = 1
            elseif original:contains("Stoneskin") then
                ShockAbsorber_Count = os.time()
                ShockAbsorber_Display = ShockAbsorber
                ShockAbsorber_Equipped = 1
            elseif original:contains("Disruptor") then
                Disruptor_Count = os.time()
                Disruptor_Display = Disruptor
                Disruptor_Equipped = 1
            elseif original:contains("Regulator") then
                Regulator_Count = os.time()
                Regulator_Display = Regulator
                Regulator_Equipped = 1
            elseif original:contains("Economizer") then
                Economizer_Count = os.time()
                Economizer_Display = Economizer
                Economizer_Equipped = 1
            elseif original:contains("Convert") then
                ManaConverter_Count = os.time()
                ManaConverter_Display = ManaConverter
                ManaConverter_Equipped = 1
            elseif original:contains("Barrage Turbine") then
                BarrageTurbine_Count = os.time()
                BarrageTurbine_Display = BarrageTurbine
                BarrageTurbine_Equipped = 1
            else
                return
            end
        end
    end
)
