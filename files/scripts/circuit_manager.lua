dofile_once("mods/turing/wasm/wasm_runtime.lua")

CircuitMgr = {
    sim = WasmEngine.load("mods/turing/wasm/engine.wasm"),
    wires = {},
    gates = {},
    sim_ticks_per_frame = 1,
    clock_counter = 0,
    active_wire_start = nil -- Для ведьмочки при прокладке провода
}

function CircuitMgr:SpawnGate(gate_type, x, y, extra_param)
    local entity_file = "mods/turing/files/entities/base_gate.xml"
    if gate_type == 1 then entity_file = "mods/turing/files/entities/gate_nand.xml"
    elseif gate_type == 2 then entity_file = "mods/turing/files/entities/gate_dlatch.xml"
    elseif gate_type == 3 then entity_file = "mods/turing/files/entities/gate_clock.xml"
    end

    local ent = EntityLoad(entity_file, x, y)
    local gate_id = self.sim:add_gate(gate_type, extra_param or 0, 0, 0)
    
    -- Привязка ID к сущности
    local vars = EntityGetComponent(ent, "VariableStorageComponent") or {}
    for _, v in ipairs(vars) do
        if ComponentGetValue2(v, "name") == "gate_id" then
            ComponentSetValue2(v, "value_int", gate_id)
        end
    end

    self.gates[gate_id] = { entity = ent, type = gate_type, x = x, y = y }
    return gate_id, ent
end

function CircuitMgr:Connect(src_id, dst_id, dst_pin, color_rgb)
    table.insert(self.wires, {
        from = src_id,
        to = dst_id,
        pin = dst_pin, -- 1 = in1, 2 = in2
        color = color_rgb or {0.2, 0.8, 1.0}
    })
    
    -- Перенаправление входов в симуляторе
    local g = self.sim.gates[dst_id]
    if g then
        if dst_pin == 1 then g.in1 = src_id else g.in2 = src_id end
    end
end

function CircuitMgr:Update()
    -- Выполнение тактов симулятора
    for _ = 1, self.sim_ticks_per_frame do
        self.clock_counter = self.clock_counter + 1
        self.sim:tick(self.clock_counter)
    end

    -- Frustum culling и подготовка буфера для шейдера
    local cam_x, cam_y = GameGetCameraPos()
    local screen_w, screen_h = 1280, 720 -- Стандартные габариты вьюпорта

    -- Здесь передаются координаты в шейдер проводов через ShaderSetGlobal
    -- При незамкнутом проводе конечной точкой выступают координаты игрока
    if self.active_wire_start then
        local player = EntityGetWithTag("player_unit")[1]
        if player then
            local px, py = EntityGetTransform(player)
            local sx, sy = self.gates[self.active_wire_start].x, self.gates[self.active_wire_start].y
            -- Включение временного провода в рендер-список
        end
    end
end