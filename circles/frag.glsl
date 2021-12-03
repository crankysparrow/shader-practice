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

    float r = circleOutline(coord, 0.4, 0.1);
    float b = r * coord.x;
    float g = r * coord.y;
    gl_FragColor = vec4(r, g, b, 1.0);

}