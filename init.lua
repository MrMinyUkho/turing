dofile_once("mods/turing/files/scripts/circuit_manager.lua")

function OnModInit()
    print("Logic Circuits: Мод инициализирован.")
end

function OnMagicNumbersAndWorldSeedInitialized()
    -- Добавление шейдера постобработки в стек рендеринга
    -- Noita загрузит шейдер поверх сцены
end

function OnPlayerSpawned(player_entity)
    local x, y = EntityGetTransform(player_entity)
    
    -- Спавним плоскость рендера проводов
    EntityLoad("mods/turing/files/entities/wire_line.xml", x, y)

    -- Список ID спеллов из вашего gun_actions.lua
    local test_spells = {
        "CIRCUIT_WIRE_TOOL",
        "CIRCUIT_FINGER",
        "CIRCUIT_AREA_COPY",
        "CIRCUIT_SPEED_UP",
    }

    -- Выбрасываем спеллы в виде карточек рядом с игроком
    for i, action_id in ipairs(test_spells) do
        CreateItemActionEntity(action_id, x + (i * 16) - 30, y - 10)
    end

    -- Визуальное подтверждение на экране
    GamePrint("Logic Circuits: тестовые спеллы выданы!")
end

function OnWorldPreUpdate()
    -- Шаг логической симуляции перед расчетом физики мира
    CircuitMgr:Update()
end

-- Регистрация всех спеллов мода в пуле палочек
ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/turing/files/spells/gun_actions.lua")