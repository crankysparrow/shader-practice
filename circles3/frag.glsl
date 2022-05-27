precision mediump float;

varying vec2 vTexCoord;
varying vec3 vPosition;

uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform float u_time;

void main() {

    vec2 coord = vTexCoord;

    // float pct = 1.0 - (distance(coord, vec2(0.4)) + distance(coord, vec2(0.7, 0.9)));
    float one = distance(coord, vec2(0.4));
    float two = distance(coord, vec2(0.6));
    // float pct = step(0.5, one) + step(0.5, two);
    float pct = one + two;
    // float col = step(0.0, pct);
    float col = pct;

    gl_FragColor = vec4(col, col, col, 1.0);
}