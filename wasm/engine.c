#define MAX_GATES 65536

// Типы элементов
#define TYPE_NAND    1
#define TYPE_DLATCH  2
#define TYPE_CLOCK   3
#define TYPE_CONST   4

static unsigned char type[MAX_GATES];
static unsigned short in1[MAX_GATES];
static unsigned short in2[MAX_GATES];

// Двойная буферизация
static unsigned char state_buf[2][MAX_GATES];
static int cur_buf = 0;
static int gate_count = 0;

void* memset(void* dest, int c, unsigned long n) {
    unsigned char* p = (unsigned char*)dest;
    while (n--) {
        *p++ = (unsigned char)c;
    }
    return dest;
}

void init_engine(void) {
    gate_count = 0;
    cur_buf = 0;
    for (int i = 0; i < MAX_GATES; i++) {
        state_buf[0][i] = 0;
        state_buf[1][i] = 0;
        type[i] = 0;
    }
}

int add_gate(int g_type, int input1, int input2, int initial_val) {
    if (gate_count >= MAX_GATES) return -1;
    int id = gate_count++;
    type[id] = (unsigned char)g_type;
    in1[id] = (unsigned short)input1;
    in2[id] = (unsigned short)input2;
    state_buf[0][id] = (unsigned char)initial_val;
    state_buf[1][id] = (unsigned char)initial_val;
    return id;
}

void set_gate_input(int id, int val) {
    if (id < gate_count) {
        state_buf[cur_buf][id] = (unsigned char)(val ? 1 : 0);
    }
}

int get_gate_state(int id) {
    if (id >= gate_count) return 0;
    return state_buf[cur_buf][id];
}

// 1 такт симуляции
void tick(int clock_tick) {
    int next_buf = 1 - cur_buf;
    unsigned char* read_state = state_buf[cur_buf];
    unsigned char* write_state = state_buf[next_buf];

    for (int i = 0; i < gate_count; i++) {
        unsigned char t = type[i];
        unsigned char a = read_state[in1[i]];
        unsigned char b = read_state[in2[i]];

        switch (t) {
            case TYPE_NAND:
                // Базис Шеффера: 0 только когда оба 1
                write_state[i] = !(a && b);
                break;

            case TYPE_DLATCH:
                // in1 = Data (D), in2 = Enable (E)
                // Если E=1, пропускаем D, иначе держим старое состояние
                write_state[i] = b ? a : read_state[i];
                break;

            case TYPE_CLOCK:
                // in1 = делитель частоты
                if (in1[i] == 0) {
                    write_state[i] = (unsigned char)(clock_tick & 1);
                } else {
                    write_state[i] = (unsigned char)((clock_tick / in1[i]) & 1);
                }
                break;

            case TYPE_CONST:
            default:
                // Для интерактивных кнопок/рычагов сохраняем значение
                write_state[i] = read_state[i];
                break;
        }
    }
    cur_buf = next_buf;
}