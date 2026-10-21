uniform sampler2D tex_bg;
uniform vec2 window_size;
uniform vec2 camera_pos;
uniform float time;

// Буфер линий: X1, Y1, X2, Y2, R, G, B, State
const int MAX_WIRES = 128;
uniform vec4 wire_coords[MAX_WIRES]; 
uniform vec4 wire_styles[MAX_WIRES]; // rgb = цвет, w = сигнал (0 или 1)
uniform int wire_count;

// Функция расстояния до отрезка
float dist_to_segment(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

void main() {
    vec2 screen_uv = gl_FragCoord.xy / window_size;
    vec2 world_pos = camera_pos + (gl_FragCoord.xy - window_size * 0.5);

    vec4 color = texture2D(tex_bg, screen_uv);

    for (int i = 0; i < MAX_WIRES; i++) {
        if (i >= wire_count) break;

        vec2 p1 = wire_coords[i].xy;
        vec2 p2 = wire_coords[i].zw;
        
        float d = dist_to_segment(world_pos, p1, p2);
        if (d < 1.2) { // Толщина провода в 1.2 пикселя
            vec3 wire_col = wire_styles[i].rgb;
            float signal = wire_styles[i].w;

            // Если провод под напряжением, делаем его ярче
            if (signal > 0.5) {
                wire_col += vec3(0.4, 0.4, 0.4);
            } else {
                wire_col *= 0.35; // Затемнение пассивного провода
            }
            color.rgb = mix(color.rgb, wire_col, 0.95);
        }
    }

    gl_FragColor = color;
}