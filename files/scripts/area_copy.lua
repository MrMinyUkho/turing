local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

-- Радиус зависит от времени жизни барьера (модификаторы длительности)
local proj_comp = EntityGetFirstComponent(entity_id, "ProjectileComponent")
local lifetime = ComponentGetValue2(proj_comp, "lifetime")
local radius = math.max(32, lifetime * 1.5)

local enclosed_gates = EntityGetInRadiusWithTag(x, y, radius, "logic_gate")
if #enclosed_gates > 0 then
    local blueprint_data = { gates = {}, relative_wires = {} }
    
    for _, ent in ipairs(enclosed_gates) do
        local gx, gy = EntityGetTransform(ent)
        -- Сериализация относительных смещений
        table.insert(blueprint_data.gates, {
            dx = gx - x,
            dy = gy - y,
            type = 1 -- тип из VariableStorageComponent
        })
    end
    
    -- Спавн книги/кристалла чертежа в инвентарь игрока
    local player = EntityGetWithTag("player_unit")[1]
    if player then
        local bp_entity = EntityLoad("mods/turing/files/entities/blueprint_item.xml", x, y)
        -- Запись blueprint_data в строковый сериализатор сущности
        GamePickUpInventoryItem(player, bp_entity, false)
        GamePrint("Кусок схемы скопирован: " .. #blueprint_data.gates .. " элементов.")
    end
end