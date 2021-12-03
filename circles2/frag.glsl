precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

float circle( vec2 coord, float radius ) {
    float dist = distance(coord, vec2(0.5));
    return smoothstep(radius + 0.001, radius - 0.001, dist);
}

float circleOutline(vec2 coord, float outerRadius, float thickness) {
    float outer = circle(coord, outerRadius);
    float inner = circle(coord, outerRadius - thickness);

    return outer - inner;
}

void main() {

    vec2 coord = vTexCoord;

    float edge = fract(u_time * 0.005) * 2.0;
    float radius = fract(u_time * 0.005) * 0.5;

    float edge2 = fract(u_time * 0.005 - 0.3) * 2.0;
    float edge3 = fract(u_time * 0.005 - 0.6) * 2.0;
    float radius3 = fract(u_time * 0.005 - 0.3) * 0.5;

    float r = circleOutline(coord, edge, radius) + circleOutline(coord, edge2, radius) + circleOutline(coord, edge3, radius3);
    float b = r * coord.x;
    float g = r * coord.y;
    gl_FragColor = vec4(r, g, b, 1.0);

}