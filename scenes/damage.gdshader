shader_type canvas_item;

uniform vec3 shock_color : source_color = vec3(1.0, 0.0, 0.0);
uniform float amplitude = 0.0;
uniform float frequency = 10.0;
uniform float shock_progress = 0.0; // Controla la intensidad del efecto

void vertex() {
    VERTEX.x += amplitude * shock_progress * sin(frequency * shock_progress);
}

void fragment() {
    vec3 normal_color = texture(TEXTURE, UV).rgb;
    COLOR.rgb = normal_color + shock_color * shock_progress;
}