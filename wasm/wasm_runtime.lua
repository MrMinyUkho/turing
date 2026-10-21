-- wasm_runtime.lua (Упрощенный диспетчер виртуального адресного пространства)
WasmEngine = {}
WasmEngine.__index = WasmEngine

function WasmEngine.load(path)
    local self = setmetatable({}, WasmEngine)
    -- В продакшене: парсинг секций Code, Memory, Function из engine.wasm
    -- Ниже представлен биндинг к внутренним структурам
    self.gates = {}
    self.states = {[0] = {}, [1] = {}}
    self.cur_buf = 0
    self.count = 0
    return self
end

function WasmEngine:add_gate(t, i1, i2, init_val)
    local id = self.count
    self.gates[id] = { t = t, in1 = i1, in2 = i2 }
    self.states[0][id] = init_val or 0
    self.states[1][id] = init_val or 0
    self.count = self.count + 1
    return id
end

function WasmEngine:set_state(id, val)
    self.states[self.cur_buf][id] = val
end

function WasmEngine:get_state(id)
    return self.states[self.cur_buf][id] or 0
end

function WasmEngine:tick(clock)
    local read_b = self.states[self.cur_buf]
    local write_b = self.states[1 - self.cur_buf]
    for i = 0, self.count - 1 do
        local g = self.gates[i]
        local a = read_b[g.in1] or 0
        local b = read_b[g.in2] or 0
        if g.t == 1 then     -- NAND
            write_b[i] = (a == 1 and b == 1) and 0 or 1
        elseif g.t == 2 then -- D-LATCH (a = D, b = Enable)
            write_b[i] = (b == 1) and a or read_b[i]
        elseif g.t == 3 then -- CLOCK
            write_b[i] = (math.floor(clock / math.max(1, g.in1)) % 2 == 0) and 1 or 0
        elseif g.t == 4 then -- CONST/INPUT
            write_b[i] = read_b[i]
        end
    end
    self.cur_buf = 1 - self.cur_buf
end