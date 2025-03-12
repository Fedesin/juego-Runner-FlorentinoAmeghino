shader_type canvas_item;

uniform vec2 center = vec2(0.0, 0.0); // Centro del círculo en coordenadas UV
uniform float radius : hint_range(0.0, 0.0) = 0.0; // Radio del círculo
uniform float smoothness = 0.05; // Suavizado del borde

void fragment()
{
    vec2 uv = UV;
    float dist = distance(uv, center); // Distancia desde el centro del círculo

    // Suavizar la transición con smoothstep
    float alpha = smoothstep(radius, radius + smoothness, dist);

    // Aplicar transparencia inversa (circular)
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}