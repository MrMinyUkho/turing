local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

-- Радиус клика
local targets = EntityGetInRadiusWithTag(x, y, 12, "logic_input")
for _, target in ipairs(targets) do
    local vars = EntityGetComponent(target, "VariableStorageComponent") or {}
    for _, v in ipairs(vars) do
        if ComponentGetValue2(v, "name") == "gate_id" then
            local gid = ComponentGetValue2(v, "value_int")
            local cur = CircuitMgr.sim:get_state(gid)
            CircuitMgr.sim:set_state(gid, cur == 1 and 0 or 1)
            GamePrint("Состояние изменено: " .. tostring(1 - cur))
        end
    end
end
EntityKill(entity_id)