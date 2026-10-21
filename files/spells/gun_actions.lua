table.insert(actions, {
    id          = "CIRCUIT_WIRE_TOOL",
    name        = "Трассировщик цепи",
    description = "Соединяет входы и выходы логических вентилей. Применяет цветовые модификаторы.",
    sprite      = "mods/turing/files/spells/icons/wire_tool.png",
    type        = ACTION_TYPE_UTILITY,
    spawn_level                       = "1,2,3,4",
    spawn_probability                 = "1.0,1.0,1.0,1.0",
    price       = 100,
    mana        = 5,
    action      = function()
        add_projectile("mods/turing/files/entities/projectiles/action_wire.xml")
        c.fire_rate_wait = c.fire_rate_wait + 10
    end,
})

table.insert(actions, {
    id          = "CIRCUIT_FINGER",
    name        = "Палец тыканья",
    description = "Нажимает кнопки и переключает рычаги на расстоянии в точке прицела.",
    sprite      = "mods/turing/files/spells/icons/finger.png",
    type        = ACTION_TYPE_UTILITY,
    spawn_level = "1,2",
    spawn_probability = "0.8,0.8",
    price       = 120,
    mana        = 2,
    action      = function()
        add_projectile("mods/turing/files/entities/projectiles/action_finger.xml")
    end,
})

table.insert(actions, {
    id          = "CIRCUIT_AREA_COPY",
    name        = "Барьер слепка схемы",
    description = "Создает поле, которое упаковывает все вентили внутри в предмет-шаблон.",
    sprite      = "mods/turing/files/spells/icons/copy_barrier.png",
    type        = ACTION_TYPE_UTILITY,
    spawn_level = "3,4,5",
    spawn_probability = "0.5,0.5,0.5",
    price       = 250,
    mana        = 50,
    action      = function()
        add_projectile("mods/turing/files/entities/projectiles/barrier_copy.xml")
    end,
})

table.insert(actions, {
    id          = "CIRCUIT_SPEED_UP",
    name        = "Ускорение такта",
    description = "Удваивает количество суб-тиков логики за один кадр.",
    sprite      = "mods/turing/files/spells/icons/speed_up.png",
    type        = ACTION_TYPE_MODIFIER,
    spawn_level = "2,3,4",
    spawn_probability = "0.6,0.6,0.6",
    price       = 150,
    mana        = 10,
    action      = function()
        CircuitMgr.sim_ticks_per_frame = math.min(128, CircuitMgr.sim_ticks_per_frame * 2)
        c.fire_rate_wait = c.fire_rate_wait + 5
    end,
})