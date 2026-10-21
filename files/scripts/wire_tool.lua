function shot(projectile_id)
    local px, py = EntityGetTransform(projectile_id)
    local nearby = EntityGetInRadiusWithTag(px, py, 20.0, "logic_gate")

    if #nearby > 0 then
        local target_gate = nearby[1]
        local gate_id = -1
        local vars = EntityGetComponent(target_gate, "VariableStorageComponent") or {}
        for _, v in ipairs(vars) do
            if ComponentGetValue2(v, "name") == "gate_id" then
                gate_id = ComponentGetValue2(v, "value_int")
            end
        end

        -- Определение цвета по наличию экстра-модификаторов на снаряде
        local color = {0.2, 0.8, 1.0} -- Дефолтный голубой
        if GameHasFlagRun("spell_color_red") then color = {1.0, 0.1, 0.1} end
        if GameHasFlagRun("spell_color_green") then color = {0.1, 1.0, 0.2} end

        if not CircuitMgr.active_wire_start then
            -- Выбран первый конец — провод начинает тянуться к игроку
            CircuitMgr.active_wire_start = gate_id
            CircuitMgr.active_color = color
            GamePrint("Вход/выход выбран. Проложите провод ко второму контакту.")
        else
            -- Соединение замкнуто
            if CircuitMgr.active_wire_start ~= gate_id then
                CircuitMgr:Connect(CircuitMgr.active_wire_start, gate_id, 1, CircuitMgr.active_color)
                GamePrint("Цепь замкнута.")
            end
            CircuitMgr.active_wire_start = nil
        end
    end
end